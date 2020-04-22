#!/bin/bash
###############################################################################
### Installing Arch Software By:                                               ###
### Erik Sundquist                                                          ###
###############################################################################
### Review and edit before using                                            ###
###############################################################################

set -e

clear
echo "################################################################################"
echo "### Installing applications                                                  ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed playonlinux
sudo pacman -S --noconfirm --needed winetricks
sudo pacman -S --noconfirm --needed audacity
sudo pacman -S --noconfirm --needed clementine
sudo pacman -S --noconfirm --needed handbrake
sudo pacman -S --noconfirm --needed kdenlive
sudo pacman -S --noconfirm --needed obs-studio
sudo pacman -S --noconfirm --needed openshot
sudo pacman -S --noconfirm --needed vlc
sudo pacman -S --noconfirm --needed shotcut
sudo pacman -S --noconfirm --needed darktable
sudo pacman -S --noconfirm --needed gimp
sudo pacman -S --noconfirm --needed inkscape
sudo pacman -S --noconfirm --needed krita
sudo pacman -S --noconfirm --needed librecad
sudo pacman -S --noconfirm --needed luminancehdr
sudo pacman -S --noconfirm --needed cura
sudo pacman -S --noconfirm --needed rust rust-docs rust-racer eclipse-rust uncrustify
sudo pacman -S --noconfirm --needed atom
sudo pacman -S --noconfirm --needed firefox
sudo pacman -S --noconfirm --needed hexchat
sudo pacman -S --noconfirm --needed syncthing-gtk
sudo pacman -S --noconfirm --needed teamspeak3
sudo pacman -S --noconfirm --needed telegram-desktop
sudo pacman -S --noconfirm --needed transmission-gtk
sudo pacman -S --noconfirm --needed steam steam-native-runtime
sudo pacman -S --noconfirm --needed homebank
sudo pacman -S --noconfirm --needed libreoffice-fresh
sudo pacman -S --noconfirm --needed dconf-editor
sudo pacman -S --noconfirm --needed virt-manager
sudo pacman -S --noconfirm --needed ebtables iptables
sudo pacman -S --noconfirm --needed dnsmasq
sudo pacman -S --noconfirm --needed virglrenderer
sudo pacman -S --noconfirm --needed qemu-arch-extra
sudo pacman -S --noconfirm --needed qemu-guest-agent
sudo systemctl enable libvirtd.service
sudo systemctl enable virtlogd.service
sudo sed -i '/\[global\]'/a'Environment="LD_LIBRARY_PATH=/usr/lib"' /etc/systemd/system/multi-user.target.wants/libvirtd.service
#sed -e '/"Type=simple"'/a'Environment="LD_LIBRARY_PATH=/usr/lib"' /etc/systemd/system/multi-user.target.wants/libvirtd.service
sudo pacman -S --noconfirm --needed pacmanlogviewer
sudo pacman -S --noconfirm --needed exfat-utils
sudo pacman -S --noconfirm --needed meld
sudo pacman -S --noconfirm --needed cool-retro-term
sudo pacman -S --noconfirm --needed blender
sudo pacman -S --noconfirm --needed hardinfo
sudo pacman -S --noconfirm --needed openscad
sudo pacman -S --noconfirm --needed quodlibet
sudo pacman -S --noconfirm --needed deluge
sudo pacman -S --noconfirm --needed extremetuxracer
sudo pacman -S --noconfirm --needed supertux
sudo pacman -S --noconfirm --needed supertuxkart
sudo pacman -S --noconfirm --needed plank
#sudo pacman -S --noconfirm --needed cairo-dock cairo-dock-plug-ins
#sudo pacman -S --noconfirm --needed virtualbox
#sudo pacman -S --noconfirm --needed virtualbox-guest-iso
yay -S --noconfirm --needed makemkv
yay -S --noconfirm --needed drawio-desktop
yay -S --noconfirm --needed dxvk-bin
yay -S --noconfirm --needed skypeforlinux-preview-bin
yay -S --noconfirm --needed zoom
yay -S --noconfirm --needed mintstick-git
#yay -S --noconfirm --needed imagewriter-git
yay -S --noconfirm --needed isomaster
yay -S --noconfirm --needed timeshift
yay -S --noconfirm --needed stacer
yay -S --noconfirm --needed mattercontrol
yay -S --noconfirm --needed olive
yay -S --noconfirm --needed discord
yay -S --noconfirm --needed gamemode lib32-gamemode
yay -S --noconfirm --needed multibootusb-git
yay -S --noconfirm --needed plank-theme-arc plank-theme-numix plank-theme-namor unity-like-plank-theme
#yay -S --noconfirm --needed cairo-dock-themes cairo-dock-plug-ins-extras
yay -S --noconfirm --needed protontricks
yay -S --noconfirm --needed ovmf
yay -S --noconfirm --needed cinelerra-cv
yay -S --noconfirm --needed virtio-win
yay -S --noconfirm --needed libguestfs
#yay -S --noconfirm --needed freecad-appimage
#yay -S --noconfirm --needed edex-ui-git
#yay -S --noconfirm --needed virtualbox-ext-oracle

echo "options kvm-intel nested=1" | sudo tee /etc/modprobe.d/kvm-intel.conf

clear
echo "################################################################################"
echo "Do you want to install Make Human?"
echo "Desc: Create 3d models of humans."
echo "AUR Install.  Takes a while to install."
echo "1) Yes"
echo "2) No"
echo "################################################################################"
read case;

case $case in
    1)
      echo "You selected Yes"
        yay -S --noconfirm --needed makehuman
      ;;
    2)
      echo "You selected no"
      ;;
esac

echo "################################################################################"
echo "### Installing of applications completed                                     ###"
echo "################################################################################"
sleep 2
