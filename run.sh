#!/bin/bash
sudo sh -c "dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo && \
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm && \
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
dnf install doas which @critical-path-kde kde-gtk-config sddm-kcm steam lutris librewolf discord alacritty kde-connect ufw kde-partitionmanager protontricks kate thunderbird mangohud gamemode goverlay wget sddm-breeze && \
ufw allow 1714:1764/udp && ufw allow 1714:1764/tcp && ufw reload && \
wget https://github.com/Umio-Yasuno/amdgpu_top/releases/download/v0.2.0/amdgpu_top-0.2.0-1.x86_64.rpm && dnf install amdgpu_top-0.2.0-1.x86_64.rpm && \
grubby --update-kernel=ALL --args='amdgpu.ppfeaturemask=0xffffffff amd_iommu=on iommu=pt' && \
rm -rfv /etc/doas.conf && \
touch /etc/doas.conf && \
echo 'permit setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} $USER' | tee -a /etc/doas.conf && \
echo 'permit setenv { XAUTHORITY LANG LC_ALL } $USER' | tee -a /etc/doas.conf && \
chown -c root:root /etc/doas.conf && \
chmod -c 0400 /etc/doas.conf && \
doas -C /etc/doas.conf && echo 'config ok' && echo 'config error' &&\
mv -v /usr/bin/sudo /usr/bin/sudo.bak && \
ln -sv /usr/bin/doas /usr/bin/sudo && \
cp -v services/startupsecupdate.service /etc/systemd/system/ && \
cp -v services/systemupdate.service /etc/systemd/system/ && \
cp -v services/systemupdate.timer /etc/systemd/system/ && \
systemctl enable startupsecupdate.service && \
systemctl enable systemupdate.timer && \
systemctl enable systemupdate.service && \
systemctl set-default graphical.target && \
systemctl enable sddm"
