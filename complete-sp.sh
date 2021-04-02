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
  sudo sed -i 's/#BottomUp/BottomUp/' /etc/paru.conf
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
  sudo pacman -S --noconfirm --needed pulseaudio pulseaudio-alsa pavucontrol alsa-utils alsa-plugins alsa-lib alsa-firmware lib32-alsa-lib lib32-alsa-oss lib32-alsa-plugins gstreamer gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly volumeicon playerctl
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
  sudo pacman -S --noconfirm --needed pulseaudio-bluetooth bluez bluez-libs bluez-utils bluez-plugins blueberry bluez-tools bluez-cups
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
  sudo pacman -S --noconfirm --needed cups cups-pdf ghostscript gsfonts gutenprint gtk3-print-backends libcups system-config-printer foomatic-db foomatic-db-ppds foomatic-db-gutenprint-ppds foomatic-db-engine foomatic-db-nonfree foomatic-db-nonfree-ppds  #hplip
  $ZB -S --noconfirm --needed epson-inkjet-printer-escpr
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
  sudo pacman -S --noconfirm --needed  gvfs-smb avahi nss-mdns
  sudo systemctl enable avahi-daemon.service
  sudo systemctl start avahi-daemon.service
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
  sudo pacman -S --noconfirm --needed xorg xorg-drivers xorg-xinit xterm kvantum-qt5 terminator
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
  sudo pacman -S --noconfirm --needed deepin deepin-extra gnome-disk-utility ark file-roller unrar p7zip onboard deepin-kwin deepin-polkit-agent deepin-polkit-agent-ext-gnomekeyring packagekit-qt5
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
  sudo pacman -S --noconfirm --needed gnome gnome-extra nautilus-share chrome-gnome-shell variety gnome-packagekit gnome-software-packagekit-plugin

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
  $ZB -S --noconfirm --needed gnome-shell-extension-dash-to-dock gnome-shell-extension-dash-to-panel gnome-shell-extension-arc-menu-git gnome-shell-extension-openweather-git gnome-shell-extension-topicons-plus gnome-shell-extension-audio-output-switcher-git gnome-shell-extension-clipboard-indicator-git gnome-shell-extension-coverflow-alt-tab-git gnome-shell-extension-animation-tweaks-git gnome-shell-extension-extended-gestures-git gnome-shell-extension-transparent-window-moving-git gnome-shell-extension-pop-shell-git pop-shell-shortcuts-git gnome-alsamixer gnome-shell-extension-vitals gnome-shell-extension-drop-down-terminal-x gnome-shell-extension-material-shell-git gnome-shell-extension-slinger-git gnome-shell-extension-transparent-osd-git
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
  sudo pacman -S --noconfirm --needed plasma kde-applications gnome-disk-utility redshift packagekit-qt5
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
  sudo pacman -S --noconfirm --needed mate mate-extra gnome-disk-utility variety onboard ark file-roller unrar p7zip
  $ZB -S --noconfirm --needed mate-tweak brisk-menu mate-screensaver-hacks mugshot
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
  sudo pacman -S --noconfirm --needed xfce4 xfce4-goodies gnome-disk-utility ark file-roller unrar p7zip alacarte gnome-calculator picom variety libnma networkmanager networkmanager-openconnect networkmanager-openvpn networkmanager-pptp nm-connection-editor network-manager-applet onboard
  $ZB -S --noconfirm --needed xfce4-screensaver xfce4-panel-profiles-git mugshot solarized-dark-themes gtk-theme-glossyblack mcos-mjv-xfce-edition xfce4-theme-switcher xts-windows10-theme xts-macos-theme xts-dark-theme xts-arcolinux-theme xts-windowsxp-theme xts-windows-server-2003-theme
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
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
  sudo pacman -S --noconfirm --needed budgie-desktop budgie-extras gnome-system-monitor nautilus gnome-disk-utility gnome-control-center gnome-backgrounds gnome-calculator gedit variety onboard ark file-roller unrar p7zip gnome-tweaks
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
  sudo pacman -S --noconfirm --needed cinnamon gnome-disk-utility gnome-system-monitor gnome-calculator gpicview gedit variety onboard ark file-roller unrar p7zip
  $ZB -S --noconfirm --needed mint-themes cinnamon-sound-effects
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
  sudo pacman -S --noconfirm --needed lxde gnome-disk-utility gnome-calculator gedit picom variety onboard ark file-roller unrar p7zip
  $ZB -S --noconfirm --needed mugshot
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
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
  sudo pacman -S --noconfirm --needed lxqt gnome-disk-utility picom gnome-calculator gedit variety onboard ark file-roller unrar p7zip packagekit-qt5
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
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
  sudo pacman -S --noconfirm --needed i3 gnome-disk-utility onboard ark file-roller unrar p7zip picom dmenu rofi nitrogen feh thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman xfce4-terminal xfce4-screenshooter papirus-icon-theme network-manager-applet arandr scrot lxappearance polkit-gnome galculator
  $ZB -S --noconfirm --needed mugshot i3exit pnmixer
  #$ZB -S --noconfirm --needed betterlockscreen
  mkdir -p ~/.config/i3
  cd ~/.config/i3
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/config-i3
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/i3status-config
  cp config-i3 config
  cd ~/
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
  echo "alias conf='nano ~/.config/i3/config'" >> ~/.bashrc
  echo "alias conf-bar='nano ~/.config/i3/i3status-config'" >> ~/.bashrc
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
  sudo pacman -S --noconfirm --needed enlightenment efl efl-docs gnome-disk-utility onboard ark file-roller unrar p7zip acpid xfce4-terminal thunar thunar-archive-plugin thunar-media-tags-plugin
  $ZB -S --noconfirm --needed econnman esound
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
  sudo pacman -S --noconfirm --needed sway swaybg swayidle swaylock waybar dmenu rofi nitrogen onboard ark file-roller unrar p7zip xfce4-terminal thunar thunar-archive-plugin thunar-media-tags-plugin network-manager-applet xfce4-screenshooter papirus-icon-theme arandr gnome-disk-utility polkit-gnome grim feh eog galculator
  $ZB -S --noconfirm --needed mugshot j4-dmenu-desktop
  mkdir -p ~/.config/sway
  cd ~/.config/sway
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/config-sway
  cp config-sway config
  cd ~
  echo "alias conf='nano ~/.config/sway/config'" >> ~/.bashrc
  mkdir -p ~/.config/waybar
  cp /etc/xdg/waybar/* ~/.config/waybar/
  mkdir -p ~/Pictures/shots
}
################################################################################
### Install the BSPWM Tiling Window Manager                                  ###
################################################################################
function BSPWM_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The BSPWM Tiling Window Manager                               ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed bspwm sxhkd dmenu rofi nitrogen picom xfce4-terminal thunar thunar-archive-plugin thunar-media-tags-plugin xfce4-screenshooter onboard ark file-roller unrar p7zip arandr network-manager-applet gnome-disk-utility feh eog lxappearance galculator
  $ZB -S --noconfirm --needed pnmixer mugshot polybar
  #$ZB -S --noconfirm --needed j4-dmenu-desktop
  mkdir -p ~/.config/bspwm
  mkdir -p ~/.config/sxhkd
  mkdir -p ~/.config/polybar
  cd ~/.config/bspwm
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/bspwmrc
  chmod +x ~/.config/bspwm/bspwmrc
  cd ~/.config/sxhkd
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/sxhkdrc
  chmod +x ~/.config/sxhkd/sxhkdrc
  cd ~/.config/polybar
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/config-polybar
  cp config-polybar config
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/launch.sh
  chmod +x ~/.config/polybar/config
  chmod +x ~/.config/polybar/launch.sh
  cd ~/
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
  echo "alias conf='nano ~/.config/bspwm/bspwmrc'" >> ~/.bashrc
  echo "alias conf-key='nano ~/.config/sxhkd/sxhkdrc'" >> ~/.bashrc
  echo "alias conf-bar='nano ~/.config/polybar/config'" >> ~/.bashrc
}
################################################################################
### Install the FVWM Window Manager                                          ###
################################################################################
function FVWM_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The FVWM Window Manager                                       ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed fvwm nitrogen thunar thunar-archive-plugin thunar-media-tags-plugin xfce4-terminal ark file-roller unrar p7zip arandr picom archlinux-xdg-menu gnome-disk-utility network-manager-applet lxappearance
  mkdir .fvwm
  cd .fvwm
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/config-fvwm
  cp config-fvwm config
  cd ~/
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
}
################################################################################
### Install the IceWM Window Manager                                         ###
################################################################################
function ICEWM_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The IceWM Window Manager                                      ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed icewm nitrogen thunar thunar-archive-plugin thunar-media-tags-plugin xfce4-terminal ark file-roller unrar p7zip arandr picom archlinux-xdg-menu gnome-disk-utility network-manager-applet lxappearance
  mkdir .icewm
  cp -R /usr/share/icewm/* ~/.icewm/
  cd ~/.icewm
  echo "#!/bin/bash" >> startup
  echo "" >> startup
  echo "# Start Network Manager" >> startup
  echo "sleep 1 &&" >> startup
  echo "nm-applet &" >> startup
  echo "" >> startup
  echo "# Start-up programs" >> startup
  echo "picom &" >> startup
  echo "nitrogen --random --set-zoom-fill &" >> startup
  echo "" >> startup
  echo "# Allow Notifications" >> startup
  echo "/usr/lib/notification-daemon-1.0/notification-daemon &" >> startup
  chmod +x startup
  cd ~/
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
}
################################################################################
### Install the PekWM Window Manager                                         ###
################################################################################
function PEKWM_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The PekWM Window Manager                                      ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed pekwm pekwm-themes menumaker nitrogen thunar thunar-archive-plugin thunar-media-tags-plugin xfce4-terminal ark file-roller unrar p7zip arandr picom archlinux-xdg-menu gnome-disk-utility network-manager-applet lxappearance
  mkdir .pekwm
  cd .pekwm
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/vars-pekwm
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/start-pekwm
  cp vars-pekwm vars
  cp start-pekwm start
  chmod +x start
  cd ~/
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
}
################################################################################
### Install the Afterstep Desktop                                            ###
################################################################################
function AFTERSTEP_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Afterstep                                                 ###"
  echo "################################################################################"
  sleep 2
  $ZB -S --noconfirm --needed afterstep wmbluecpu wmblueclock wmbluemem
  sudo pacman -S --noconfirm --needed nitrogen thunar thunar-archive-plugin thunar-media-tags-plugin xfce4-terminal ark file-roller unrar p7zip arandr picom gnome-disk-utility
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
}
################################################################################
### Install the Blackbox Desktop                                             ###
################################################################################
function BLACKBOX_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Blackbox                                                  ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed blackbox bbpager nitrogen thunar thunar-archive-plugin thunar-media-tags-plugin xfce4-terminal ark file-roller unrar p7zip arandr picom gnome-disk-utility menumaker lxappearance
  $ZB -S --noconfirm --needed idesk blackbox-explorer
  mkdir .blackbox
  echo "session.styleFile:/usr/share/blackbox/styles/Gray" >> ~/.blackboxrc
  echo "session.menuFile:~/.blackbox/menu" >> ~/.blackboxrc
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
}
################################################################################
### Install the Fluxbox Desktop                                              ###
################################################################################
function FLUXBOX_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Fluxbox                                                   ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed fluxbox nitrogen thunar thunar-archive-plugin thunar-media-tags-plugin xfce4-terminal ark file-roller unrar p7zip arandr picom gnome-disk-utility menumaker lxappearance
  $ZB -S --noconfirm --needed ipager fbdesk fbmenugen fluxmod-styles
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
}
################################################################################
### Install the Openbox Window Manager                                       ###
################################################################################
function OPENBOX_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Openbox Window Manager                                    ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed openbox nitrogen thunar thunar-archive-plugin thunar-media-tags-plugin xfce4-terminal ark file-roller unrar p7zip arandr picom archlinux-xdg-menu gnome-disk-utility network-manager-applet lxappearance lxappearance-obconf obconf menumaker
  $ZB -S --noconfirm --needed obmenu3
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
}
################################################################################
### Install the WindowMaker Window Manager                                   ###
################################################################################
function WINDOWMAKER_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The WindowMaker Window Manager                                ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed nitrogen thunar thunar-archive-plugin thunar-media-tags-plugin xfce4-terminal ark file-roller unrar p7zip arandr picom archlinux-xdg-menu gnome-disk-utility network-manager-applet menumaker
  $ZB -S --noconfirm --needed windowmaker windowmaker-extra wmcalclock wmcpuload wmappl wmcpumon wmnet wmmixer idesk docker-tray wmblueclock wmbluecpu wmsystemtray
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
}
################################################################################
### Install the WindowMaker Window Manager                                   ###
################################################################################
function AWESOME_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Awesome Window Manager                                    ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed awesome vicious nitrogen thunar thunar-archive-plugin thunar-media-tags-plugin xfce4-terminal ark file-roller unrar p7zip arandr picom gnome-disk-utility network-manager-applet
  mkdir -p ~/.config/awesome/
  cp /etc/xdg/awesome/rc.lua ~/.config/awesome/
  wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
  sudo rm /etc/xdg/picom.conf
  sudo mv picom.conf /etc/xdg/picom.conf
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
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings lightdm-webkit-theme-litarvan lightdm-webkit2-greeter
  $ZB -S --noconfirm --needed lightdm-webkit2-theme-material2 lightdm-webkit-theme-aether lightdm-webkit-theme-petrichor-git lightdm-webkit-theme-sequoia-git lightdm-webkit-theme-contemporary lightdm-webkit2-theme-sapphire lightdm-webkit2-theme-obsidian
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
  $ZB -S --noconfirm --needed entrance-git
  sudo systemctl enable entrance
}
################################################################################
### DE Selection                                                             ###
################################################################################
function DE_SELECTION() {
  clear
  echo "##############################################################################"
  echo "### What is your preferred desktop environment?                            ###"
  echo "### 1)  Deepin                            21) WindowMaker                  ###"
  echo "### 2)  Gnome                             22) Awesome (WIP)                ###"
  echo "### 3)  KDE Plasma                        23) None                         ###"
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
  echo "### 14) FVWM                                                               ###"
  echo "### 15) IceWM                                                              ###"
  echo "### 16) PekWM                                                              ###"
  echo "### 17) Afterstep (WIP)                                                    ###"
  echo "### 18) Blackbox (WIP)                                                     ###"
  echo "### 19) Fluxbox                                                            ###"
  echo "### 20) Openbox                                                            ###"
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
    FVWM_DE
    DE="FVWM"
    ;;
    15)
    ICEWM_DE
    DE="ICEWM"
    ;;
    16)
    PEKWM_DE
    DE="PEKWM"
    ;;
    17)
    AFTERSTEP_DE
    DE="AFTERSTEP"
    ;;
    18)
    BLACKBOX_DE
    DE="BLACKBOX"
    ;;
    19)
    FLUXBOX_DE
    DE="FLUXBOX"
    ;;
    20)
    OPENBOX_DE
    DE="OPENBOX"
    ;;
    21)
    WINDOWMAKER_DE
    DE="WINDOWMAKER"
    ;;
    22)
    AWESOME_DE
    DE="AWESOME"
    ;;
    23)
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
  sudo pacman -S --noconfirm --needed nvidia nvidia-cg-toolkit nvidia-settings nvidia-utils lib32-nvidia-cg-toolkit lib32-nvidia-utils lib32-opencl-nvidia opencl-nvidia cuda ffnvcodec-headers lib32-libvdpau libxnvctrl pycuda-headers python-pycuda
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
  #$ZB -S --noconfirm --needed amdgpu-pro-libgl lib32-amdgpu-pro-libgl amdvlk lib32-amdvlk
  $ZB -S --noconfirm --needed opencl-amd
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
  $ZB -S --noconfirm --needed sound-theme-smooth sound-theme-elementary-git
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
  sudo pacman -S --noconfirm --needed adobe-source-sans-pro-fonts cantarell-fonts noto-fonts terminus-font ttf-bitstream-vera ttf-dejavu ttf-droid ttf-inconsolata ttf-liberation ttf-roboto ttf-ubuntu-font-family tamsyn-font awesome-terminal-fonts ttf-font-awesome ttf-hack ttf-ibm-plex
  $ZB -S --noconfirm --needed ttf-ms-fonts steam-fonts ttf-mac-fonts siji-git ttf-unifont ttf-font-awesome
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
  sudo pacman -S --noconfirm --needed firefox winetricks playonlinux steam handbrake obs-studio gimp libreoffice-fresh clementine kdenlive aspell-en youtube-dl paperwork
}
################################################################################
### Needed Software                                                          ###
################################################################################
function NEEDED_SOFTWARE() {
  clear
  echo "################################################################################"
  echo "### Installing Needed Applications                                           ###"
  echo "################################################################################"
  sleep 2
  $ZB -S --noconfirm --needed tuned duf fontpreview-ueberzug-git
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
  sudo pacman -S --noconfirm --needed cura prusa-slicer mattercontrol
  #Accessories
  sudo pacman -S --noconfirm --needed cool-retro-term
  $ZB -S --noconfirm --needed isomaster multibootusb-git ventoy-bin mintstick-git rpi-imager
  #Chat
  sudo pacman -S --noconfirm --needed hexchat teamspeak3 telegram-desktop discord
  $ZB -S --noconfirm --needed skypeforlinux-preview-bin zoom
  #Games
  sudo pacman -S --noconfirm --needed extremetuxracer supertux supertuxkart
  $ZB -S --noconfirm --needed gamemode lib32-gamemode minecraft-launcher
  #Graphics
  sudo pacman -S --noconfirm --needed librecad darktable inkscape krita blender openscad luminancehdr freecad
  $ZB -S --noconfirm --needed drawio-desktop
  #Internet
  sudo pacman -S --noconfirm --needed transmission-gtk fragments remmina
  #Office
  sudo pacman -S --noconfirm --needed homebank
  #Programming
  sudo pacman -S --noconfirm --needed atom meld rust rust-docs rust-racer uncrustify
  #Sound/Video
  sudo pacman -S --noconfirm --needed audacity openshot shotcut quodlibet vlc
  $ZB -S --noconfirm --needed makemkv olive lbry-app-bin
  #System Utilities
  sudo pacman -S --noconfirm --needed cockpit cockpit-machines cockpit-pcp cockpit-podman syncthing-gtk dconf-editor virt-manager ebtables iptables dnsmasq virglrenderer qemu-arch-extra qemu-guest-agent pacmanlogviewer exfat-utils hardinfo deluge plank cairo-dock cairo-dock-plug-ins
  $ZB -S --noconfirm --needed ovmf virtio-win libguestfs cairo-dock-themes cairo-dock-plug-ins-extras dxvk-bin timeshift stacer protontricks #plank-theme-arc plank-theme-numix plank-theme-namor unity-like-plank-theme
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
  #  sed -i 's/'exec'/'#exec'/g' .xinitrc
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
  if [[ $DE == "FVWM" ]]; then
    echo "exec fvwm" >> .xinitrc
  fi
  if [[ $DE == "ICEWM" ]]; then
    echo "exec icewm-session" >> .xinitrc
  fi
  if [[ $DE == "PEKWM" ]]; then
    echo "exec pekwm" >> .xinitrc
  fi
  if [[ $DE == "AFTERSTEP" ]]; then
    echo "exec picom &" >> .xinitrc
    echo "exec afterstep" >> .xinitrc
  fi
  if [[ $DE == "BLACKBOX" ]]; then
    echo "exec picom &" >> .xinitrc
    echo "exec blackbox" >> .xinitrc
  fi
  if [[ $DE == "FLUXBOX" ]]; then
    echo "exec picom &" >> .xinitrc
    echo "exec fluxbox" >> .xinitrc
  fi
  if [[ $DE == "OPENBOX" ]]; then
    echo "exec picom &" >> .xinitrc
    echo "exec openbox-session" >> .xinitrc
  fi
  if [[ $DE == "WINDOWMAKER" ]]; then
    echo "exec picom &" >> .xinitrc
    echo "exec wmaker" >> .xinitrc
  fi
  if [[ $DE == "AWESOME" ]]; then
    echo "exec picom &" >> .xinitrc
    echo "exec awesome" >> .xinitrc
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
  sudo reflector --country US --latest 20 --sort rate --verbose --save /etc/pacman.d/mirrorlist
  sudo pacman -Syyu
}
################################################################################
### Installing the LY Terminal Login Manager                                 ###
################################################################################
function LY_LM() {
  clear
  echo "################################################################################"
  echo "### Installing the LY Terminal Login Manager                                 ###"
  echo "################################################################################"
  sleep 2
  $ZB -S --noconfirm --needed ly
  sudo systemctl enable ly
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
  ZB="yay"
  ;;
  2)
  INSTALLPARU
  ZB="paru"
  ;;
esac
NEEDED_SOFTWARE
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
echo "### 5)  LY Terminal Display Manager (LY)                                     ###"
echo "### 6)  None                                                                 ###"
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
  LY_LM
  DM="LY"
  ;;
  6)
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
