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
numberofcores=$(grep -c ^processor /proc/cpuinfo)


case $numberofcores in

    16)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j17"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 16 -z -)/g' /etc/makepkg.conf
        ;;
    8)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j9"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 8 -z -)/g' /etc/makepkg.conf
        ;;
    6)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j7"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 6 -z -)/g' /etc/makepkg.conf
        ;;       
    4)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j5"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 4 -z -)/g' /etc/makepkg.conf
        ;;
    2)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j3"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 2 -z -)/g' /etc/makepkg.conf
        ;;
    *)
        echo "We do not know how many cores you have."
        echo "Do it manually."
        ;;

esac

sleep 2

clear
echo "################################################################################"
echo "### Setting up fastest repos                                                 ###"
echo "################################################################################"
sleep 2
sudo pacman -S reflector --noconfirm --needed
sudo reflector --country us --latest 25 --sort rate --save /etc/pacman.d/mirrorlist

clear
echo "################################################################################"
echo "### Setting up needed packages                                               ###"
echo "################################################################################"
sleep 2
clear
sudo pacman -Syyu --noconfirm --needed
sudo pacman -S --noconfirm --needed  neofetch git wget linux-headers rsync go htop openssh archlinux-wallpaper btrfs-progs grub-customizer
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm --needed
cd ..
rm yay -R -f
yay -S --noconfirm --needed grub-theme-creator grub-hook grub-theme-midna grub-theme-slaze-git grub-theme-vimix breeze-grub grub-theme-stylish-git grub-theme-tela-git grub-themes-solarized-dark-materialized arch-silence-grub-theme-git grub2-theme-archlinux grub2-theme-archxion grub2-theme-arch-leap grub2-theme-arch-suse grub2-theme-dharma-mod puzzle-bobble-grub2-theme

sed -i '$ a if [ -f /usr/bin/neofetch ]; then neofetch; fi' /home/$(whoami)/.bashrc
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-sysctl.conf

clear
echo "################################################################################"
echo "### Setting up sound                                                         ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed  pulseaudio pulseaudio-alsa pavucontrol alsa-utils alsa-plugins alsa-lib alsa-firmware lib32-alsa-lib lib32-alsa-oss lib32-alsa-plugins gstreamer gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly volumeicon playerctl

clear
echo "################################################################################"
echo "### Installing and setting up bluetooth                                      ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed  pulseaudio-bluetooth bluez bluez-libs bluez-utils bluez-plugins blueberry bluez-tools bluez-cups
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

clear
echo "################################################################################"
echo "### Installing and setting up printers                                       ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed  cups cups-pdf ghostscript gsfonts gutenprint gtk3-print-backends libcups hplip system-config-printer foomatic-db foomatic-db-ppds foomatic-db-gutenprint-ppds foomatic-db-engine foomatic-db-nonfree foomatic-db-nonfree-ppds
yay -S --noconfirm --needed  epson-inkjet-printer-201211w
sudo systemctl enable org.cups.cupsd.service

clear
echo "################################################################################"
echo "### Installing Samba and network sharing                                     ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed  samba
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
sudo pacman -S --noconfirm --needed  gvfs-smb avahi
sudo systemctl enable avahi-daemon.service
sudo systemctl start avahi-daemon.service
sudo pacman -S --noconfirm --needed  nss-mdns
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
sudo pacman -S --noconfirm --needed  intel-ucode amd-ucode

clear
echo "################################################################################"
echo "### Install and setup display manager and desktop                            ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed  xorg xorg-drivers xorg-xinit xterm vulkan-intel vulkan-radeon lib32-vulkan-intel lib32-vulkan-radeon vkd3d lib32-vkd3d kvantum-qt5 kvantum-theme-adapta kvantum-theme-arc kvantum-theme-materia opencl-mesa opencl-headers terminator
sudo pacman -S --noconfirm --needed  lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings lightdm-webkit-theme-litarvan lightdm-webkit2-greeter
yay -S --noconfirm --needed  lightdm-webkit2-theme-material2 lightdm-webkit-theme-aether lightdm-webkit-theme-userdock lightdm-webkit-theme-tendou lightdm-webkit-theme-wisp lightdm-webkit-theme-petrichor-git lightdm-webkit-theme-sequoia-git lightdm-webkit-theme-contemporary lightdm-webkit2-theme-sapphire lightdm-webkit2-theme-tty-git lightdm-webkit-theme-luminos lightdm-webkit2-theme-obsidian
sudo systemctl enable lightdm.service -f
sudo systemctl set-default graphical.target
sudo sed -i 's/'detect_theme_errors\ =\ true'/'detect_theme_errors\ =\ false'/g' /etc/lightdm/lightdm-webkit2-greeter.conf
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
      sudo pacman -S --noconfirm --needed  deepin deepin-extra gnome-disk-utility ark
      sudo sed -i 's/'#user-session=default'/'user-session=deepin'/g' /etc/lightdm/lightdm.conf
      ;;
    2)
      echo "You selected Gnome"
      sudo pacman -S --noconfirm --needed  gdm gnome gnome-extra nautilus-share chrome-gnome-shell variety
      #sudo systemctl enable gdm
      sudo sed -i 's/'#user-session=default'/'user-session=gnome'/g' /etc/lightdm/lightdm.conf
      yay -S --noconfirm --needed  gnome-shell-extension-dash-to-dock
      yay -S --noconfirm --needed  gnome-shell-extension-dash-to-panel-git
      yay -S --noconfirm --needed  gnome-shell-extension-workspaces-to-dock
      yay -S --noconfirm --needed  gnome-shell-extension-arc-menu-git
      yay -S --noconfirm --needed  gnome-shell-extension-openweather-git
      yay -S --noconfirm --needed  gnome-shell-extension-topicons-plus-git
      yay -S --noconfirm --needed  gnome-shell-extension-audio-output-switcher-git
      yay -S --noconfirm --needed  gnome-shell-extension-clipboard-indicator-git
      yay -S --noconfirm --needed  gnome-shell-extension-coverflow-alt-tab-git
      yay -S --noconfirm --needed  gnome-shell-extension-animation-tweaks-git
      yay -S --noconfirm --needed  gnome-shell-extension-gamemode-git
      #yay -S --noconfirm --needed  gnome-shell-extension-vitals
      #yay -S --noconfirm --needed  gnome-shell-extension-drop-down-terminal-x
      #yay -S --noconfirm --needed  gnome-shell-extension-dynamic-battery
      #yay -S --noconfirm --needed  gnome-shell-extension-material-shell-git
      #yay -S --noconfirm --needed  gnome-shell-extension-panel-osd
      #yay -S --noconfirm --needed  gnome-shell-extension-slinger-git
      #yay -S --noconfirm --needed  gnome-shell-extension-transparent-window-moving-git
      #yay -S --noconfirm --needed  gnome-shell-extension-transparent-osd-git
      #yay -S --noconfirm --needed  gnome-shell-extension-window-animations-git
      #yay -S --noconfirm --needed  gnome-shell-extension-impatience-git
      #yay -S --noconfirm --needed  gnome-appfolders-manager
      ;;
    3)
      echo "You selected KDE Plasma"
      sudo pacman -S --noconfirm --needed  sddm plasma kde-applications gnome-disk-utility redshift kvantum-qt5 kvantum-theme-adapta kvantum-theme-arc kvantum-theme-materia
      sudo sed -i 's/'#user-session=default'/'user-session=plasma'/g' /etc/lightdm/lightdm.conf
      #sudo systemctl enable sddm
      ;;
    4)
      echo "You selected Mate"
      sudo pacman -S --noconfirm --needed  mate mate-extra gnome-disk-utility variety
      yay -S --noconfirm --needed  mugshot
      yay -S --noconfirm --needed  mate-tweak
      yay -S --noconfirm --needed  brisk-menu
      sudo sed -i 's/'#user-session=default'/'user-session=mate'/g' /etc/lightdm/lightdm.conf
      ;;
    5)
      echo "You selected XFCE4"
      sudo pacman -S --noconfirm --needed  xfce4 xfce4-goodies gnome-disk-utility ark plank alacarte gnome-calculator picom
      yay -S --noconfirm --needed  xfce4-screensaver
      yay -S --noconfirm --needed  xfce4-panel-profiles
      yay -S --noconfirm --needed  mugshot
      yay -S --noconfirm --needed  compton-conf
      #yay -S --noconfirm --needed  xfce-theme-manager
      sudo sed -i 's/'#user-session=default'/'user-session=xfce4'/g' /etc/lightdm/lightdm.conf
      ;;
    6)
      echo "You selected Budgie"
      sudo pacman -S --noconfirm --needed  budgie-desktop budgie-extras gnome-system-monitor nautilus gnome-disk-utility gnome-control-center gnome-backgrounds gnome-calculator gedit variety
      sudo sed -i 's/'#user-session=default'/'user-session=budgie-desktop'/g' /etc/lightdm/lightdm.conf
      ;;
    7)
      echo "You selected Cinnamon"
      sudo pacman -S --noconfirm --needed  cinnamon gnome-disk-utility gnome-system-monitor gnome-calculator gpicview gedit variety
      sudo sed -i 's/'#user-session=default'/'user-session=cinnamon'/g' /etc/lightdm/lightdm.conf
      ;;
    8)
      echo "You selected LXDE"
      sudo pacman -S --noconfirm --needed  lxde gnome-disk-utility gnome-calculator gedit picom variety
      yay -S --noconfirm --needed  mugshot
      yay -S --noconfirm --needed  compton-conf
      sudo sed -i 's/'#user-session=default'/'user-session=lxde'/g' /etc/lightdm/lightdm.conf
      ;;
    9)
      echo "You selected LXQT"
      sudo pacman -S --noconfirm --needed  sddm lxqt gnome-disk-utility compton gnome-calculator gedit kvantum-qt5 kvantum-theme-adapta kvantum-theme-arc kvantum-theme-materia variety
      sudo sed -i 's/'#user-session=default'/'user-session=lxqt'/g' /etc/lightdm/lightdm.conf
      #sudo systemctl enable sddm
      ;;
    10)
      echo "You selected i3"
      sudo pacman -S --noconfirm --needed  i3 gnome-disk-utility
      sudo sed -i 's/'#user-session=default'/'user-session=i3'/g' /etc/lightdm/lightdm.conf
      ;;
    11)
      echo "You selected Coming Soon"
      sudo pacman -S --noconfirm --needed lxde-gtk3 gnome-disk-utility gnome-calculator gedit picom variety
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
yay -S --noconfirm --needed  pamac-aur
yay -S --noconfirm --needed  snapd-git
sudo systemctl enable snapd.service
yay -S --noconfirm --needed  bauh

clear
echo "################################################################################"
echo "### Checking video card                                                      ###"
echo "################################################################################"
if [[ $(lspci -k | grep VGA | grep -i nvidia) ]]; then
      sudo pacman -S --noconfirm --needed  nvidia nvidia-cg-toolkit nvidia-settings nvidia-utils lib32-nvidia-cg-toolkit lib32-nvidia-utils lib32-opencl-nvidia opencl-nvidia cuda ffnvcodec-headers lib32-libvdpau libxnvctrl pycuda-headers python-pycuda
      sudo pacman -R --noconfirm xf86-video-nouveau
fi
clear
echo "################################################################################"
echo "### Installation completed, please reboot when ready to enter your GUI       ###"
echo "### environment                                                              ###"
echo "################################################################################"
sleep 2
