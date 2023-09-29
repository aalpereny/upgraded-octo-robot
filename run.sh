#!/bin/bash
echo "#####################################"
echo "### İnstalling and setup opendoas ###"
echo "#####################################"
sudo dnf install doas
sudo rm -rfv /etc/doas.conf
sudo touch /etc/doas.conf
sudo bash -c "echo 'permit setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} $(whoami)' >> /etc/doas.conf"
sudo bash -c "echo 'permit setenv { XAUTHORITY LANG LC_ALL } $(whoami)' >> /etc/doas.conf"
doas -C /etc/doas.conf && echo "config ok" || echo "config error" 
read -p "Press any key to continue if doas configuration correct."
sudo chown -c root:root /etc/doas.conf
sudo chmod -c 0400 /etc/doas.conf
sudo mv -v /usr/bin/sudo /usr/bin/sudo.bak
doas ln -sv /usr/bin/doas /usr/bin/sudo
read -p "Press any key to continue if configuration correct."

echo "######################################"
echo "### Setting Up KDE Plasma and SDDM ###"
echo "######################################"
sudo dnf install @critical-path-kde dolphin kde-gtk-config sddm-kcm alacritty kde-connect kde-partitionmanager kate sddm-breeze thunderbird
sudo systemctl set-default graphical.target
read -p "Press any key to continue if configuration correct."

echo "####################################"
echo "#### İnstall KDE Connect and UFW ###"
echo "####################################"
sudo dnf install ufw kde-connect
sudo ufw enable
sudo ufw allow 1714:1764/udp
sudo ufw allow 1714:1764/tcp
sudo ufw reload
read -p "Press any key to continue if configuration correct."

echo "############################"
echo "### İnstalling Librewolf ###"
echo "############################"
sudo dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo
sudo dnf install librewolf
read -p "Press any key to continue if configuration correct."

echo "##############################"
echo "### İnstalling Gaming Env. ###"
echo "##############################"
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install steam lutris discord mangohud gamemode goverlay protontricks
read -p "Press any key to continue if configuration correct."

echo "#####################################"
echo "### İnstalling and setup CoreCtrl ###"
echo "#####################################"
sudo dnf install corectrl
sudo grubby --update-kernel=ALL --args='amdgpu.ppfeaturemask=0xffffffff amd_iommu=on iommu=pt'
sudo touch /etc/polkit-1/rules.d/90-corectrl.rules
echo 'polkit.addRule(function(action, subject) {
    if ((action.id == "org.corectrl.helper.init" ||
         action.id == "org.corectrl.helperkiller.init") &&
        subject.local == true &&
        subject.active == true &&
        subject.isInGroup($USER)) {
            return polkit.Result.YES;
    }
});
' | sudo tee -a /etc/polkit-1/rules.d/90-corectrl.rules
read -p "Press any key to continue if configuration correct."

echo "#############################################"
echo "### Copy and activate auto system updates ###"
echo "#############################################"
sudo cp -v services/startupsecupdate.service /etc/systemd/system/
sudo cp -v services/systemupdate.service /etc/systemd/system/
sudo cp -v services/systemupdate.timer /etc/systemd/system/
sudo systemctl enable startupsecupdate.service
sudo systemctl enable systemupdate.timer
read -p "Press any key to continue if configuration correct."
