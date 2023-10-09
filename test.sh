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
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo
sudo dnf install @critical-path-kde dolphin kde-gtk-config sddm-kcm alacritty kde-connect kde-partitionmanager kate sddm-breeze thunderbird steam lutris discord mangohud gamemode goverlay protontricks plasma-firewall corectrl librewolf
sudo systemctl set-default graphical.target
sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect
sudo firewall-cmd --reload
sudo dnf install librewolf
read -p "Press any key to continue if configuration correct."
sudo grubby --update-kernel=ALL --args='amdgpu.ppfeaturemask=0xffffffff'
