#!/bin/bash

###############################################################################
### Installing Arch Linux By:                                               ###
### Erik Sundquist                                                          ###
###############################################################################
### Review and edit before using                                            ###
###############################################################################
set -e

################################################################################
### Initial Pacman (Repo) update and Country Selection/Update                ###
################################################################################
function PACSET() {
  pacman -Sy
  pacman -S --noconfirm --needed reflector
  reflector --country $CNTY --age 24 --sort rate --save /etc/pacman.d/mirrorlist
  pacman -Sy
}
################################################################################
### Set Timezone                                                             ###
################################################################################
function TIMEZONES() {
  ALOCALE="en_US.UTF-8"
  TIMEZNE='America/Los_Angeles'
}
################################################################################
### Set Country Codes                                                        ###
################################################################################
function CNTRY() {
  CNTY="US"
  AKEYMAP="us"
}
################################################################################
### Set Hostname for Machine                                                 ###
################################################################################
function HSTNAME() {
  HOSTNAME=$(dialog --stdout --inputbox "Enter hostname" 10 20) || exit 1
  : ${HOSTNAME:?"hostname cannot be empty"}
}
################################################################################
### Set Terminal (CLI) Font                                                  ###
################################################################################
function DFONT() {
  DEFFNT=$(dialog --stdout --title "Select your terminal (CLI) font" --fselect /usr/share/kbd/consolefonts/ 24 48)
}
################################################################################
### Set User Name and Password                                               ###
################################################################################
function USR() {
  LUSER=$(dialog --stdout --inputbox "Enter username" 0 0) || exit 1
  clear
  : ${LUSER:?"user cannot be empty"}
  PASSWORD=$(dialog --stdout --passwordbox "Enter user password" 0 0) || exit 1
  clear
  : ${PASSWORD:?"password cannot be empty"}
  PASSWORD2=$(dialog --stdout --passwordbox "Enter user password again" 0 0) || exit 1
  clear
  [[ "$PASSWORD" == "$PASSWORD2" ]] || ( echo "Passwords did not match"; exit 1; )
}
################################################################################
### Set Root password                                                        ###
################################################################################
function ADMN() {
  PASSWORDROOT=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
  clear
  : ${PASSWORDROOT:?"password cannot be empty"}
  PASSWORDROOT2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
  clear
  [[ "$PASSWORDROOT" == "$PASSWORDROOT2" ]] || ( echo "Passwords did not match"; exit 1; )
}
################################################################################
### Select Drive to Format/Partition                                         ###
################################################################################
function DRVSELECT() {
  DEVICELIST=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
  DRIVE=$(dialog --stdout --menu "Select root disk" 0 0 0 ${DEVICELIST}) || exit 1
}
################################################################################
### Partition and Format The Drives                                          ###
################################################################################
function FMTDRV() {
  sgdisk -Z ${DRIVE}

  if [[ -d /sys/firmware/efi/efivars ]]; then
    #UEFI Partition
    parted ${DRIVE} mklabel gpt mkpart primary fat32 1MiB 301MiB set 1 esp on mkpart primary ext4 301MiB 100%
    mkfs.fat -F32 ${DRIVE}1
    mkfs.ext4 ${DRIVE}2
    #mkfs.btrfs -f ${DRIVE}2
  else
    #BIOS Partition
    parted ${DRIVE} mklabel msdos mkpart primary ext4 2MiB 100% set 1 boot on
    mkfs.ext4 ${DRIVE}1
    #mkfs.btrfs ${DRIVE}1
  fi
}
################################################################################
### Mount the new Partitions                                                 ###
################################################################################
function DRVMNT() {
  if [[ -d /sys/firmware/efi/efivars ]]; then
    #UEFI Partition
    mount ${DRIVE}2 /mnt
    mkdir /mnt/boot
    mount ${DRIVE}1 /mnt/boot
  else
    #BIOS Partition
    mount ${DRIVE}1 /mnt
  fi
}
################################################################################
### Install Base packages                                                    ###
################################################################################
function BASEPKG() {
  pacstrap /mnt base base-devel linux linux-firmware linux-headers nano networkmanager man-db man-pages git btrfs-progs systemd-swap
  genfstab -U /mnt >> /mnt/etc/fstab
}
################################################################################
### Install Systemd Boot loader                                              ###
################################################################################
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
  echo "options root=PARTUUID="$(blkid -s PARTUUID -o value "$DRIVE"2)" nowatchdog rw" >> /mnt/boot/loader/entries/arch.conf
}
################################################################################
### Install GRUB Boot loader                                                 ###
################################################################################
function GRUB_BOOT() {
  if [[ -d /sys/firmware/efi/efivars ]]; then
    pacstrap /mnt grub efibootmgr
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --removable
    arch-chroot /mnt pacman -S --needed --noconfirm grub-customizer
  else
    pacstrap /mnt grub
    arch-chroot /mnt grub-install --target=i386-pc ${DRIVE}
    arch-chroot /mnt pacman -S --needed --noconfirm grub-customizer
  fi
}
################################################################################
### Set up SystemD Swap                                                      ###
################################################################################
function SYSD_SWAP() {
  sed -i 's/'swapfc_enabled=0'/'swapfc_enabled=1'/g' /mnt/etc/systemd/swap.conf
  #arch-chroot /mnt systemctl start systemd-swap
  #arch-chroot /mnt systemctl stop systemd-swap
  sed -i 's/'swapfc_force_preallocated=0'/'swapfc_force_preallocated=1'/g' /mnt/etc/systemd/swap.conf
  #arch-chroot /mnt systemctl start systemd-swap
  arch-chroot /mnt systemctl enable systemd-swap
}
################################################################################
### Set the User and Root Passwords                                          ###
################################################################################
function PASSWRDS() {
  arch-chroot /mnt useradd -m -g users -G storage,wheel,power,kvm -s /bin/bash "${LUSER}"
  echo "$PASSWORD
  $PASSWORD
  " | arch-chroot /mnt passwd $LUSER

  echo "$PASSWORDROOT
  $PASSWORDROOT" | arch-chroot /mnt passwd
}
################################################################################
### Setting up Misc Stuff                                                    ###
################################################################################
function MISC() {
  arch-chroot /mnt systemctl enable NetworkManager
  ln -sf /run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf
  arch-chroot /mnt systemctl enable systemd-resolved
  sed -i "s/^#\(${ALOCALE}\)/\1/" /mnt/etc/locale.gen
  arch-chroot /mnt locale-gen
  echo "LANG=${ALOCALE}" > /mnt/etc/locale.conf
  echo "${HOSTNAME}" > /mnt/etc/hostname
  sed -i 's/^#\ \(%wheel\ ALL=(ALL)\ NOPASSWD:\ ALL\)/\1/' /mnt/etc/sudoers
  echo "KEYMAP="${AKEYMAP} > /mnt/etc/vconsole.conf
  #sed -i "$ a FONT=${DEFFNT}" /mnt/etc/vconsole.conf
  echo "FONT="${DEFFNT} > /mnt/etc/vconsole.conf
  arch-chroot /mnt ln -sf /usr/share/zoneinfo/${TIMEZNE} /etc/localtime
  sed -i 's/'#Color'/'Color'/g' /mnt/etc/pacman.conf
  #sed -i 's/\#Include/Include'/g /mnt/etc/pacman.conf
  sed -i '/^#\[multilib\]/{
    N
    s/^#\(\[multilib\]\n\)#\(Include\ .\+\)/\1\2/
  }' /mnt/etc/pacman.conf
  sed -i 's/\#\[multilib\]/\[multilib\]'/g /mnt/etc/pacman.conf
}
################################################################################
### Main program                                                             ###
################################################################################
clear
timedatectl set-ntp true
TIMEZONES
CNTRY
HSTNAME
USR
ADMN
clear
PACSET
DRVSELECT
clear
FMTDRV
DRVMNT
BASEPKG
SYSD_BOOT
SYSD_SWAP
PASSWRDS
MISC
