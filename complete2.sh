#!/bin/bash
################################################################################
### Installing Complete Arch Linux By:                                       ###
### Erik Sundquist                                                           ###
################################################################################
### Review and edit before using                                             ###
################################################################################
set -e

################################################################################
### Get User Inputs                                                          ###
################################################################################
### Which AUR Helper                                                         ###
################################################################################
function AUR_HELPER() {
  clear
  echo "################################################################################"
  echo "### Which AUR Helper Do You Want To Install?                                 ###"
  echo "### 1)  YAY                                                                  ###"
  echo "### 2)  PARU                                                                 ###"
  echo "################################################################################"
  read case;

  case $case in
    1)
    ZB="yay"
    ;;
    2)
    ZB="paru"
    ;;
  esac
}
### Do You Want Samba Shares?                                                ###
################################################################################
function SAMBA_SHARES() {
  clear
  echo "################################################################################"
  echo "### Do you want SAMBA network sharing installed?                             ###"
  echo "### 1)  Yes                                                                  ###"
  echo "### 2)  No                                                                   ###"
  echo "################################################################################"
  read case;

  case $case in
    1)
    SAMBA_SH="yes"
    ;;
    2)
    SAMBA_SH="no"
    ;;
  esac
}
### Which Login / Display Manager                                            ###
################################################################################
function DISPLAY_MANAGER() {
  clear
  echo "################################################################################"
  echo "### Which Login / Display Manager Do You Want To Install?                    ###"
  echo "### 1)  LightDM GTK3                                                         ###"
  echo "### 2)  LightDM WebKit2                                                      ###"
  echo "### 3)  SDDM                                                                 ###"
  echo "### 4)  GDM                                                                  ###"
  echo "### 5)  Entrance                                                             ###"
  echo "### 6)  LY                                                                   ###"
  echo "################################################################################"
  read case;

  case $case in
    1)
    DM="lightdm-gtk3"
    ;;
    2)
    DM="lightdm-webkit2"
    ;;
    3)
    DM="sddm"
    ;;
    4)
    DM="gdm"
    ;;
    5)
    DM="entrance"
    ;;
    6)
    DM="ly"
    ;;
  esac
}
### Do You Want Printer Support                                              ###
################################################################################
function PRINTER_SUPPORT() {
  clear
  echo "################################################################################"
  echo "### Do You Want Printer Support?                                             ###"
  echo "### 1)  Yes                                                                  ###"
  echo "### 2)  No                                                                   ###"
  echo "################################################################################"
  read case;

  case $case in
    1)
    PSUPPORT="yes"
    clear
    echo "################################################################################"
    echo "### Do You Want HP Printer Support?                                          ###"
    echo "### 1)  Yes                                                                  ###"
    echo "### 2)  No                                                                   ###"
    echo "################################################################################"
    read case;
    case $case in
      1)
      HP_PRINT="yes"
      ;;
      2)
      HP_PRINT="no"
      ;;
    esac
    clear
    echo "################################################################################"
    echo "### Do You Want Epson Printer Support?                                       ###"
    echo "### 1)  Yes                                                                  ###"
    echo "### 2)  No                                                                   ###"
    echo "################################################################################"
    read case;
    case $case in
      1)
      EP_PRINT="yes"
      ;;
      2)
      EP_PRINT="no"
      ;;
    esac
    ;;
    2)
    PSUPPORT="no"
    ;;
  esac
}
### Do You Want Bluetooth Support                                            ###
################################################################################
function BLUETOOTH_SUPPORT() {
  clear
  echo "################################################################################"
  echo "### Do You Want Bluetooth Support?                                           ###"
  echo "### 1)  Yes                                                                  ###"
  echo "### 2)  No                                                                   ###"
  echo "################################################################################"
  read case;

  case $case in
    1)
    BT_SUPPORT="yes"
    ;;
    2)
    BT_SUPPORT="no"
    ;;
  esac
}
### What Desktop Environment or Window Manager                               ###
################################################################################
function WHAT_DE() {
  clear
  echo "################################################################################"
  echo "### What Desktop Environment Or Window Manager Do You Want To Use?           ###"
  echo "###  1)  Gnome                                                               ###"
  echo "###  2)  KDE Plasma                                                          ###"
  echo "###  3)  XFCE4                                                               ###"
  echo "###  4)  Deepin                                                              ###"
  echo "###  5)  Mate                                                                ###"
  echo "###  6)  Budgie                                                              ###"
  echo "###  7)  Cinnamon                                                            ###"
  echo "###  8)  LXDE                                                                ###"
  echo "###  9)  LXQT                                                                ###"
  echo "### 10)  I3                                                                  ###"
  echo "### 11)  Sway                                                                ###"
  echo "### 12)  BSPWM                                                               ###"
  echo "################################################################################"
  read case;

  case $case in
    1)
    DE_TOINST="gnome"
    ;;
    2)
    DE_TOINST="plasma"
    ;;
    3)
    DE_TOINST="xfce4"
    ;;
    4)
    DE_TOINST="deepin"
    ;;
    5)
    DE_TOINST="mate"
    ;;
    6)
    DE_TOINST="budgie"
    ;;
    7)
    DE_TOINST="cinnamon"
    ;;
    8)
    DE_TOINST="lxde"
    ;;
    9)
    DE_TOINST="lxqt"
    ;;
    10)
    DE_TOINST="i3"
    ;;
    11)
    DE_TOINST="sway"
    ;;
    12)
    DE_TOINST="bspwm"
    ;;
  esac
}
### Do You Want Extra Sound Themes?                                          ###
################################################################################
function SOUNDTHEME_SUPPORT() {
  clear
  echo "################################################################################"
  echo "### Do You Want To Install Extra Sound Themes?                               ###"
  echo "### 1)  Yes                                                                  ###"
  echo "### 2)  No                                                                   ###"
  echo "################################################################################"
  read case;

  case $case in
    1)
    SND_THEME="yes"
    ;;
    2)
    SND_THEME="no"
    ;;
  esac
}
### Do You Want Extra System Fonts?                                          ###
################################################################################
function EXTRA_FONTS() {
  clear
  echo "################################################################################"
  echo "### Do You Want To Install Extra System Fonts Installed?                     ###"
  echo "### 1)  Yes                                                                  ###"
  echo "### 2)  No                                                                   ###"
  echo "################################################################################"
  read case;

  case $case in
    1)
    EXT_FONTS="yes"
    ;;
    2)
    E_FONTS="no"
    ;;
  esac
}


################################################################################
### Installing Things                                                        ###
################################################################################
### AUR Helper Installation                                                  ###
################################################################################
function AUR_SELECTION() {
  if [ ${ZB} = "yay" ]; then
    dialog --infobox "Installing The AUR Helper YAY." 3 34
    sleep 2
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm --needed
    cd ..
    rm yay -R -f
  fi
  if [ ${ZB} = "paru" ]; then
    dialog --infobox "Installing The AUR Helper Paru." 3 35
    sleep 2
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm --needed
    cd ..
    rm paru -R -f
    sudo sed -i 's/#BottomUp/BottomUp/' /etc/paru.conf
  fi
}
### Samba Shares Installation                                                ###
################################################################################
function SAMBA_INSTALL() {
  clear
  dialog --infobox "Setting Up The Samba Shares." 3 32
  sleep 2
  sudo pacman -S --noconfirm --needed samba gvfs-smb avahi nss-mdns
  sudo wget "https://git.samba.org/samba.git/?p=samba.git;a=blob_plain;f=examples/smb.conf.default;hb=HEAD" -O /etc/samba/smb.conf
  sudo sed -i -r 's/MYGROUP/WORKGROUP/' /etc/samba/smb.conf
  sudo sed -i -r "s/Samba Server/$HOSTNAME/" /etc/samba/smb.conf
  sudo systemctl enable smb.service
  sudo systemctl start smb.service
  sudo systemctl enable nmb.service
  sudo systemctl start nmb.service
  #Change your username here
  #sudo smbpasswd -a $(whoami)
  #Access samba share windows
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
### Fix the Unicode Issue With Intel And AMD CPUs                            ###
################################################################################
function UNICODEFIX() {
  clear
  dialog --infobox "Fixing The Unicode Processors." 3 34
  sleep 2
  sudo pacman -S --noconfirm --needed  intel-ucode amd-ucode
}
### Needed Software                                                          ###
################################################################################
function NEEDED_SOFTWARE() {
  clear
  dialog --infobox "Adding Some Needed Software." 3 32
  sleep 2
  $ZB -S --noconfirm --needed tuned duf fontpreview-ueberzug-git ytfzf cpufetch buttermanager
}
### Setting Up Sound                                                         ###
################################################################################
function SOUNDSETUP() {
  clear
  dialog --infobox "Installing Sound Files." 3 27
  sleep 2
  sudo pacman -S --noconfirm --needed pulseaudio pulseaudio-alsa pavucontrol alsa-utils alsa-plugins alsa-lib alsa-firmware lib32-alsa-lib lib32-alsa-oss lib32-alsa-plugins gstreamer gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly volumeicon playerctl
}
### Setting Up Bluetooth                                                     ###
################################################################################
function BLUETOOTHSETUP() {
  clear
  dialog --infobox "Installing Bluetooth Files." 3 31
  sleep 2
  sudo pacman -S --noconfirm --needed pulseaudio-bluetooth bluez bluez-libs bluez-utils bluez-plugins blueberry bluez-tools bluez-cups
  sudo systemctl enable bluetooth.service
  sudo systemctl start bluetooth.service
  sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf
}
### Setup Printing                                                           ###
################################################################################
function PRINTERSETUP() {
  clear
  dialog --infobox "Installing Printer Support." 3 31
  sleep 2
  sudo pacman -S --noconfirm --needed cups cups-pdf ghostscript gsfonts gutenprint gtk3-print-backends libcups system-config-printer foomatic-db foomatic-db-ppds foomatic-db-gutenprint-ppds foomatic-db-engine foomatic-db-nonfree foomatic-db-nonfree-ppds
  if [ ${HP_PRINT} = "yes" ]; then
    sudo pacman -S --noconfirm --needed hplip
  fi
  if [ ${EP_PRINT} = "yes" ]; then
    $ZB -S --noconfirm --needed epson-inkjet-printer-escpr
  fi
  sudo systemctl enable cups.service
}
### Installing the Display Manager                                           ###
################################################################################
function XORG_DISPLAY() {
  clear
  dialog --infobox "Installing XORG Display Manager." 3 36
  sleep 2
  sudo pacman -S --noconfirm --needed xorg xorg-drivers xorg-xinit xterm kvantum-qt5 terminator
}
### Install Display Manager                                                  ###
################################################################################
function INSTALL_DM() {
  if [ ${DM} = "lightdm-gtk3" ]; then
    clear
    dialog --infobox "Installing The LightDM GTK3 Login / Display Manager." 3 56
    sleep 2
    sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
    sudo systemctl enable lightdm.service -f
    sudo systemctl set-default graphical.target
  fi
  if [ ${DM} = "lightdm-webkit2" ]; then
    clear
    dialog --infobox "Installing The LightDM WebKit2 Login / Display Manager." 3 59
    sleep 2
    sudo pacman -S --noconfirm --needed lightdm lightdm-webkit-theme-litarvan lightdm-webkit2-greeter
    $ZB -S --noconfirm --needed lightdm-webkit2-theme-material2
    $ZB -S --noconfirm --needed lightdm-webkit-theme-aether
    $ZB -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
    $ZB -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
    $ZB -S --noconfirm --needed lightdm-webkit-theme-contemporary
    $ZB -S --noconfirm --needed lightdm-webkit2-theme-sapphire
    $ZB -S --noconfirm --needed lightdm-webkit2-theme-obsidian
    sudo systemctl enable lightdm.service -f
    sudo systemctl set-default graphical.target
  fi
  if [ ${DM} = "sddm" ]; then
    clear
    dialog --infobox "Installing The SDDM Login / Display Manager." 3 48
    sleep 2
    sudo pacman -S --noconfirm --needed sddm
    sudo systemctl enable sddm
  fi
  if [ ${DM} = "gdm" ]; then
    clear
    dialog --infobox "Installing The GDM Login / Display Manager." 3 47
    sleep 2
    sudo pacman -S --noconfirm --needed gdm
    sudo systemctl enable gdm
  fi
  if [ ${DM} = "entrance" ]; then
    clear
    dialog --infobox "Installing The Entrance Login / Display Manager." 3 52
    sleep 2
    $ZB -S --noconfirm --needed entrance-git
    sudo systemctl enable entrance
  fi
  if [ ${DM} = "ly" ]; then
    clear
    dialog --infobox "Installing The LY Login / Display Manager." 3 46
    sleep 2
    $ZB -S --noconfirm --needed ly
    sudo systemctl enable ly
  fi
}
### Install Desktop Environment Or Window Manager                            ###
################################################################################
function INSTALL_DE() {
  if [ ${DE_TOINST} = "gnome" ]; then
    clear
    dialog --infobox "Installing The Gnome Desktop Environment." 3 45
    sleep 2
    sudo pacman -S --noconfirm --needed gnome gnome-extra nautilus-share variety gnome-packagekit gnome-software-packagekit-plugin
    $ZB -S --noconfirm --needed chrome-gnome-shell
  fi
  if [ ${DE_TOINST} = "plasma" ]; then
    clear
    dialog --infobox "Installing The KDE Plasma Desktop Environment." 3 50
    sleep 2
    sudo pacman -S --noconfirm --needed plasma kde-applications gnome-disk-utility redshift packagekit-qt5
  fi
  if [ ${DE_TOINST} = "xfce4" ]; then
    clear
    dialog --infobox "Installing The XFCE4 Desktop Environment." 3 45
    sleep 2
    sudo pacman -S --noconfirm --needed xfce4 xfce4-goodies gnome-disk-utility ark file-roller unrar p7zip alacarte gnome-calculator picom variety libnma networkmanager networkmanager-openconnect networkmanager-openvpn networkmanager-pptp nm-connection-editor network-manager-applet onboard
    $ZB -S --noconfirm --needed xfce4-screensaver xfce4-panel-profiles-git mugshot solarized-dark-themes gtk-theme-glossyblack mcos-mjv-xfce-edition xfce4-theme-switcher xts-windows10-theme xts-macos-theme xts-dark-theme xts-arcolinux-theme xts-windowsxp-theme xts-windows-server-2003-theme
    wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
    sudo rm /etc/xdg/picom.conf
    sudo mv picom.conf /etc/xdg/picom.conf
  fi
  if [ ${DE_TOINST} = "deepin" ]; then
    clear
    dialog --infobox "Installing The Deepin Desktop Environment." 3 46
    sleep 2
    sudo pacman -S --noconfirm --needed deepin deepin-extra gnome-disk-utility ark file-roller unrar p7zip onboard deepin-kwin deepin-polkit-agent deepin-polkit-agent-ext-gnomekeyring packagekit-qt5
  fi
  if [ ${DE_TOINST} = "mate" ]; then
    clear
    dialog --infobox "Installing The Mate Desktop Environment." 3 44
    sleep 2
    sudo pacman -S --noconfirm --needed mate mate-extra gnome-disk-utility variety onboard ark file-roller unrar p7zip
    $ZB -S --noconfirm --needed mate-tweak brisk-menu mate-screensaver-hacks mugshot
  fi
  if [ ${DE_TOINST} = "budgie" ]; then
    clear
    dialog --infobox "Installing The Budgie Desktop Environment." 3 46
    sleep 2
    sudo pacman -S --noconfirm --needed budgie-desktop budgie-extras gnome-system-monitor nautilus gnome-disk-utility gnome-control-center gnome-backgrounds gnome-calculator gedit variety onboard ark file-roller unrar p7zip gnome-tweaks
  fi
  if [ ${DE_TOINST} = "cinnamon" ]; then
    clear
    dialog --infobox "Installing The Cinnamon Desktop Environment." 3 48
    sleep 2
    sudo pacman -S --noconfirm --needed cinnamon gnome-disk-utility gnome-system-monitor gnome-calculator gpicview gedit variety onboard ark file-roller unrar p7zip
    $ZB -S --noconfirm --needed mint-themes cinnamon-sound-effects
  fi
  if [ ${DE_TOINST} = "lxde" ]; then
    clear
    dialog --infobox "Installing The LXDE Desktop Environment." 3 44
    sleep 2
    sudo pacman -S --noconfirm --needed lxde gnome-disk-utility gnome-calculator gedit picom variety onboard ark file-roller unrar p7zip
    $ZB -S --noconfirm --needed mugshot
    wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
    sudo rm /etc/xdg/picom.conf
    sudo mv picom.conf /etc/xdg/picom.conf
  fi
  if [ ${DE_TOINST} = "lxqt" ]; then
    clear
    dialog --infobox "Installing The LXQT Desktop Environment." 3 44
    sleep 2
    sudo pacman -S --noconfirm --needed lxqt gnome-disk-utility picom gnome-calculator gedit variety onboard ark file-roller unrar p7zip packagekit-qt5
    wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/picom.conf
    sudo rm /etc/xdg/picom.conf
    sudo mv picom.conf /etc/xdg/picom.conf
  fi
  if [ ${DE_TOINST} = "i3" ]; then
    clear
    dialog --infobox "Installing The i3 Window Manager." 3 37
    sleep 2
    sudo pacman -S --noconfirm --needed i3 gnome-disk-utility onboard ark file-roller unrar p7zip picom dmenu rofi nitrogen feh thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman xfce4-terminal xfce4-screenshooter papirus-icon-theme network-manager-applet arandr scrot lxappearance polkit-gnome galculator dunst
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
    mkdir -p ~/.config/dunst
    cp /etc/dunst/dunstrc ~/.config/dunst/
    echo "alias conf='nano ~/.config/i3/config'" >> ~/.bashrc
    echo "alias conf-bar='nano ~/.config/i3/i3status-config'" >> ~/.bashrc
  fi
  if [ ${DE_TOINST} = "sway" ]; then
    clear
    dialog --infobox "Installing The Sway Window Manager." 3 39
    sleep 2
    sudo pacman -S --noconfirm --needed sway swaybg swayidle swaylock waybar dmenu rofi nitrogen onboard ark file-roller unrar p7zip xfce4-terminal thunar thunar-archive-plugin thunar-media-tags-plugin network-manager-applet xfce4-screenshooter papirus-icon-theme arandr gnome-disk-utility polkit-gnome grim feh eog galculator
    $ZB -S --noconfirm --needed mugshot
    #$ZB -S --noconfirm --needed j4-dmenu-desktop
    mkdir -p ~/.config/sway
    cd ~/.config/sway
    wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/config-sway
    cp config-sway config
    cd ~
    echo "alias conf='nano ~/.config/sway/config'" >> ~/.bashrc
    mkdir -p ~/.config/waybar
    cp /etc/xdg/waybar/* ~/.config/waybar/
    mkdir -p ~/Pictures/shots
  fi
  if [ ${DE_TOINST} = "bspwm" ]; then
    clear
    dialog --infobox "Installing The BSPWM Window Manager." 3 40
    sleep 2
    sudo pacman -S --noconfirm --needed bspwm sxhkd dmenu rofi nitrogen picom xfce4-terminal thunar thunar-archive-plugin thunar-media-tags-plugin xfce4-screenshooter onboard ark file-roller unrar p7zip arandr network-manager-applet gnome-disk-utility feh eog lxappearance galculator dunst
    $ZB -S --noconfirm --needed pnmixer mugshot polybar
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
    mkdir -p ~/.config/dunst
    cp /etc/dunst/dunstrc ~/.config/dunst/
    echo "alias conf='nano ~/.config/bspwm/bspwmrc'" >> ~/.bashrc
    echo "alias conf-key='nano ~/.config/sxhkd/sxhkdrc'" >> ~/.bashrc
    echo "alias conf-bar='nano ~/.config/polybar/config'" >> ~/.bashrc
  fi
}
### Check What Video Card Installed                                          ###
################################################################################
function VC_INSTALL() {
  if [[ $(lspci -k | grep VGA | grep -i nvidia) ]]; then
    clear
    dialog --infobox "Installing nVidia Video Drivers." 3 36
    sleep 2
    sudo pacman -S --noconfirm --needed nvidia nvidia-cg-toolkit nvidia-settings nvidia-utils lib32-nvidia-cg-toolkit lib32-nvidia-utils lib32-opencl-nvidia opencl-nvidia cuda ffnvcodec-headers lib32-libvdpau libxnvctrl pycuda-headers python-pycuda
    sudo pacman -R --noconfirm xf86-video-nouveau
  fi

  if [[ $(lspci -k | grep VGA | grep -i amd) ]]; then
    clear
    dialog --infobox "Installing AMD Video Drivers." 3 33
    sleep 2
    #$ZB -S --noconfirm --needed amdgpu-pro-libgl
    #$ZB -S --noconfirm --needed lib32-amdgpu-pro-libgl
    #$ZB -S --noconfirm --needed amdvlk
    #$ZB -S --noconfirm --needed lib32-amdvlk
    $ZB -S --noconfirm --needed opencl-amd
    dialog --infobox "Thanks for supporting a free and open vendor." 3 49
    sleep 2
  fi
}
### Install Sound Themes                                                     ###
################################################################################
function INSTALL_SOUNDTHEME() {
  clear
  dialog --infobox "Installing Some Sound Themes." 3 33
  sleep 2
  sudo pacman -S --noconfirm --needed deepin-sound-theme
  $ZB -S --noconfirm --needed sound-theme-smooth sound-theme-elementary-git
}
### Install Extra Fonts                                                      ###
################################################################################
function INSTALL_EXTRAFONTS() {
  clear
  dialog --infobox "Installing Some Extra System Fonts." 3 39
  sleep 2
  sudo pacman -S --noconfirm --needed adobe-source-sans-pro-fonts cantarell-fonts noto-fonts terminus-font ttf-bitstream-vera ttf-dejavu ttf-droid ttf-inconsolata ttf-liberation ttf-roboto ttf-ubuntu-font-family tamsyn-font awesome-terminal-fonts ttf-font-awesome ttf-hack ttf-ibm-plex
  $ZB -S --noconfirm --needed ttf-ms-fonts steam-fonts ttf-mac-fonts siji-git ttf-font-awesome
}

################################################################################
### Setup Things - Needed For Installing Software                            ###
################################################################################
### Fix the Pacman Keyring                                                   ###
################################################################################
function PACMAN_KEYS() {
  clear
  dialog --infobox "Fixing The Pacman (Repos) Keys." 3 35
  sleep 2
  sudo pacman-key --init
  sudo pacman-key --populate archlinux
  sudo reflector --country US --latest 20 --sort rate --verbose --save /etc/pacman.d/mirrorlist
  sudo pacman -Syyu
}

################################################################################
### Main Program                                                             ###
################################################################################
clear
### Questions                                                                ###
################################################################################
AUR_HELPER
SAMBA_SHARES
PRINTER_SUPPORT
BLUETOOTH_SUPPORT
DISPLAY_MANAGER
WHAT_DE
SOUNDTHEME_SUPPORT
EXTRA_FONTS

###                                                                          ###
################################################################################
PACMAN_KEYS
AUR_SELECTION
if [ ${SAMBA_SH} = "yes" ]; then
  SAMBA_INSTALL
fi
UNICODEFIX
NEEDED_SOFTWARE
SOUNDSETUP
if [ ${BT_SUPPORT} = "yes" ]; then
  BLUETOOTHSETUP
fi
if [ ${PSUPPORT} = "yes" ]; then
  PRINTERSETUP
fi
XORG_DISPLAY
INSTALL_DM
INSTALL_DE
VC_INSTALL
if [ ${SND_THEME} = "yes" ]; then
  INSTALL_SOUNDTHEME
fi
if [ ${EXT_FONTS} = "yes" ]; then
  INSTALL_EXTRAFONTS
fi
