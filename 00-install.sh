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

################### Variables - will change to menus later ###########################
# Change to the correct language file
alocale='en_US.UTF-8'
# Change to the country
akeymap='us'
# Change to the namme you want the machine
ahostname='arch'
# Change to the device wanting to format
drive='/dev/vda'
# Change to the default terminal font
deffnt='gr928-8x16-thin'
######################################################################################

##### Partition the drive ############################################################
sgdisk -Z ${drive}
#UEFI Partition
parted ${drive} mklabel gpt mkpart primary fat32 1MiB 301MiB set 1 esp on mkpart primary ext4 301MiB 100%
mkfs.fat -F32 ${drive}1
mkfs.ext4 ${drive}2
#BIOS Partition
#parted ${drive} mklabel msdos mkpart primary ext4 2MiB 100% set 1 boot on
#mkfs.ext4 ${drive}1
mount ${drive}2 /mnt
mkdir /mnt/boot
mount ${drive}1 /mnt/boot
######################################################################################

##### Install base packages ##########################################################
pacstrap /mnt base base-devel linux linux-firmware nano networkmanager grub efibootmgr
######################################################################################


echo "################################################################################"
echo "### Install of Arch Completed                                                ###"
echo "################################################################################"
sleep 2
