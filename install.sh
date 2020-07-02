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

timedatectl set-ntp true
TIMEZONES
CNTRY
HSTNAME
PACSET


function PACSET() {
  pacman -Sy
  pacman -S --noconfirm --needed reflector
  reflector --country $CNTY --age 24 --sort rate --save /etc/pacman.d/mirrorlist
  pacman -Sy
}

function TIMEZONES() {
  ALOCALE="en_US.UTF-8"
  TIMEZNE='America/Los_Angeles'
}

function CNTRY() {
  CNTY="US"
  AKEYMAP="us"
}

function HSTNAME() {
  HOSTNAME=$(dialog --stdout --inputbox "Enter hostname" 10 20) || exit 1
  : ${HOSTNAME:?"hostname cannot be empty"}
}

function DRVTOUSE() {
  DEVICELIST=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
  DRIVE=$(dialog --stdout --menu "Select root disk" 0 0 0 ${DEVICELIST}) || exit 1
}
function DFONT() {
  DEFFNT=$(dialog --stdout --title "Select your terminal (CLI) font" --fselect /usr/share/kbd/consolefonts/ 24 48)
}

function USR() {
  USER=$(dialog --stdout --inputbox "Enter username" 0 0) || exit 1
  clear
  : ${USER:?"user cannot be empty"}
  PASSWORD=$(dialog --stdout --passwordbox "Enter user password" 0 0) || exit 1
  clear
  : ${PASSWORD:?"password cannot be empty"}
  PASSWORD2=$(dialog --stdout --passwordbox "Enter user password again" 0 0) || exit 1
  clear
  [[ "$PASSWORD" == "$PASSWORD2" ]] || ( echo "Passwords did not match"; exit 1; )
}

function ADMN() {
  PASSWORDROOT=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
  clear
  : ${PASSWORDROOT:?"password cannot be empty"}
  PASSWORDROOT2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
  clear
  [[ "$PASSWORDROOT" == "$PASSWORDROOT2" ]] || ( echo "Passwords did not match"; exit 1; )
}
