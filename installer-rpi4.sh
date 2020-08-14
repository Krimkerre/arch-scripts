#!/bin/bash
################################################################################
### Installing Arch Linux By:                                                ###
### Erik Sundquist                                                           ###
################################################################################
### Review and edit before using                                             ###
################################################################################
set -e
################################################################################
### Set Your Hostname (Name Of Your Computer) Here                           ###
################################################################################
function HOSTNAME() {
  HOSTNM=$(dialog --stdout --inputbox "Enter hostname" 10 20) || exit 1
  : ${HOSTNM:?"hostname cannot be empty"}
}
################################################################################
### Select Hard Drive To Partition/Format Here                               ###
################################################################################
function DRVSELECT() {
  DEVICELIST=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
  HD=$(dialog --stdout --menu "Select root disk" 0 0 0 ${DEVICELIST}) || exit 1
}
################################################################################
### Set Your Command Line Font (Shell) Here                                  ###
################################################################################
function CLIFONT() {
  DEFFNT=$(dialog --stdout --title "Select your terminal (CLI) font" --fselect /mnt/root/usr/share/kbd/consolefonts/ 24 48)
}
################################################################################
### Partition And Format The Hard Drive Here                                 ###
################################################################################
function PARTHD() {
  sgdisk -Z ${HD}
  parted ${HD} mklabel msdos mkpart primary fat32 1MiB 301MiB set 1 boot on mkpart primary ext4 301MiB 100%
  #parted ${HD} mklabel msdos mkpart primary ext4 2MiB 100% set 1 boot on
}
################################################################################
### Format The Hard Drive With EXT4 Filesystem Here                          ###
################################################################################
function FMTEXT4() {
    mkfs.vfat ${HD}1
    mkfs.ext4 ${HD}2
}
################################################################################
### Format The Hard Drive With BTRFS Filesystem Here                         ###
################################################################################
function FMTBTRFS() {
    mkfs.vfat ${HD}1
    mkfs.btrfs -f ${HD}2
}
################################################################################
### Format The Hard Drive With XFS Filesystem Here                           ###
################################################################################
function FMTXFS() {
    mkfs.vfat ${HD}1
    mkfs.xfs -f ${HD}2
}
################################################################################
### Format The Hard Drive With ReiserFS Filesystem Here                       ###
################################################################################
function FMTREISERFS() {
    mkfs.vfat ${HD}1
    mkfs.reiserfs -f ${HD}2
}
################################################################################
### Format The Hard Drive With JFS Filesystem Here                       ###
################################################################################
function FMTJFS() {
    mkfs.vfat ${HD}1
    mkfs.jfs -f ${HD}2
}
################################################################################
### Format The Hard Drive With NILFS2 Filesystem Here                       ###
################################################################################
function FMTNILFS2() {
    mkfs.vfat ${HD}1
    mkfs.nilfs2 -f ${HD}2
}
################################################################################
### Mount The Hard Drive Here                                                ###
################################################################################
function MNTHD() {
    mkdir /mnt/boot
    mkdir /mnt/root
    mount ${HD}1 /mnt/boot
    mount ${HD}2 /mnt/root
}
function WHATFMT() {
  clear
  echo "##############################################################################"
  echo "What is your preferred drive format"
  echo "1)  EXT4 - Standard Linux Format"
  echo "2)  BTRFS"
  echo "3)  XFS"
  echo "4)  ReiserFS"
  echo "5)  JFS"
  echo "6)  NILFS2"
  echo "##############################################################################"
  read case;
  case $case in
    1)
    FMTEXT4
    ;;
    2)
    FMTBTRFS
    ;;
    3)
    FMTXFS
    ;;
    4)
    FMTREISERFS
    ;;
    5)
    FMTJFS
    ;;
    6)
    FMTNILFS2
    ;;
  esac
}
################################################################################
### Set Your Keyboard Map Here                                               ###
################################################################################
function KEYMAP() {
  AKEYMAP="us"
}
################################################################################
### Main Program - Edit At Own Risk                                          ###
################################################################################
clear
KEYMAP
HOSTNAME
DRVSELECT
clear
#PARTHD
WHATFMT
MNTHD
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-4-latest.tar.gz
clear
echo "Installing OS, Please Wait....."
bsdtar -xpf ArchLinuxARM-rpi-4-latest.tar.gz -C /mnt/root
sync
CLIFONT
mv /mnt/root/boot/* /mnt/boot
################################################################################
### Misc Settings                                                            ###
################################################################################
rm /mnt/root/etc/hostname
echo "${HOSTNM}" >> /mnt/root/etc/hostname
echo "KEYMAP="${AKEYMAP} >> /mnt/root/etc/vconsole.conf
echo "FONT="${DEFFNT} >> /mnt/root/etc/vconsole.conf
sed -i 's/'#Color'/'Color'/g' /mnt/root/etc/pacman.conf
sed -i 's/elevator=noop/elevator=noop audit=0/g' /mnt/boot/cmdline.txt
sed -i 's/gpu_mem=64/gpu_mem=256/g' /mnt/boot/config.txt
echo "disable_overscan=1" >> /mnt/boot/config.txt
echo "#arm_freq=2000" >> /mnt/boot/config.txt     # 700Mhz is the default, Change to overclock 2000 is about max
echo "#over_voltage=4" >> /mnt/boot/config.txt
echo "#gpu_freq=600" >> /mnt/boot/config.txt
echo "dtparam=audio=on" >> /mnt/boot/config.txt     # To enable audio
echo "dtoverlay=vc4-fkms-v3d" >> /mnt/boot/config.txt
echo "max_framebuffers=2" >> /mnt/boot/config.txt
cp setup-rpi4.sh /mnt/root/home/alarm/
umount /mnt/boot
umount /mnt/root
rm /mnt/boot -R
rm /mnt/root -R
clear
echo "##############################################################################"
echo "### Installation Is Complete, Please Reboot And Have Fun                   ###"
echo "### To Setup The DE and Other Needed Packages Please Type ./setup.sh       ###"
echo "### After The Reboot                                                       ###"
echo "##############################################################################"
