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

################################################################################
### Installing Things                                                        ###
################################################################################
### AUR Helper Installation                                                  ###
################################################################################
function AUR_SELECTION() {
  if [ ${ZB} = "yay" ]; then
    dialog --infobox "Installing The AUR Helper YAY." 10 50
    sleep 2
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm --needed
    cd ..
    rm yay -R -f
  fi
  if [ ${ZB} = "paru" ]; then
    dialog --infobox "Installing The AUR Helper Paru." 10 50
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
  dialog --infobox "Setting Up The Samba Shares." 10 50
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
  dialog --infobox "Fixing The Unicode Processors." 10 50
  sleep 2
  sudo pacman -S --noconfirm --needed  intel-ucode amd-ucode
}
### Needed Software                                                          ###
################################################################################
function NEEDED_SOFTWARE() {
  clear
  echo "################################################################################"
  echo "### Installing Needed Applications                                           ###"
  echo "################################################################################"
  sleep 2
  $ZB -S --noconfirm --needed tuned duf fontpreview-ueberzug-git ytfzf cpufetch buttermanager
}

################################################################################
### Setup Things - Needed For Installing Software                            ###
################################################################################
### Fix the Pacman Keyring                                                   ###
################################################################################
function PACMAN_KEYS() {
  clear
  dialog --infobox "Fixing The Pacman (Repos) Keys" 10 50
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

###                                                                          ###
################################################################################
PACMAN_KEYS
AUR_SELECTION
SAMBA_INSTALL
UNICODEFIX
NEEDED_SOFTWARE
