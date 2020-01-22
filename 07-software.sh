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
sudo pacman -S --noconfirm --needed --asdeps playonlinux
sudo pacman -S --noconfirm --needed --asdeps winetricks
sudo pacman -S --noconfirm --needed --asdeps audacity
sudo pacman -S --noconfirm --needed --asdeps clementine
sudo pacman -S --noconfirm --needed --asdeps handbrake
sudo pacman -S --noconfirm --needed --asdeps kdenlive
sudo pacman -S --noconfirm --needed --asdeps obs-studio
sudo pacman -S --noconfirm --needed --asdeps openshot
sudo pacman -S --noconfirm --needed --asdeps vlc
sudo pacman -S --noconfirm --needed --asdeps shotcut
sudo pacman -S --noconfirm --needed --asdeps darktable
sudo pacman -S --noconfirm --needed --asdeps gimp
sudo pacman -S --noconfirm --needed --asdeps inkscape
sudo pacman -S --noconfirm --needed --asdeps krita
sudo pacman -S --noconfirm --needed --asdeps librecad
sudo pacman -S --noconfirm --needed --asdeps luminancehdr
sudo pacman -S --noconfirm --needed --asdeps cura
sudo pacman -S --noconfirm --needed --asdeps rust rust-docs rust-racer eclipse-rust uncrustify
sudo pacman -S --noconfirm --needed --asdeps atom
sudo pacman -S --noconfirm --needed --asdeps firefox
sudo pacman -S --noconfirm --needed --asdeps hexchat
sudo pacman -S --noconfirm --needed --asdeps syncthing-gtk
sudo pacman -S --noconfirm --needed --asdeps teamspeak3
sudo pacman -S --noconfirm --needed --asdeps telegram-desktop
sudo pacman -S --noconfirm --needed --asdeps transmission-gtk
sudo pacman -S --noconfirm --needed --asdeps steam
sudo pacman -S --noconfirm --needed --asdeps homebank
sudo pacman -S --noconfirm --needed --asdeps libreoffice-fresh
sudo pacman -S --noconfirm --needed --asdeps dconf-editor
sudo pacman -S --noconfirm --needed --asdeps virt-manager
sudo pacman -S --noconfirm --needed --asdeps ebtables iptables
sudo systemctl enable libvirtd.service
sudo systemctl enable virtlogd.service
sudo pacman -S --noconfirm --needed --asdeps pacmanlogviewer
sudo pacman -S --noconfirm --needed --asdeps exfat-utils
sudo pacman -S --noconfirm --needed --asdeps meld
sudo pacman -S --noconfirm --needed --asdeps cool-retro-term
sudo pacman -S --noconfirm --needed --asdeps blender
sudo pacman -S --noconfirm --needed --asdeps hardinfo
#sudo pacman -S --noconfirm --needed --asdeps virtualbox
#sudo pacman -S --noconfirm --needed --asdeps virtualbox-guest-iso
yay -S --noconfirm --needed --asdeps makemkv
yay -S --noconfirm --needed --asdeps drawio-desktop
yay -S --noconfirm --needed --asdeps dxvk-winelib-git
yay -S --noconfirm --needed --asdeps skypeforlinux-preview-bin
yay -S --noconfirm --needed --asdeps zoom
yay -S --noconfirm --needed --asdeps imagewriter-git
yay -S --noconfirm --needed --asdeps isomaster
yay -S --noconfirm --needed --asdeps timeshift
yay -S --noconfirm --needed --asdeps stacer
yay -S --noconfirm --needed --asdeps mattercontrol
yay -S --noconfirm --needed --asdeps olive
yay -S --noconfirm --needed --asdeps discord
yay -S --noconfirm --needed --asdeps freecad-appimage
yay -S --noconfirm --needed --asdeps gamemode lib32-gamemode
yay -S --noconfirm --needed --asdeps multibootusb-git
yay -S --noconfirm --needed --asdeps ovmf
yay -S --noconfirm --needed --asdeps libguestfs
#yay -S --noconfirm --needed --asdeps protontricks
#yay -S --noconfirm --needed --asdeps edex-ui-git
#yay -S --noconfirm --needed --asdeps virtualbox-ext-oracle

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
        yay -S --noconfirm --needed --asdeps makehuman
      ;;
    2)
      echo "You selected no"
      ;;
esac

echo "################################################################################"
echo "### Installing of applications completed                                     ###"
echo "################################################################################"
sleep 2
