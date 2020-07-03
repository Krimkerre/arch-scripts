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

function DRVSELECT() {
  DEVICELIST=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
  DRIVE=$(dialog --stdout --menu "Select root disk" 0 0 0 ${DEVICELIST}) || exit 1
}

function FMTDRV() {
  sgdisk -Z ${DRIVE}

  parted ${DRIVE} mklabel gpt mkpart primary fat32 1MiB 301MiB set 1 esp on mkpart primary ext4 301MiB 100%
  mkfs.fat -F32 ${DRIVE}1
  mkfs.ext4 ${DRIVE}2
  #mkfs.btrfs -f ${DRIVE}2
}

function DRVMNT() {
  mount ${DRIVE}2 /mnt
  mkdir /mnt/boot
  mount ${DRIVE}1 /mnt/boot
}

function BASEPKG() {
  pacstrap /mnt base base-devel linux linux-firmware linux-headers nano networkmanager
  genfstab -U /mnt >> /mnt/etc/fstab
}

function SYSD_BOOT() {
  arch-chroot /mnt mkdir -p /boot/loader/entries
  arch-chroot /mnt bootctl --path=/boot install
  rm /mnt/boot/loader/loader.conf
  echo "default arch" >> /mnt/boot/loader/loader.conf
  echo "timeout 3" >> /mnt/boot/loader/loader.conf
  echo "console-mode max" >> /mnt/boot/loader/loader.conf
  echo "editor no" >> /mnt/boot/loader/loader.conf

  echo "title Arch Linux" >> /mnt/boot/loader/entries/arch.conf
  echo "linux /vmlinuz-linux" >> /mnt/boot/loader/entries/arch.conf
  echo "#initrd  /intel-ucode.img" >> /mnt/boot/loader/entries/arch.conf
  echo "#initrd /amd-ucode.img" >> /mnt/boot/loader/entries/arch.conf
  echo "initrd  /initramfs-linux.img" >> /mnt/boot/loader/entries/arch.conf
  DRVINFO=
  echo "options root=PARTUUID="$(blkid -s PARTUUID -o value "$DRIVE"2)" nowatchdog rw" >> /mnt/boot/loader/entries/arch.conf

}

################################################################################
### Main program                                                             ###
################################################################################
timedatectl set-ntp true
TIMEZONES
CNTRY
HSTNAME
clear
PACSET
DRVSELECT
clear
FMTDRV
DRVMNT
BASEPKG
SYSD_BOOT
