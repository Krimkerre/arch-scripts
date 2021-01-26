#!/bin/bash
################################################################################
### Installing Complete Arch Linux By:                                       ###
### Erik Sundquist                                                           ###
################################################################################
### Review and edit before using                                             ###
################################################################################
set -e
################################################################################
### Install YAY, A Helper For The AUR                                        ###
################################################################################
function INSTALLYAY() {
  clear
  echo "################################################################################"
  echo "### Installing YAY                                                           ###"
  echo "################################################################################"
  sleep 2
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm --needed
  cd ..
  rm yay -R -f
}
################################################################################
### Install PARU, a helper for the AUR                                       ###
################################################################################
function INSTALLPARU() {
  clear
  echo "################################################################################"
  echo "### Installing PARU                                                          ###"
  echo "################################################################################"
  sleep 2
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si --noconfirm --needed
  cd ..
  rm paru -R -f
}
################################################################################
### Setting Up Sound                                                         ###
################################################################################
function SOUNDSETUP() {
  clear
  echo "################################################################################"
  echo "### Setting Up Sound                                                         ###"
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
}
################################################################################
### Setting Up Bluetooth                                                     ###
################################################################################
function BLUETOOTHSETUP() {
  clear
  echo "################################################################################"
  echo "### Installing And Setting Up Bluetooth                                      ###"
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
}
################################################################################
### Setup Printing                                                           ###
################################################################################
function PRINTERSETUP() {
  clear
  echo "################################################################################"
  echo "### Installing And Setting Up Printers                                       ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed cups
  sudo pacman -S --noconfirm --needed cups-pdf
  sudo pacman -S --noconfirm --needed ghostscript
  sudo pacman -S --noconfirm --needed gsfonts
  sudo pacman -S --noconfirm --needed gutenprint
  sudo pacman -S --noconfirm --needed gtk3-print-backends
  sudo pacman -S --noconfirm --needed libcups
  #sudo pacman -S --noconfirm --needed hplip
  sudo pacman -S --noconfirm --needed system-config-printer
  sudo pacman -S --noconfirm --needed foomatic-db
  sudo pacman -S --noconfirm --needed foomatic-db-ppds
  sudo pacman -S --noconfirm --needed foomatic-db-gutenprint-ppds
  sudo pacman -S --noconfirm --needed foomatic-db-engine
  sudo pacman -S --noconfirm --needed foomatic-db-nonfree
  sudo pacman -S --noconfirm --needed foomatic-db-nonfree-ppds
  if $ZB=1; then
    yay -S --noconfirm --needed epson-inkjet-printer-escpr
  else
    paru -S --noconfirm --needed epson-inkjet-printer-escpr
  fi
  sudo systemctl enable cups.service
}
################################################################################
### Samba Share Setup                                                        ###
################################################################################
function SAMBASETUP() {
  clear
  echo "################################################################################"
  echo "### Installing Samba And Network Sharing                                     ###"
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
}
################################################################################
### Fix the Unicode Issue With Intel And AMD CPUs                            ###
################################################################################
function UNICODEFIX() {
  clear
  echo "################################################################################"
  echo "### Installing Fix The Unicode Problem                                       ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed  intel-ucode amd-ucode
}
################################################################################
### Installing the Display Manager                                           ###
################################################################################
function DISPLAYMGR() {
  clear
  echo "################################################################################"
  echo "### Install XORG Display                                                     ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed xorg
  sudo pacman -S --noconfirm --needed xorg-drivers
  sudo pacman -S --noconfirm --needed xorg-xinit
  sudo pacman -S --noconfirm --needed xterm
  sudo pacman -S --noconfirm --needed kvantum-qt5
  sudo pacman -S --noconfirm --needed terminator
}
################################################################################
### Install Deepin DE                                                        ###
################################################################################
function DEEPIN_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Deepin Desktop                                            ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed deepin deepin-extra
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed ark file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed deepin-kwin
  sudo pacman -S --noconfirm deepin-polkit-agent deepin-polkit-agent-ext-gnomekeyring
  sudo pacman -S --noconfirm --needed packagekit-qt5
}
################################################################################
### Install Gnome DE                                                         ###
################################################################################
function GNOME_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Gnome Desktop                                             ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed gnome gnome-extra
  sudo pacman -S --noconfirm --needed nautilus-share
  sudo pacman -S --noconfirm --needed chrome-gnome-shell
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed gnome-packagekit gnome-software-packagekit-plugin

  clear
  echo "##############################################################################"
  echo "### Do you want Gnome Extensions installed?                                ###"
  echo "### 1)  Yes                                                                ###"
  echo "### 2)  No                                                                 ###"
  echo "##############################################################################"
  read case;

  case $case in
    1)
    GNOMEEXT
    ;;
    2)
    ;;
  esac
}
################################################################################
### Install Gnome DE Extensions                                              ###
################################################################################
function GNOMEEXT() {
  clear
  echo "################################################################################"
  echo "### Installing Gnome Extensions                                              ###"
  echo "################################################################################"
  sleep 2
  if ZB=1 then
    yay -S --noconfirm --needed gnome-shell-extension-dash-to-dock
    yay -S --noconfirm --needed gnome-shell-extension-dash-to-panel
    yay -S --noconfirm --needed gnome-shell-extension-arc-menu-git
    yay -S --noconfirm --needed gnome-shell-extension-openweather-git
    yay -S --noconfirm --needed gnome-shell-extension-topicons-plus
    yay -S --noconfirm --needed gnome-shell-extension-audio-output-switcher-git
    yay -S --noconfirm --needed gnome-shell-extension-clipboard-indicator-git
    yay -S --noconfirm --needed gnome-shell-extension-coverflow-alt-tab-git
    yay -S --noconfirm --needed gnome-shell-extension-animation-tweaks-git
    yay -S --noconfirm --needed gnome-shell-extension-extended-gestures-git
    yay -S --noconfirm --needed gnome-shell-extension-transparent-window-moving-git
    yay -S --noconfirm --needed gnome-shell-extension-pop-shell-git pop-shell-shortcuts-git
    yay -S --noconfirm --needed gnome-alsamixer
    yay -S --noconfirm --needed gnome-shell-extension-vitals
    yay -S --noconfirm --needed gnome-shell-extension-drop-down-terminal-x
    yay -S --noconfirm --needed gnome-shell-extension-material-shell-git
    yay -S --noconfirm --needed gnome-shell-extension-slinger-git
    yay -S --noconfirm --needed gnome-shell-extension-transparent-osd-git
  else
    paru -S --noconfirm --needed gnome-shell-extension-dash-to-dock
    paru -S --noconfirm --needed gnome-shell-extension-dash-to-panel
    paru -S --noconfirm --needed gnome-shell-extension-arc-menu-git
    paru -S --noconfirm --needed gnome-shell-extension-openweather-git
    paru -S --noconfirm --needed gnome-shell-extension-topicons-plus
    paru -S --noconfirm --needed gnome-shell-extension-audio-output-switcher-git
    paru -S --noconfirm --needed gnome-shell-extension-clipboard-indicator-git
    paru -S --noconfirm --needed gnome-shell-extension-coverflow-alt-tab-git
    paru -S --noconfirm --needed gnome-shell-extension-animation-tweaks-git
    paru -S --noconfirm --needed gnome-shell-extension-extended-gestures-git
    paru -S --noconfirm --needed gnome-shell-extension-transparent-window-moving-git
    paru -S --noconfirm --needed gnome-shell-extension-pop-shell-git pop-shell-shortcuts-git
    paru -S --noconfirm --needed gnome-alsamixer
    paru -S --noconfirm --needed gnome-shell-extension-vitals
    paru -S --noconfirm --needed gnome-shell-extension-drop-down-terminal-x
    paru -S --noconfirm --needed gnome-shell-extension-material-shell-git
    paru -S --noconfirm --needed gnome-shell-extension-slinger-git
    paru -S --noconfirm --needed gnome-shell-extension-transparent-osd-git
  fi
}
################################################################################
### Install KDE Plasma DE                                                    ###
################################################################################
function PLASMA_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The KDE Plasma Desktop                                        ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed plasma kde-applications
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed redshift
  sudo pacman -S --noconfirm --needed packagekit-qt5
}
################################################################################
### Installing MATE DE                                                       ###
################################################################################
function MATE_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The MATE Desktop                                              ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed mate mate-extra
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed ark file-roller unrar p7zip
  if ZB=1 then
    yay -S --noconfirm --needed mate-tweak
    yay -S --noconfirm --needed brisk-menu
    yay -S --noconfirm --needed mate-screensaver-hacks
    yay -S --noconfirm --needed mugshot
  else
    paru -S --noconfirm --needed mate-tweak
    paru -S --noconfirm --needed brisk-menu
    paru -S --noconfirm --needed mate-screensaver-hacks
    paru -S --noconfirm --needed mugshot
  fi
}
################################################################################
### Installing XFCE DE                                                       ###
################################################################################
function XFCE_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The XFCE Desktop                                              ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed xfce4 xfce4-goodies
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed ark file-roller unrar p7zip
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
  sudo pacman -S --noconfirm --needed onboard
  if ZB=1 then
    yay -S --noconfirm --needed xfce4-screensaver
    yay -S --noconfirm --needed xfce4-panel-profiles-git
    yay -S --noconfirm --needed mugshot
    yay -S --noconfirm --needed solarized-dark-themes
    yay -S --noconfirm --needed gtk-theme-glossyblack
    yay -S --noconfirm --needed mcos-mjv-xfce-edition
    yay -S --noconfirm --needed xfce4-theme-switcher
    yay -S --noconfirm --needed xts-windows10-theme
    yay -S --noconfirm --needed xts-macos-theme
    yay -S --noconfirm --needed xts-dark-theme
    yay -S --noconfirm --needed xts-arcolinux-theme
    yay -S --noconfirm --needed xts-windowsxp-theme
    yay -S --noconfirm --needed xts-windows-server-2003-theme
  else
    paru -S --noconfirm --needed xfce4-screensaver
    paru -S --noconfirm --needed xfce4-panel-profiles-git
    paru -S --noconfirm --needed mugshot
    paru -S --noconfirm --needed solarized-dark-themes
    paru -S --noconfirm --needed gtk-theme-glossyblack
    paru -S --noconfirm --needed mcos-mjv-xfce-edition
    paru -S --noconfirm --needed xfce4-theme-switcher
    paru -S --noconfirm --needed xts-windows10-theme
    paru -S --noconfirm --needed xts-macos-theme
    paru -S --noconfirm --needed xts-dark-theme
    paru -S --noconfirm --needed xts-arcolinux-theme
    paru -S --noconfirm --needed xts-windowsxp-theme
    paru -S --noconfirm --needed xts-windows-server-2003-theme
  fi
}
################################################################################
### Installing Budgie DE                                                     ###
################################################################################
function BUDGIE_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Budgie Desktop                                            ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed budgie-desktop budgie-extras
  sudo pacman -S --noconfirm --needed gnome-system-monitor
  sudo pacman -S --noconfirm --needed nautilus
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed gnome-control-center
  sudo pacman -S --noconfirm --needed gnome-backgrounds
  sudo pacman -S --noconfirm --needed gnome-calculator
  sudo pacman -S --noconfirm --needed gedit
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed ark file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed gnome-tweaks
}
################################################################################
### Install The Cinnamon DE                                                  ###
################################################################################
function CINNAMON_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Cinnamon Desktop                                          ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed cinnamon
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed gnome-system-monitor
  sudo pacman -S --noconfirm --needed gnome-calculator
  sudo pacman -S --noconfirm --needed gpicview
  sudo pacman -S --noconfirm --needed gedit
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed ark file-roller unrar p7zip
  yay -S --noconfirm --needed mint-themes
  yay -S --noconfirm --needed cinnamon-sound-effects
}
################################################################################
### Install The LXDE DE                                                      ###
################################################################################
function LXDE_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The LXDE Desktop                                              ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed lxde
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed gnome-calculator
  sudo pacman -S --noconfirm --needed gedit
  sudo pacman -S --noconfirm --needed picom
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed ark file-roller unrar p7zip
  yay -S --noconfirm --needed mugshot
}
################################################################################
### Install The LXQT DE                                                      ###
################################################################################
function LXQT_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The LXQT Desktop                                              ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed lxqt
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed picom
  sudo pacman -S --noconfirm --needed gnome-calculator
  sudo pacman -S --noconfirm --needed gedit
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed ark file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed packagekit-qt5
}
################################################################################
### Install The i3 Window Manager                                            ###
################################################################################
function I3_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The i3 Window Manager                                         ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed i3
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed ark file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed picom
  sudo pacman -S --noconfirm --needed dmenu
  sudo pacman -S --noconfirm --needed rofi
  sudo pacman -S --noconfirm --needed nitrogen
  sudo pacman -S --noconfirm --needed feh
  sudo pacman -S --noconfirm --needed thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman
  sudo pacman -S --noconfirm --needed xfce4-terminal
  sudo pacman -S --noconfirm --needed papirus-icon-theme
  sudo pacman -S --noconfirm --needed network-manager-applet
  sudo pacman -S --noconfirm --needed arandr
  sudo pacman -S --noconfirm --needed scrot
  sudo pacman -S --noconfirm --needed lxappearance-gtk3
  yay -S --noconfirm --needed mugshot
  yay -S --noconfirm --needed i3exit
  yay -S --noconfirm --needed ttf-font-awesome
  #yay -S --noconfirm --needed betterlockscreen
  mkdir ~/.config/i3
  cd ~/.config/i3
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/config-i3
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/i3status-config
  cp config-i3 config
  cd ~/
}
################################################################################
### Install Enlightenment DE                                                 ###
################################################################################
function ENLIGHTENMENT_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Enlightenment Desktop                                     ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed enlightenment efl efl-docs
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed ark file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed acpid
  sudo pacman -S --noconfirm --needed xfce4-terminal
  sudo pacman -S --noconfirm --needed thunar thunar-archive-plugin thunar-media-tags-plugin
  yay -S --noconfirm --needed econnman
  yay -S --noconfirm --needed esound
  sudo systemctl enable connman
  sudo systemctl enable acpid
}
################################################################################
### Install Sway Window Tiling Manager                                       ###
################################################################################
function SWAY_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Sway Tiling Window Manager                                ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed sway
  sudo pacman -S --noconfirm --needed swaybg
  sudo pacman -S --noconfirm --needed swayidle
  sudo pacman -S --noconfirm --needed swaylock
  sudo pacman -S --noconfirm --needed waybar
  sudo pacman -S --noconfirm --needed dmenu
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed ark file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed dmenu
  sudo pacman -S --noconfirm --needed alacritty
  sudo pacman -S --noconfirm --needed thunar thunar-archive-plugin thunar-media-tags-plugin
  sudo pacman -S --noconfirm --needed network-manager-applet
  mkdir .config/sway
  cp /etc/sway/config .config/sway/config
}
################################################################################
### Install the BSPWM Tiling Window Manager                                  ###
################################################################################
function BSPWM_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The BSPWM Tiling Window Manager                                ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed bspwm
  sudo pacman -S --noconfirm --needed sxhkd
  sudo pacman -S --noconfirm --needed dmenu
  sudo pacman -S --noconfirm --needed nitrogen
  sudo pacman -S --noconfirm --needed picom
  sudo pacman -S --noconfirm --needed thunar thunar-archive-plugin thunar-media-tags-plugin
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed ark file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed arandr
  sudo pacman -S --noconfirm --needed network-manager-applet
  yay -S --noconfirm --needed polybar
  mkdir ~/.config/bspwm
  mkdir ~/.config/sxhkd
  mkdir ~/.config/polybar
  cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
  chmod +x ~/.config/bspwm/bspwmrc
  cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc
  chmod +x ~/.config/sxhkd/sxhkdrc
  cp /usr/share/doc/polybar/config ~/.config/polybar/config
  chmod +x ~/.config/polybar/config
}
################################################################################
### Setup LightDM (Display Manager/Login)                                    ###
################################################################################
function LIGHTDM_INSTALL() {
  clear
  echo "################################################################################"
  echo "### Installing The LightDM Login Manager                                     ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
  sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
}
################################################################################
### Setup SDDM (Display Manager/Login)                                       ###
################################################################################
function SDDM_INSTALL() {
  clear
  echo "################################################################################"
  echo "### Installing The SDDM Login Manager                                        ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed sddm
  sudo systemctl enable sddm
}
################################################################################
### Setup GDM (Display Manager/Login)                                        ###
################################################################################
function GDM_INSTALL() {
  clear
  echo "################################################################################"
  echo "### Installing The GDM Manager                                               ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed gdm
  sudo systemctl enable gdm
}
################################################################################
### Setup Entrance (Display/Login)                                           ###
################################################################################
function ENTRANCE_INSTALL() {
  clear
  echo "################################################################################"
  echo "### Installing The Entrance Login Manager                                    ###"
  echo "################################################################################"
  sleep 2
  yay -S --noconfirm --needed entrance-git
  sudo systemctl enable entrance
}
################################################################################
### DE Selection                                                             ###
################################################################################
function DE_SELECTION() {
  clear
  echo "##############################################################################"
  echo "### What is your preferred desktop environment?                            ###"
  echo "### 1)  Deepin                                                             ###"
  echo "### 2)  Gnome                                                              ###"
  echo "### 3)  KDE Plasma                                                         ###"
  echo "### 4)  Mate                                                               ###"
  echo "### 5)  XFCE4                                                              ###"
  echo "### 6)  Budgie                                                             ###"
  echo "### 7)  Cinnamon                                                           ###"
  echo "### 8)  LXDE                                                               ###"
  echo "### 9)  LXQT                                                               ###"
  echo "### 10) i3                                                                 ###"
  echo "### 11) Enlightenment                                                      ###"
  echo "### 12) Sway                                                               ###"
  echo "### 13) Bspwm                                                              ###"
  echo "### 14) None                                                               ###"
  echo "##############################################################################"
  read case;

  case $case in
    1)
    DEEPIN_DE
    DE="DEEPIN"
    ;;
    2)
    GNOME_DE
    DE="GNOME"
    ;;
    3)
    PLASMA_DE
    DE="PLASMA"
    ;;
    4)
    MATE_DE
    DE="MATE"
    ;;
    5)
    XFCE_DE
    DE="XFCE"
    ;;
    6)
    BUDGIE_DE
    DE="BUDGIE"
    ;;
    7)
    CINNAMON_DE
    DE="CINNAMON"
    ;;
    8)
    LXDE_DE
    DE="LXDE"
    ;;
    9)
    LXQT_DE
    DE="LXQT"
    ;;
    10)
    I3_DE
    DE="I3"
    ;;
    11)
    ENLIGHTENMENT_DE
    DE="ENLIGHTENMENT"
    ;;
    12)
    SWAY_DE
    DE="SWAY"
    ;;
    13)
    BSPWM_DE
    DE="BSPWM"
    ;;
    14)
    clear
    echo "##############################################################################"
    echo "### You Have Selected None                                                 ###"
    echo "##############################################################################"
    ;;
  esac
}
################################################################################
### Install nVidia Video Drivers                                             ###
################################################################################
function NVIDIA_DRIVERS() {
  clear
  echo "################################################################################"
  echo "### Installing nVidia Video Drivers                                          ###"
  echo "################################################################################"
  sleep 2
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
}
################################################################################
### Install AMD Video Drivers                                                ###
################################################################################
function AMD_DRIVERS() {
  clear
  echo "################################################################################"
  echo "### Installing AMD Video Drivers                                             ###"
  echo "################################################################################"
  sleep 2
  #yay -S --noconfirm --needed amdgpu-pro-libgl
  #yay -S --noconfirm --needed lib32-amdgpu-pro-libgl
  #yay -S --noconfirm --needed amdvlk
  #yay -S --noconfirm --needed lib32-amdvlk
  yay -S --noconfirm --needed opencl-amd
  echo "##############################################################################"
  echo "### Congrats On Supporting Open Source GPU Vendor                          ###"
  echo "##############################################################################"
}
################################################################################
### Installing Additional Sound Themes                                       ###
################################################################################
function SOUNDFILES() {
  clear
  echo "################################################################################"
  echo "### Installing Sound Themes                                                  ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed deepin-sound-theme
  yay -S --noconfirm --needed sound-theme-smooth
  yay -S --noconfirm --needed sound-theme-elementary-git
  yay -S --noconfirm --needed yaru-sound-theme
}
################################################################################
### Install More Fonts                                                       ###
################################################################################
function FONTINSTALL() {
  clear
  echo "################################################################################"
  echo "### Installing Extra Fonts                                                   ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed adobe-source-sans-pro-fonts
  sudo pacman -S --noconfirm --needed cantarell-fonts
  sudo pacman -S --noconfirm --needed noto-fonts
  sudo pacman -S --noconfirm --needed terminus-font
  sudo pacman -S --noconfirm --needed ttf-bitstream-vera
  sudo pacman -S --noconfirm --needed ttf-dejavu
  sudo pacman -S --noconfirm --needed ttf-droid
  sudo pacman -S --noconfirm --needed ttf-inconsolata
  sudo pacman -S --noconfirm --needed ttf-liberation
  sudo pacman -S --noconfirm --needed ttf-roboto
  sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family
  sudo pacman -S --noconfirm --needed tamsyn-font
  sudo pacman -S --noconfirm --needed awesome-terminal-fonts
  sudo pacman -S --noconfirm --needed ttf-font-awesome
  sudo pacman -S --noconfirm --needed ttf-hack
  sudo pacman -S --noconfirm --needed ttf-ibm-plex
  yay -S --noconfirm --needed ttf-ms-fonts
  yay -S --noconfirm --needed steam-fonts
  yay -S --noconfirm --needed ttf-mac-fonts
}
################################################################################
### Software To Install (My Standard Applications)                           ###
################################################################################
function SOFTWAREINSTALLSTD() {
  clear
  echo "################################################################################"
  echo "### Installing Standard Applications                                         ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed firefox
  sudo pacman -S --noconfirm --needed winetricks
  sudo pacman -S --noconfirm --needed playonlinux
  sudo pacman -S --noconfirm --needed steam
  sudo pacman -S --noconfirm --needed handbrake
  sudo pacman -S --noconfirm --needed obs-studio
  sudo pacman -S --noconfirm --needed gimp
  sudo pacman -S --noconfirm --needed libreoffice-fresh
  sudo pacman -S --noconfirm --needed clementine
  sudo pacman -S --noconfirm --needed kdenlive
  sudo pacman -S --noconfirm --needed aspell-en
  sudo pacman -S --noconfirm --needed youtube-dl
  yay -S --noconfirm --needed tuned
  yay -S --noconfirm --needed bpytop
  #sudo systemctl enable tuned.service
}
################################################################################
### Software To Install (My Standard Applications)                           ###
################################################################################
function SOFTWAREINSTALLEXTRA() {
  clear
  echo "################################################################################"
  echo "### Installing Extra Applications                                            ###"
  echo "################################################################################"
  sleep 2
  #3d Printer
  sudo pacman -S --noconfirm --needed cura
  sudo pacman -S --noconfirm --needed prusa-slicer
  yay -S --noconfirm --needed mattercontrol
  #Accessories
  sudo pacman -S --noconfirm --needed cool-retro-term
  yay -S --noconfirm --needed isomaster
  yay -S --noconfirm --needed multibootusb-git
  yay -S --noconfirm --needed ventoy-bin
  yay -S --noconfirm --needed mintstick-git
  yay -S --noconfirm --needed rpi-imager
  #Chat
  sudo pacman -S --noconfirm --needed hexchat
  sudo pacman -S --noconfirm --needed teamspeak3
  sudo pacman -S --noconfirm --needed telegram-desktop
  yay -S --noconfirm --needed skypeforlinux-preview-bin
  yay -S --noconfirm --needed zoom
  yay -S --noconfirm --needed discord
  #Games
  sudo pacman -S --noconfirm --needed extremetuxracer
  sudo pacman -S --noconfirm --needed supertux
  sudo pacman -S --noconfirm --needed supertuxkart
  yay -S --noconfirm --needed gamemode lib32-gamemode
  yay -S --noconfirm --needed minecraft
  #Graphics
  sudo pacman -S --noconfirm --needed librecad
  sudo pacman -S --noconfirm --needed darktable
  sudo pacman -S --noconfirm --needed inkscape
  sudo pacman -S --noconfirm --needed krita
  sudo pacman -S --noconfirm --needed blender
  sudo pacman -S --noconfirm --needed openscad
  sudo pacman -S --noconfirm --needed luminancehdr
  sudo pacman -S --noconfirm --needed freecad
  yay -S --noconfirm --needed drawio-desktop
  #Internet
  sudo pacman -S --noconfirm --needed transmission-gtk
  sudo pacman -S --noconfirm --needed fragments
  sudo pacman -S --noconfirm --needed remmina
  #Office
  sudo pacman -S --noconfirm --needed homebank
  #Programming
  sudo pacman -S --noconfirm --needed atom
  sudo pacman -S --noconfirm --needed meld
  sudo pacman -S --noconfirm --needed rust rust-docs rust-racer uncrustify
  #Sound/Video
  sudo pacman -S --noconfirm --needed audacity
  sudo pacman -S --noconfirm --needed openshot
  sudo pacman -S --noconfirm --needed shotcut
  sudo pacman -S --noconfirm --needed quodlibet
  sudo pacman -S --noconfirm --needed vlc
  yay -S --noconfirm --needed makemkv
  yay -S --noconfirm --needed olive
  yay -S --noconfirm --needed lbry-app-bin
  #System Utilities
  sudo pacman -S --noconfirm --needed cockpit cockpit-machines cockpit-pcp cockpit-podman
  sudo pacman -S --noconfirm --needed syncthing-gtk
  sudo pacman -S --noconfirm --needed dconf-editor
  sudo pacman -S --noconfirm --needed virt-manager
  sudo pacman -S --noconfirm --needed ebtables iptables
  sudo pacman -S --noconfirm --needed dnsmasq
  sudo pacman -S --noconfirm --needed virglrenderer
  sudo pacman -S --noconfirm --needed qemu-arch-extra
  sudo pacman -S --noconfirm --needed qemu-guest-agent
  yay -S --noconfirm --needed ovmf
  yay -S --noconfirm --needed virtio-win
  yay -S --noconfirm --needed libguestfs
  sudo pacman -S --noconfirm --needed pacmanlogviewer
  sudo pacman -S --noconfirm --needed exfat-utils
  sudo pacman -S --noconfirm --needed hardinfo
  sudo pacman -S --noconfirm --needed deluge
  sudo pacman -S --noconfirm --needed plank
  #yay -S --noconfirm --needed plank-theme-arc plank-theme-numix plank-theme-namor unity-like-plank-theme
  sudo pacman -S --noconfirm --needed cairo-dock cairo-dock-plug-ins
  yay -S --noconfirm --needed cairo-dock-themes cairo-dock-plug-ins-extras
  yay -S --noconfirm --needed dxvk-bin
  yay -S --noconfirm --needed timeshift
  yay -S --noconfirm --needed stacer
  yay -S --noconfirm --needed protontricks
}
################################################################################
### Set up login                                                             ###
################################################################################
function LOGIN_SETUP() {
#  if [[ $DM == "LIGHTDM" ]]; then
#    sudo sed -i 's/'#user-session=default'/'user-session=cinnamon'/g' /etc/lightdm/lightdm.conf
#  fi
  if [[ $DM == "NONE" ]]; then
    sed -i 's/'twm'/'#twm'/g' .xinitrc
    sed -i 's/'xclock'/'#xclock'/g' .xinitrc
    sed -i 's/'xterm'/'#xterm'/g' .xinitrc
    sed -i 's/'exec'/'#exec'/g' .xinitrc
  fi
  if [[ $DE == "DEEPIN" ]]; then
    echo "exec startdde" >> .xinitrc
  fi
  if [[ $DE == "GNOME" ]]; then
    echo "exec gnome-session" >> .xinitrc
  fi
  if [[ $DE == "PLASMA" ]]; then
    echo "exec startplasma-x11" >> .xinitrc
  fi
  if [[ $DE == "MATE" ]]; then
    echo "exec mate-session" >> .xinitrc
  fi
  if [[ $DE == "XFCE" ]]; then
    echo "exec startxfce4" >> .xinitrc
  fi
  if [[ $DE == "BUDGIE" ]]; then
    echo "exec budgie-desktop" >> .xinitrc
  fi
  if [[ $DE == "CINNAMON" ]]; then
    echo "exec cinnamon-session" >> .xinitrc
  fi
  if [[ $DE == "LXDE" ]]; then
    echo "exec startlxde" >> .xinitrc
  fi
  if [[ $DE == "LXQT" ]]; then
    echo "exec startlxqt" >> .xinitrc
  fi
  if [[ $DE == "I3" ]]; then
    echo "exec i3" >> .xinitrc
  fi
  if [[ $DE == "ENLIGHTENMENT" ]]; then
    echo "exec enlightenment_start" >> .xinitrc
  fi
  if [[ $DE == "SWAY" ]]; then
    echo "exec sway" >> .xinitrc
  fi
  if [[ $DE == "BSPWM" ]]; then
    echo "exec bspwm" >> .xinitrc
  fi
}
################################################################################
### Fix the Pacman Keyring                                                   ###
################################################################################
function PACMAN_KEYS() {
  clear
  echo "################################################################################"
  echo "### Fixing The Pacman (Repo) Keys                                            ###"
  echo "################################################################################"
  sleep 2
  sudo pacman-key --init
  sudo pacman-key --populate archlinux
  sudo reflector --country US --age 6 --sort rate --verbose --save /etc/pacman.d/mirrorlist
  sudo pacman -Sy
}
################################################################################
### Main Program                                                             ###
################################################################################
PACMAN_KEYS
clear
echo "################################################################################"
echo "### Which AUR Helper Do You Want To Install?                                 ###"
echo "### 1)  YAY                                                                  ###"
echo "### 2)  PARU                                                                 ###"
echo "################################################################################"
read case;

case $case in
  1)
  INSTALLYAY
  ZB=1
  ;;
  2)
  INSTALLPARU
  ZB=0
  ;;
esac
SOUNDSETUP
BLUETOOTHSETUP
PRINTERSETUP
clear
echo "################################################################################"
echo "### Do you want SAMBA network sharing installed?                             ###"
echo "### 1)  Yes                                                                  ###"
echo "### 2)  No                                                                   ###"
echo "################################################################################"
read case;

case $case in
  1)
  SAMBASETUP
  ;;
  2)
  ;;
esac
UNICODEFIX
DISPLAYMGR
clear
echo "################################################################################"
echo "### What Display manager/Logon manager installed?                            ###"
echo "### 1)  LightDM                                                              ###"
echo "### 2)  Simple Display Manager (SDDM)                                        ###"
echo "### 3)  Gnome Display Manager (GDM)                                          ###"
echo "### 4)  Entrance Display Manager (ENT)                                       ###"
echo "### 5)  None                                                                 ###"
echo "################################################################################"
read case;

case $case in
  1)
  LIGHTDM_INSTALL
  DM="LIGHTDM"
  ;;
  2)
  SDDM_INSTALL
  DM="SDDM"
  ;;
  3)
  GDM_INSTALL
  DM="GDM"
  ;;
  4)
  ENTRANCE_INSTALL
  DM="ENT"
  ;;
  5)
  sudo cp /etc/X11/xinit/xinitrc .xinitrc
  DM="NONE"
  ;;
esac
clear
echo "################################################################################"
echo "### Do you want a Desktop Environment (Gnome, Plasma, etc) installed?        ###"
echo "### 1)  Yes                                                                  ###"
echo "### 2)  No                                                                   ###"
echo "################################################################################"
read case;

case $case in
  1)
  DE_SELECTION
  ;;
  2)
  ;;
esac
LOGIN_SETUP
#SOFTWARECENTER
SOUNDFILES
FONTINSTALL
clear
echo "################################################################################"
echo "### Do you want a good starting standard software selection installed?       ###"
echo "### ------------------------------------------------------------------------ ###"
echo "### (Firefox, Wine Tricks, PlayOnLinux, Steam, Handbrake, OBS Studio, GIMP)  ###"
echo "### (LibreOffice - Fresh, Clementine, KDENLive, ASpell, YouTube-DL)          ###"
echo "### ------------------------------------------------------------------------ ###"
echo "### 1) Yes                                                                   ###"
echo "### 2) No                                                                    ###"
echo "################################################################################"
read case;

case $case in
  1)
  SOFTWAREINSTALLSTD
  ;;
  2)
  ;;
esac
clear
echo "################################################################################"
echo "### Do you want a good extra software selection installed?                   ###"
echo "### ------------------------------------------------------------------------ ###"
echo "### (Cura, Prusa Slicer, Matter Control, Cool Retro Term, ISO Master)        ###"
echo "### (MultiBoot USB, Ventoy, MintStick, RPI Imager, Hexchat, TeamSpeak)       ###"
echo "### (Telegram, Skype, Zoom, Discord, Extreme Tux Racer, SuperTux)            ###"
echo "### (SuperTux Kart, GameMode, Minecraft, LibreCAD, Darktable, Inkscape)      ###"
echo "### (Krita, Blender, OpenSCAD, Luminance HDR, DrawIO, FreeCAD, Transmission) ###"
echo "### (Fragments, Remmina, Homebank, Atom, Meld, Rust, Auducity, OpenShot)     ###"
echo "### (Shotcut, QuodLibet, VLC, MakeMKV, Olive, LBRY, Cockpit, SyncThing)      ###"
echo "### (DConf Editor, Virt Manager, Pacman Log Viewer, HardInfo, Deluge, Plank) ###"
echo "### (Cairo Dock, DXVK, TimeShift, Stacer, Proton Tricks)                     ###"
echo "### ------------------------------------------------------------------------ ###"
echo "### 1) Yes                                                                   ###"
echo "### 2) No                                                                    ###"
echo "################################################################################"
read case;

case $case in
  1)
  SOFTWAREINSTALLEXTRA
  sudo systemctl enable --now cockpit.socket
  sudo systemctl enable libvirtd.service
  sudo systemctl enable virtlogd.service
  sudo sed -i '/\[global\]'/a'Environment="LD_LIBRARY_PATH=/usr/lib"' /etc/systemd/system/multi-user.target.wants/libvirtd.service
  #sed -e '/"Type=simple"'/a'Environment="LD_LIBRARY_PATH=/usr/lib"' /etc/systemd/system/multi-user.target.wants/libvirtd.service
  echo "options kvm-intel nested=1" | sudo tee /etc/modprobe.d/kvm-intel.conf
  ;;
  2)
  ;;
esac

if [[ $(lspci -k | grep VGA | grep -i nvidia) ]]; then
  NVIDIA_DRIVERS
fi

if [[ $(lspci -k | grep VGA | grep -i amd) ]]; then
  AMD_DRIVERS
fi

echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-sysctl.conf

clear
echo "##############################################################################"
echo "### Installation Is Complete, Please Reboot And Have Fun                   ###"
echo "##############################################################################"
