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
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j16"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 16 -z -)/g' /etc/makepkg.conf
        ;;
    8)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j8"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 8 -z -)/g' /etc/makepkg.conf
        ;;
    6)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j8"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 6 -z -)/g' /etc/makepkg.conf
        ;;
    4)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j4"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 4 -z -)/g' /etc/makepkg.conf
        ;;
    2)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j2"/g' /etc/makepkg.conf
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
sudo reflector --country US --age 8 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Sy
#sudo pacman-key --refresh-keys

clear
echo "################################################################################"
echo "### Setting up needed packages                                               ###"
echo "################################################################################"
sleep 2
clear
sudo pacman -S --noconfirm --needed neofetch
sudo pacman -S --noconfirm --needed git
sudo pacman -S --noconfirm --needed wget
#sudo pacman -S --noconfirm --needed linux-headers
sudo pacman -S --noconfirm --needed rsync
sudo pacman -S --noconfirm --needed go
sudo pacman -S --noconfirm --needed htop
sudo pacman -S --noconfirm --needed openssh
sudo pacman -S --noconfirm --needed archlinux-wallpaper
sudo pacman -S --noconfirm --needed btrfs-progs
sudo pacman -S --noconfirm --needed glances

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm --needed
cd ..
rm yay -R -f
#yay -S --noconfirm --needed grub-theme-creator grub-hook grub-theme-midna grub-theme-slaze-git grub-theme-vimix breeze-grub grub-theme-stylish-git grub-theme-tela-git grub-themes-solarized-dark-materialized arch-silence-grub-theme-git grub2-theme-archlinux grub2-theme-archxion grub2-theme-arch-leap grub2-theme-arch-suse grub2-theme-dharma-mod puzzle-bobble-grub2-theme

sed -i '$ a if [ -f /usr/bin/neofetch ]; then neofetch; fi' /home/$(whoami)/.bashrc
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-sysctl.conf

clear
echo "################################################################################"
echo "### Setting up sound                                                         ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed pulseaudio
sudo pacman -S --noconfirm --needed pulseaudio-alsa
sudo pacman -S --noconfirm --needed pavucontrol
sudo pacman -S --noconfirm --needed alsa-utils
sudo pacman -S --noconfirm --needed alsa-plugins
sudo pacman -S --noconfirm --needed alsa-lib
sudo pacman -S --noconfirm --needed alsa-firmware
sudo pacman -S --noconfirm --needed lib32-alsa-lib
sudo pacman -S --noconfirm --needed lib32-alsa-oss
sudo pacman -S --noconfirm --needed lib32-alsa-plugins
sudo pacman -S --noconfirm --needed gstreamer
sudo pacman -S --noconfirm --needed gst-plugins-good
sudo pacman -S --noconfirm --needed gst-plugins-bad
sudo pacman -S --noconfirm --needed gst-plugins-base
sudo pacman -S --noconfirm --needed gst-plugins-ugly
sudo pacman -S --noconfirm --needed volumeicon
sudo pacman -S --noconfirm --needed playerctl
yay -S --noconfirm --needed alsa-tools
yay -S --noconfirm --needed lib32-apulse
#yay -S --noconfirm --needed pulseeffects
yay -S --noconfirm --needed lib32-libpulse
yay -S --noconfirm --needed pulseaudio-jack
yay -S --noconfirm --needed pacmixer
clear
echo "################################################################################"
echo "### Installing and setting up bluetooth                                      ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed pulseaudio-bluetooth
sudo pacman -S --noconfirm --needed bluez
sudo pacman -S --noconfirm --needed bluez-libs
sudo pacman -S --noconfirm --needed bluez-utils
sudo pacman -S --noconfirm --needed bluez-plugins
sudo pacman -S --noconfirm --needed blueberry
sudo pacman -S --noconfirm --needed bluez-tools
sudo pacman -S --noconfirm --needed bluez-cups
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

clear
echo "################################################################################"
echo "### Installing and setting up printers                                       ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed cups
sudo pacman -S --noconfirm --needed cups-pdf
sudo pacman -S --noconfirm --needed ghostscript
sudo pacman -S --noconfirm --needed gsfonts
sudo pacman -S --noconfirm --needed gutenprint
sudo pacman -S --noconfirm --needed gtk3-print-backends
sudo pacman -S --noconfirm --needed libcups
sudo pacman -S --noconfirm --needed hplip
sudo pacman -S --noconfirm --needed system-config-printer
sudo pacman -S --noconfirm --needed foomatic-db
sudo pacman -S --noconfirm --needed foomatic-db-ppds
sudo pacman -S --noconfirm --needed foomatic-db-gutenprint-ppds
sudo pacman -S --noconfirm --needed foomatic-db-engine
sudo pacman -S --noconfirm --needed foomatic-db-nonfree
sudo pacman -S --noconfirm --needed foomatic-db-nonfree-ppds
yay -S --noconfirm --needed epson-inkjet-printer-escpr
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
sudo pacman -S --noconfirm --needed xorg
sudo pacman -S --noconfirm --needed xorg-drivers
sudo pacman -S --noconfirm --needed xorg-xinit
sudo pacman -S --noconfirm --needed xterm
sudo pacman -S --noconfirm --needed vulkan-intel
sudo pacman -S --noconfirm --needed vulkan-radeon
sudo pacman -S --noconfirm --needed lib32-vulkan-intel
sudo pacman -S --noconfirm --needed lib32-vulkan-radeon
sudo pacman -S --noconfirm --needed vkd3d
sudo pacman -S --noconfirm --needed lib32-vkd3d
sudo pacman -S --noconfirm --needed kvantum-qt5 kvantum-theme-adapta kvantum-theme-arc kvantum-theme-materia
sudo pacman -S --noconfirm --needed opencl-mesa
sudo pacman -S --noconfirm --needed opencl-headers
sudo pacman -S --noconfirm --needed terminator
sudo pacman -S --noconfirm --needed lib32-mesa-demos
sudo pacman -S --noconfirm --needed mesa-vdpau
sudo pacman -S --noconfirm --needed lib32-mesa-vdpau
sudo pacman -S --noconfirm --needed ocl-icd
sudo pacman -S --noconfirm --needed lib32-ocl-icd

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
      sudo pacman -S --noconfirm --needed deepin deepin-extra
      sudo pacman -S --noconfirm --needed gnome-disk-utility
      sudo pacman -S --noconfirm --needed ark
      sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
      sudo systemctl enable lightdm.service -f
      sudo systemctl set-default graphical.target
      sudo sed -i 's/'#user-session=default'/'user-session=deepin'/g' /etc/lightdm/lightdm.conf
      ;;
    2)
      echo "You selected Gnome"
      sudo pacman -S --noconfirm --needed gdm gnome gnome-extra
      sudo pacman -S --noconfirm --needed nautilus-share
      sudo pacman -S --noconfirm --needed chrome-gnome-shell
      sudo pacman -S --noconfirm --needed variety
      sudo pacman -R --noconfirm gnome-terminal
      sudo systemctl enable gdm
      #sudo sed -i 's/'#user-session=default'/'user-session=gnome'/g' /etc/lightdm/lightdm.conf
      yay -S --noconfirm --needed gnome-terminal-transparency
      yay -S --noconfirm --needed gnome-shell-extension-dash-to-dock
      yay -S --noconfirm --needed gnome-shell-extension-dash-to-panel
      yay -S --noconfirm --needed gnome-shell-extension-workspaces-to-dock
      yay -S --noconfirm --needed gnome-shell-extension-arc-menu-git
      yay -S --noconfirm --needed gnome-shell-extension-openweather-git
      yay -S --noconfirm --needed gnome-shell-extension-topicons-plus
      yay -S --noconfirm --needed gnome-shell-extension-audio-output-switcher-git
      yay -S --noconfirm --needed gnome-shell-extension-clipboard-indicator-git
      yay -S --noconfirm --needed gnome-shell-extension-coverflow-alt-tab-git
      yay -S --noconfirm --needed gnome-shell-extension-animation-tweaks-git
      yay -S --noconfirm --needed gnome-shell-extension-gamemode-git
      yay -S --noconfirm --needed gnome-shell-extension-extended-gestures-git
      yay -S --noconfirm --needed gnome-shell-extension-transparent-window-moving-git
      #yay -S qnome-shell-extension-pop-shell-git
      #yay -S --noconfirm --needed gnome-alsamixer
      #yay -S --noconfirm --needed gnome-shell-extension-vitals
      #yay -S --noconfirm --needed gnome-shell-extension-drop-down-terminal-x
      #yay -S --noconfirm --needed gnome-shell-extension-dynamic-battery
      #yay -S --noconfirm --needed gnome-shell-extension-material-shell-git
      #yay -S --noconfirm --needed gnome-shell-extension-panel-osd
      #yay -S --noconfirm --needed gnome-shell-extension-slinger-git
      #yay -S --noconfirm --needed gnome-shell-extension-transparent-osd-git
      #wget https://raw.githubusercontent.com/bill-mavromatis/gnome-layout-manager/master/layoutmanager.sh
      #sudo chmod +x layoutmanager.sh
      ;;
    3)
      echo "You selected KDE Plasma"
      sudo pacman -S --noconfirm --needed sddm plasma kde-applications
      sudo pacman -S --noconfirm --needed gnome-disk-utility
      sudo pacman -S --noconfirm --needed redshift
      #sudo sed -i 's/'#user-session=default'/'user-session=plasma'/g' /etc/lightdm/lightdm.conf
      sudo systemctl enable sddm
      ;;
    4)
      echo "You selected Mate"
      sudo pacman -S --noconfirm --needed mate mate-extra
      sudo pacman -S --noconfirm --needed gnome-disk-utility
      sudo pacman -S --noconfirm --needed variety
      yay -S --noconfirm --needed user-admin
      yay -S --noconfirm --needed mate-tweak
      yay -S --noconfirm --needed brisk-menu
      yay -S --noconfirm --needed mate-screensaver-hacks
      sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
      sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
      sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
      yay -S --noconfirm --needed lightdm-webkit2-theme-material2
      yay -S --noconfirm --needed lightdm-webkit-theme-aether
      yay -S --noconfirm --needed lightdm-webkit-theme-userdock
      yay -S --noconfirm --needed lightdm-webkit-theme-tendou
      yay -S --noconfirm --needed lightdm-webkit-theme-wisp
      yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
      yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
      yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
      yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
      yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
      yay -S --noconfirm --needed lightdm-webkit-theme-luminos
      yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
      sudo systemctl enable lightdm.service -f
      sudo systemctl set-default graphical.target
      sudo sed -i 's/'#user-session=default'/'user-session=mate'/g' /etc/lightdm/lightdm.conf
      ;;
    5)
      echo "You selected XFCE4"
      sudo pacman -S --noconfirm --needed xfce4 xfce4-goodies
      sudo pacman -S --noconfirm --needed gnome-disk-utility
      sudo pacman -S --noconfirm --needed file-roller
      sudo pacman -S --noconfirm --needed alacarte
      sudo pacman -S --noconfirm --needed gnome-calculator
      sudo pacman -S --noconfirm --needed picom
      sudo pacman -S --noconfirm --needed variety
      sudo pacman -S --noconfirm --needed libnma
      sudo pacman -S --noconfirm --needed networkmanager
      sudo pacman -S --noconfirm --needed networkmanager-openconnect
      sudo pacman -S --noconfirm --needed networkmanager-openvpn
      sudo pacman -S --noconfirm --needed networkmanager-pptp
      sudo pacman -S --noconfirm --needed nm-connection-editor
      sudo pacman -S --noconfirm --needed network-manager-applet
      yay -S --noconfirm --needed xfce4-screensaver
      yay -S --noconfirm --needed xfce4-panel-profiles-git
      yay -S --noconfirm --needed mugshot
      yay -S --noconfirm --needed solarized-dark-themes
      yay -S --noconfirm --needed gtk-theme-glossyblack
      yay -S --noconfirm --needed mcos-mjv-xfce-edition
      #yay -S --noconfirm --needed compton-conf-git
      #yay -S --noconfirm --needed xfce-theme-manager
      sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
      sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
      sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
      yay -S --noconfirm --needed lightdm-webkit2-theme-material2
      yay -S --noconfirm --needed lightdm-webkit-theme-aether
      yay -S --noconfirm --needed lightdm-webkit-theme-userdock
      yay -S --noconfirm --needed lightdm-webkit-theme-tendou
      yay -S --noconfirm --needed lightdm-webkit-theme-wisp
      yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
      yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
      yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
      yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
      yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
      yay -S --noconfirm --needed lightdm-webkit-theme-luminos
      yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
      yay -S --noconfirm --needed xfce4-theme-switcher
      yay -S --noconfirm --needed xts-windows10-theme
      yay -S --noconfirm --needed xts-macos-theme
      yay -S --noconfirm --needed xts-dark-theme
      yay -S --noconfirm --needed xts-arcolinux-theme
      sudo systemctl enable lightdm.service -f
      sudo systemctl set-default graphical.target
      sudo sed -i 's/'#user-session=default'/'user-session=xfce'/g' /etc/lightdm/lightdm.conf
      ;;
    6)
      echo "You selected Budgie"
      sudo pacman -S --noconfirm --needed budgie-desktop budgie-extras
      sudo pacman -S --noconfirm --needed gnome-system-monitor
      sudo pacman -S --noconfirm --needed nautilus
      sudo pacman -S --noconfirm --needed gnome-disk-utility
      sudo pacman -S --noconfirm --needed gnome-control-center
      sudo pacman -S --noconfirm --needed gnome-backgrounds
      sudo pacman -S --noconfirm --needed gnome-calculator
      sudo pacman -S --noconfirm --needed gedit
      sudo pacman -S --noconfirm --needed variety
      sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
      sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
      sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
      yay -S --noconfirm --needed lightdm-webkit2-theme-material2
      yay -S --noconfirm --needed lightdm-webkit-theme-aether
      yay -S --noconfirm --needed lightdm-webkit-theme-userdock
      yay -S --noconfirm --needed lightdm-webkit-theme-tendou
      yay -S --noconfirm --needed lightdm-webkit-theme-wisp
      yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
      yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
      yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
      yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
      yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
      yay -S --noconfirm --needed lightdm-webkit-theme-luminos
      yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
      sudo systemctl enable lightdm.service -f
      sudo systemctl set-default graphical.target
      sudo sed -i 's/'#user-session=default'/'user-session=budgie-desktop'/g' /etc/lightdm/lightdm.conf
      ;;
    7)
      echo "You selected Cinnamon"
      sudo pacman -S --noconfirm --needed cinnamon
      sudo pacman -S --noconfirm --needed gnome-disk-utility
      sudo pacman -S --noconfirm --needed gnome-system-monitor
      sudo pacman -S --noconfirm --needed gnome-calculator
      sudo pacman -S --noconfirm --needed gpicview
      sudo pacman -S --noconfirm --needed gedit
      sudo pacman -S --noconfirm --needed variety
      sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
      sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
      sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
      yay -S --noconfirm --needed lightdm-webkit2-theme-material2
      yay -S --noconfirm --needed lightdm-webkit-theme-aether
      yay -S --noconfirm --needed lightdm-webkit-theme-userdock
      yay -S --noconfirm --needed lightdm-webkit-theme-tendou
      yay -S --noconfirm --needed lightdm-webkit-theme-wisp
      yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
      yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
      yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
      yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
      yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
      yay -S --noconfirm --needed lightdm-webkit-theme-luminos
      yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
      sudo systemctl enable lightdm.service -f
      sudo systemctl set-default graphical.target
      sudo sed -i 's/'#user-session=default'/'user-session=cinnamon'/g' /etc/lightdm/lightdm.conf
      ;;
    8)
      echo "You selected LXDE"
      sudo pacman -S --noconfirm --needed lxde
      sudo pacman -S --noconfirm --needed gnome-disk-utility
      sudo pacman -S --noconfirm --needed gnome-calculator
      sudo pacman -S --noconfirm --needed gedit
      sudo pacman -S --noconfirm --needed picom
      sudo pacman -S --noconfirm --needed variety
      yay -S --noconfirm --needed mugshot
      yay -S --noconfirm --needed compton-conf
      sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
      sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
      sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
      yay -S --noconfirm --needed lightdm-webkit2-theme-material2
      yay -S --noconfirm --needed lightdm-webkit-theme-aether
      yay -S --noconfirm --needed lightdm-webkit-theme-userdock
      yay -S --noconfirm --needed lightdm-webkit-theme-tendou
      yay -S --noconfirm --needed lightdm-webkit-theme-wisp
      yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
      yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
      yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
      yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
      yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
      yay -S --noconfirm --needed lightdm-webkit-theme-luminos
      yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
      sudo systemctl enable lightdm.service -f
      sudo systemctl set-default graphical.target
      sudo sed -i 's/'#user-session=default'/'user-session=lxde'/g' /etc/lightdm/lightdm.conf
      ;;
    9)
      echo "You selected LXQT"
      sudo pacman -S --noconfirm --needed sddm lxqt
      sudo pacman -S --noconfirm --needed gnome-disk-utility
      sudo pacman -S --noconfirm --needed picom
      sudo pacman -S --noconfirm --needed gnome-calculator
      sudo pacman -S --noconfirm --needed gedit
      sudo pacman -S --noconfirm --needed variety
      #sudo sed -i 's/'#user-session=default'/'user-session=lxqt'/g' /etc/lightdm/lightdm.conf
      sudo systemctl enable sddm
      ;;
    10)
      echo "You selected i3"
      sudo pacman -S --noconfirm --needed i3
      sudo pacman -S --noconfirm --needed gnome-disk-utility
      sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
      sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
      sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
      yay -S --noconfirm --needed lightdm-webkit2-theme-material2
      yay -S --noconfirm --needed lightdm-webkit-theme-aether
      yay -S --noconfirm --needed lightdm-webkit-theme-userdock
      yay -S --noconfirm --needed lightdm-webkit-theme-tendou
      yay -S --noconfirm --needed lightdm-webkit-theme-wisp
      yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
      yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
      yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
      yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
      yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
      yay -S --noconfirm --needed lightdm-webkit-theme-luminos
      yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
      sudo systemctl enable lightdm.service -f
      sudo systemctl set-default graphical.target
      sudo sed -i 's/'#user-session=default'/'user-session=i3'/g' /etc/lightdm/lightdm.conf
      ;;
    11)
      echo "You selected Coming Soon"

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
yay -S --noconfirm --needed pamac-aur-git
yay -S --noconfirm --needed snapd-git
sudo pacman -S --noconfirm --needed flatpak
sudo systemctl enable snapd.service
yay -S --noconfirm --needed bauh

clear
echo "################################################################################"
echo "### Checking video card                                                      ###"
echo "################################################################################"
if [[ $(lspci -k | grep VGA | grep -i nvidia) ]]; then
  sudo pacman -S --noconfirm --needed nvidia
  sudo pacman -S --noconfirm --needed nvidia-cg-toolkit
  sudo pacman -S --noconfirm --needed nvidia-settings
  sudo pacman -S --noconfirm --needed nvidia-utils
  sudo pacman -S --noconfirm --needed lib32-nvidia-cg-toolkit
  sudo pacman -S --noconfirm --needed lib32-nvidia-utils
  sudo pacman -S --noconfirm --needed lib32-opencl-nvidia
  sudo pacman -S --noconfirm --needed opencl-nvidia
  sudo pacman -S --noconfirm --needed cuda
  sudo pacman -S --noconfirm --needed ffnvcodec-headers
  sudo pacman -S --noconfirm --needed lib32-libvdpau
  sudo pacman -S --noconfirm --needed libxnvctrl
  sudo pacman -S --noconfirm --needed pycuda-headers
  sudo pacman -S --noconfirm --needed python-pycuda
  sudo pacman -R --noconfirm xf86-video-nouveau
fi

if [[ $(lspci -k | grep VGA | grep -i amd) ]]; then
  #yay -S --noconfirm --needed amdgpu-pro-libgl
  #yay -S --noconfirm --needed lib32-amdgpu-pro-libgl
  #yay -S --noconfirm --needed amdvlk
  #yay -S --noconfirm --needed lib32-amdvlk
  yay -S --noconfirm --needed opencl-amd
  echo "##############################################################################"
  echo "### Congrats on supporting open source GPU vendor                          ###"
  echo "##############################################################################"
fi

clear
echo "################################################################################"
echo "### Installation completed, please reboot when ready to enter your GUI       ###"
echo "### environment                                                              ###"
echo "################################################################################"
sleep 2
