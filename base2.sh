#!/bin/bash
################################################################################
### Installing Base Arch Linux By:                                           ###
### Erik Sundquist                                                           ###
################################################################################
### Review and edit before using                                             ###
################################################################################
set -e

################################################################################
### Ask all the questions                                                    ###
################################################################################
### Set Your Hostname (Name Of Your Computer) Here
################################################################################
function HOSTNAME() {
  clear
  HOSTNM=$(dialog --stdout --inputbox "Enter hostname" 10 20) || exit 1
  : ${HOSTNM:?"hostname cannot be empty"}
}
### Select Hard Drive To Partition/Format Here
################################################################################
function DRVSELECT() {
  clear
  DEVICELIST=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
  HD=$(dialog --stdout --menu "Select root disk" 0 0 0 ${DEVICELIST}) || exit 1
}
### Set Username And Password Here
################################################################################
function UNAMEPASS() {
  clear
  USRNM=$(dialog --stdout --inputbox "Enter username" 0 0) || exit 1
  clear
  : ${USRNM:?"user cannot be empty"}
  # User password
  UPASSWD=$(dialog --stdout --passwordbox "Enter user password" 0 0) || exit 1
  clear
  : ${UPASSWD:?"password cannot be empty"}
  UPASSWD2=$(dialog --stdout --passwordbox "Enter user password again" 0 0) || exit 1
  clear
  [[ "$UPASSWD" == "$UPASSWD2" ]] || ( echo "Passwords did not match"; exit 1; )
}
### Set Admin (Root) Password Here
################################################################################
function ROOTPASSWORD() {
  clear
  RPASSWD=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
  clear
  : ${RPASSWD:?"password cannot be empty"}
  RPASSWD2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
  clear
  [[ "$RPASSWD" == "$RPASSWD2" ]] || ( echo "Passwords did not match"; exit 1; )
}
### Ask which bootloader
################################################################################
function BOOTTYPE() {
  clear
  echo "##############################################################################"
  echo "### What is your preferred boot loader                                     ###"
  echo "### 1)  systemd                                                            ###"
  echo "### 2)  GRUB (Must select this if using non-EFI system)                    ###"
  echo "##############################################################################"
  read case;
  case $case in
    1)
    BOOT_TYPE="systemd"
    ;;
    2)
    BOOT_TYPE="grub"
    ;;
  esac
}
### Ask what format for the HD
################################################################################
function WHATFMT() {
  clear
  echo "##############################################################################"
  echo "### What is your preferred drive format                                    ###"
  echo "### 1)  EXT4 - Standard Linux Format                                       ###"
  echo "### 2)  BTRFS                                                              ###"
  echo "### 3)  XFS                                                                ###"
  echo "### 4)  ReiserFS                                                           ###"
  echo "### 5)  JFS                                                                ###"
  echo "### 6)  NILFS2                                                             ###"
  echo "##############################################################################"
  read case;
  case $case in
    1)
    DRV_FMT="ext4"
    ;;
    2)
    DRV_FMT="btrfs"
    ;;
    3)
    DRV_FMT="xfs"
    ;;
    4)
    DRV_FMT="reiserfs"
    ;;
    5)
    DRV_FMT="jfs"
    ;;
    6)
    DRV_FMT="nilfs2"
    ;;
  esac
}

################################################################################
### Set Enviroment Variables                                                 ###
################################################################################
### Set Your System Locale Here
################################################################################
function LOCALE() {
  ALOCALE="en_US.UTF-8"
}
### Set Your Country
################################################################################
function COUNTRY() {
  CNTRY="US"
}
### Set Your Keyboard Map Here
################################################################################
function KEYMAP() {
  AKEYMAP="us"
}
### Set Your Command Line Font (Shell) Here
################################################################################
function CLIFONT() {
  clear
  pacstrap /mnt terminus-font
  DEFFNT="ter-120n"
}
### Set Your Timezone Here
################################################################################
function STIMEZONE() {
  TIMEZNE='America/Los_Angeles'
}

################################################################################
### Needed utilities to install system                                       ###
################################################################################
function NEEDED_INSTALL() {
  clear
  echo "##############################################################################"
  echo "### Installing needed software                                             ###"
  echo "##############################################################################"
  sleep 3
  pacman -S --noconfirm --needed dialog
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
  sudo pacman -Sy
}

################################################################################
### Partition And Format The Hard Drive Here                                 ###
################################################################################
function PARTHD() {
  clear
  echo "##############################################################################"
  echo "### Partitioning the Hard Drive                                            ###"
  echo "##############################################################################"
  sleep 3
  sgdisk -Z ${HD}
  if [[ -d /sys/firmware/efi/efivars ]]; then
    #UEFI Partition
    parted ${HD} mklabel gpt mkpart primary fat32 1MiB 301MiB set 1 esp on mkpart primary ext4 301MiB 100%
    mkfs.fat -F32 ${HD}1
  else
    #BIOS Partition
    parted ${HD} mklabel msdos mkpart primary ext4 2MiB 100% set 1 boot on
  fi
}
### Check What Format For Drive
################################################################################
function CHK_FMT() {
  if [[ DRV_FMT = "ext4" ]]; then
    clear
    echo "##############################################################################"
    echo "### Formatting the Hard Drive as EXT4                                      ###"
    echo "##############################################################################"
    sleep 3
    if [[ -d /sys/firmware/efi/efivars ]]; then
      #UEFI Partition
      mkfs.fat -F32 ${HD}1
      mkfs.ext4 ${HD}2
    else
      #BIOS Partition
      mkfs.ext4 ${HD}1
    fi
  fi
  if [[ DRV_FMT = "btrfs" ]]; then
    FMTBTRFS
  fi
}
### Format The Hard Drive With EXT4 Filesystem Here
################################################################################
function FMTEXT4() {
  clear
  echo "##############################################################################"
  echo "### Formatting the Hard Drive as EXT4                                      ###"
  echo "##############################################################################"
  sleep 3
  if [[ -d /sys/firmware/efi/efivars ]]; then
    #UEFI Partition
    mkfs.fat -F32 ${HD}1
    mkfs.ext4 ${HD}2
  else
    #BIOS Partition
    mkfs.ext4 ${HD}1
  fi
}
### Format The Hard Drive With BTRFS Filesystem Here
################################################################################
function FMTBTRFS() {
  clear
  echo "##############################################################################"
  echo "### Formatting the Hard Drive as BTRFS                                     ###"
  echo "##############################################################################"
  sleep 3
  if [[ -d /sys/firmware/efi/efivars ]]; then
    #UEFI Partition
    mkfs.fat -F32 ${HD}1
    mkfs.btrfs -f ${HD}2
  else
    #BIOS Partition
    mkfs.btrfs ${HD}1
  fi
}
### Format The Hard Drive With XFS Filesystem Here
################################################################################
function FMTXFS() {
  clear
  echo "##############################################################################"
  echo "### Formatting the Hard Drive as XFS                                       ###"
  echo "##############################################################################"
  sleep 3
  if [[ -d /sys/firmware/efi/efivars ]]; then
    #UEFI Partition
    mkfs.fat -F32 ${HD}1
    mkfs.xfs -f ${HD}2
  else
    #BIOS Partition
    mkfs.xfs -f ${HD}1
  fi
}
### Format The Hard Drive With ReiserFS Filesystem Here
################################################################################
function FMTREISERFS() {
  clear
  echo "##############################################################################"
  echo "### Formatting the Hard Drive as ReiserFS                                  ###"
  echo "##############################################################################"
  sleep 3
  if [[ -d /sys/firmware/efi/efivars ]]; then
    #UEFI Partition
    mkfs.fat -F32 ${HD}1
    mkfs.reiserfs -f ${HD}2
  else
    #BIOS Partition
    mkfs.reiserfs -f ${HD}1
  fi
}
### Format The Hard Drive With JFS Filesystem Here
################################################################################
function FMTJFS() {
  clear
  echo "##############################################################################"
  echo "### Formatting the Hard Drive as JFS                                       ###"
  echo "##############################################################################"
  sleep 3
  if [[ -d /sys/firmware/efi/efivars ]]; then
    #UEFI Partition
    mkfs.fat -F32 ${HD}1
    mkfs.jfs -f ${HD}2
  else
    #BIOS Partition
    mkfs.jfs -f ${HD}1
  fi
}
### Format The Hard Drive With NILFS2 Filesystem Here
################################################################################
function FMTNILFS2() {
  clear
  echo "##############################################################################"
  echo "### Formatting the Hard Drive as NILFS2                                    ###"
  echo "##############################################################################"
  sleep 3
  if [[ -d /sys/firmware/efi/efivars ]]; then
    #UEFI Partition
    mkfs.fat -F32 ${HD}1
    mkfs.nilfs2 -f ${HD}2
  else
    #BIOS Partition
    mkfs.nilfs2 -f ${HD}1
  fi
}
### Mount The Hard Drive Here
################################################################################
function MNTHD() {
  if [[ -d /sys/firmware/efi/efivars ]]; then
    #UEFI Partition
    mount ${HD}2 /mnt
    mkdir /mnt/boot
    mount ${HD}1 /mnt/boot
  else
    mount ${HD}1 /mnt
  fi
}

################################################################################
### Main Program - Edit At Own Risk                                          ###
################################################################################
clear
### Getting Things Ready
################################################################################
timedatectl set-ntp true
NEEDED_INSTALL
PACMAN_KEYS
### User Setting Enviroment Variables
################################################################################
COUNTRY
LOCALE
KEYMAP
STIMEZONE
HOSTNAME
UNAMEPASS
ROOTPASSWORD
DRVSELECT
WHATFMT
BOOTTYPE
### Getting Started
################################################################################
PARTHD
CHK_FMT
