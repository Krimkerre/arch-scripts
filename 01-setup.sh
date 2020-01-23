#!/bin/bash
###############################################################################
### Installing Arch Linux By:                                               ###
### Erik Sundquist                                                          ###
###############################################################################
### Review and edit before using                                            ###
###############################################################################

set -e
clear
echo "################################################################################"
echo "### Getting things ready to install                                          ###"
echo "################################################################################"
sleep 2
sudo pacman -Syyu

clear
echo "################################################################################"
echo "### Setting makepkg to use all cores                                         ###"
echo "################################################################################"
sleep 2
export MAKEFLAGS=-j$(nproc)
sleep 2

clear
echo "################################################################################"
echo "### Setting up fastest repos                                                 ###"
echo "################################################################################"
sleep 2
sudo pacman -S reflector --noconfirm --needed --asdeps
sudo reflector --country us --latest 25 --sort rate --save /etc/pacman.d/mirrorlist

clear
echo "################################################################################"
echo "### Setting up needed packages                                               ###"
echo "################################################################################"
sleep 2
clear
sudo pacman -Syyu --noconfirm --needed --asdeps
sudo pacman -S --noconfirm --needed --asdeps neofetch git wget linux-headers rsync go htop openssh archlinux-wallpaper btrfs-progs
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm --needed --asdeps
cd ..
rm yay -R -f

sed -i '$ a if [ -f /usr/bin/neofetch ]; then neofetch; fi' /home/$(whoami)/.bashrc
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-sysctl.conf

clear
echo "################################################################################"
echo "### Setting up sound                                                         ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed --asdeps pulseaudio pulseaudio-alsa pavucontrol alsa-utils alsa-plugins alsa-lib alsa-firmware lib32-alsa-lib lib32-alsa-oss lib32-alsa-plugins gstreamer gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly volumeicon playerctl

clear
echo "################################################################################"
echo "### Installing and setting up bluetooth                                      ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed --asdeps pulseaudio-bluetooth bluez bluez-libs bluez-utils bluez-plugins blueberry bluez-tools bluez-cups
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

clear
echo "################################################################################"
echo "### Installing and setting up printers                                       ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed --asdeps cups cups-pdf ghostscript gsfonts gutenprint gtk3-print-backends libcups hplip system-config-printer foomatic-db foomatic-db-ppds foomatic-db-gutenprint-ppds foomatic-db-engine foomatic-db-nonfree foomatic-db-nonfree-ppds
yay -S --noconfirm --needed --asdeps epson-inkjet-printer-201211w
sudo systemctl enable org.cups.cupsd.service

clear
echo "################################################################################"
echo "### Installing Samba and network sharing                                     ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed --asdeps samba
sudo wget "https://git.samba.org/samba.git/?p=samba.git;a=blob_plain;f=examples/smb.conf.default;hb=HEAD" -O /etc/samba/smb.conf
sudo sed -i -r 's/MYGROUP/WORKGROUP/' /etc/samba/smb.conf
sudo sed -i -r "s/Samba Server/$HOSTNAME/" /etc/samba/smb.conf
sudo systemctl enable smb.service
sudo systemctl start smb.service
sudo systemctl enable nmb.service
sudo systemctl start nmb.service
#Change your username here
sudo smbpasswd -a $(whoami)
sleep 2
#Access samba share windows
sudo pacman -S --noconfirm --needed --asdeps gvfs-smb avahi
sudo systemctl enable avahi-daemon.service
sudo systemctl start avahi-daemon.service
sudo pacman -S --noconfirm --needed --asdeps nss-mdns
sudo sed -i 's/dns/mdns dns wins/g' /etc/nsswitch.conf
#Set-up user sharing (disable this section if you dont want user shares)
sudo mkdir -p /var/lib/samba/usershares
sudo groupadd -r sambashare
sudo chown root:sambashare /var/lib/samba/usershares
sudo chmod 1770 /var/lib/samba/usershares
sudo sed -i -r '/\[global\]/a\username path = /var/lib/samba/usershares\nusershare max shares = 100\nusershare allow guests = yes\nusershare owner only = yes' /etc/samba/smb.conf
sudo gpasswd sambashare -a $(whoami)

clear
echo "################################################################################"
echo "### Installing fix the unicode problem                                       ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed --asdeps intel-ucode amd-ucode

clear
echo "################################################################################"
echo "### Install and setup display manager and desktop                            ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed --asdeps xorg xorg-drivers xorg-xinit xterm vulkan-intel vulkan-radeon lib32-vulkan-intel lib32-vulkan-radeon vkd3d lib32-vkd3d kvantum-qt5 kvantum-theme-adapta kvantum-theme-arc kvantum-theme-materia opencl-mesa opencl-headers terminator
sudo pacman -S --noconfirm --needed --asdeps lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings lightdm-webkit-theme-litarvan lightdm-webkit2-greeter
yay -S --noconfirm --needed --asdeps lightdm-webkit2-theme-material2 lightdm-webkit-theme-aether lightdm-webkit-theme-userdock lightdm-webkit-theme-tendou lightdm-webkit-theme-wisp lightdm-webkit-theme-petrichor-git lightdm-webkit-theme-sequoia-git lightdm-webkit-theme-contemporary lightdm-webkit2-theme-sapphire lightdm-webkit2-theme-tty-git lightdm-webkit-theme-luminos lightdm-webkit2-theme-obsidian
sudo systemctl enable lightdm.service -f
sudo systemctl set-default graphical.target
clear
echo "################################################################################"
echo "What is your preferred desktop environment"
echo "1)  Deepin"
echo "2)  Gnome"
echo "3)  KDE Plasma"
echo "4)  Mate"
echo "5)  XFCE4"
echo "6)  Budgie"
echo "7)  Cinnamon"
echo "8)  LXDE"
echo "9)  LXQT"
echo "10) i3"
echo "11) Coming Soon"
echo "12) None"
echo "################################################################################"
read case;

case $case in
    1)
      echo "You selected Deepin"
      sudo pacman -S --noconfirm --needed --asdeps deepin deepin-extra gnome-disk-utility ark
      ;;
    2)
      echo "You selected Gnome"
      sudo pacman -S --noconfirm --needed --asdeps gdm gnome nautilus-share chrome-gnome-shell variety
      #sudo systemctl enable gdm
      ;;
    3)
      echo "You selected KDE Plasma"
      sudo pacman -S --noconfirm --needed --asdeps sddm plasma kde-applications gnome-disk-utility redshift kvantum-qt5 kvantum-theme-adapta kvantum-theme-arc kvantum-theme-materia
#      sudo systemctl enable sddm
      ;;
    4)
      echo "You selected Mate"
      sudo pacman -S --noconfirm --needed --asdeps mate mate-extra gnome-disk-utility
      yay -S --noconfirm --needed --asdeps mugshot
      ;;
    5)
      echo "You selected XFCE4"
      sudo pacman -S --noconfirm --needed --asdeps xfce4 xfce4-goodies gnome-disk-utility ark plank alacarte gnome-calculator picom
      yay -S --noconfirm --needed --asdeps xfce4-screensaver
      yay -S --noconfirm --needed --asdeps xfce4-panel-profiles
      yay -S --noconfirm --needed --asdeps mugshot
      yay -S --noconfirm --needed --asdeps compton-conf
      #yay -S --noconfirm --needed --asdeps xfce-theme-manager
      ;;
    6)
      echo "You selected Budgie"
      sudo pacman -S --noconfirm --needed --asdeps budgie-desktop budgie-extras gnome-system-monitor nautilus gnome-disk-utility gnome-control-center gnome-backgrounds gnome-calculator gedit
      ;;
    7)
      echo "You selected Cinnamon"
      sudo pacman -S --noconfirm --needed --asdeps cinnamon gnome-disk-utility gnome-system-monitor gnome-calculator gpicview gedit
      ;;
    8)
      echo "You selected LXDE"
      sudo pacman -S --noconfirm --needed --asdeps lxde gnome-disk-utility gnome-calculator gedit picom
      yay -S --noconfirm --needed --asdeps mugshot
      yay -S --noconfirm --needed --asdeps compton-conf
      ;;
    9)
      echo "You selected LXQT"
      sudo pacman -S --noconfirm --needed --asdeps sddm lxqt gnome-disk-utility compton gnome-calculator gedit kvantum-qt5 kvantum-theme-adapta kvantum-theme-arc kvantum-theme-materia
#      sudo systemctl enable sddm
      ;;
    10)
      echo "You selected i3"
      sudo pacman -S --noconfirm --needed --asdeps i3 gnome-disk-utility
      ;;
    11)
      echo "You selected Coming Soon"
      #sudo pacman -S --noconfirm --needed --asdeps
      ;;
    12)
      echo "You selected none"
      ;;
esac

clear
echo "################################################################################"
echo "### Installing software center                                               ###"
echo "################################################################################"
sleep 2
yay -S --noconfirm --needed --asdeps pamac-aur
yay -S --noconfirm --needed --asdeps snapd-git
sudo systemctl enable snapd.service
yay -S --noconfirm --needed --asdeps bauh

clear
echo "################################################################################"
echo "### Checking video card                                                      ###"
echo "################################################################################"
if [[ $(lspci -k | grep VGA | grep -i nvidia) ]]; then
      sudo pacman -S --noconfirm --needed --asdeps nvidia nvidia-cg-toolkit nvidia-settings nvidia-utils lib32-nvidia-cg-toolkit lib32-nvidia-utils lib32-opencl-nvidia opencl-nvidia cuda ffnvcodec-headers lib32-libvdpau libxnvctrl pycuda-headers python-pycuda
      sudo pacman -R --noconfirm xf86-video-nouveau
fi
clear
echo "################################################################################"
echo "### Installation completed, please reboot when ready to enter your GUI       ###"
echo "### environment                                                              ###"
echo "################################################################################"
sleep 2
