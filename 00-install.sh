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
cntry='US'
akeymap='us'
# Change to the name you want the machine
hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0) || exit 1
clear
: ${hostname:?"hostname cannot be empty"}
# Change to the device wanting to format
devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
drive=$(dialog --stdout --menu "Select root disk" 0 0 0 ${devicelist}) || exit 1
#drive='/dev/vda'
# Change to the default terminal font
deffnt='gr928-8x16-thin'
# Change the timezones
timezne='America/Los_Angeles'
# Add username
user=$(dialog --stdout --inputbox "Enter username" 0 0) || exit 1
clear
: ${user:?"user cannot be empty"}
# User password
password=$(dialog --stdout --passwordbox "Enter user password" 0 0) || exit 1
clear
: ${password:?"password cannot be empty"}
password2=$(dialog --stdout --passwordbox "Enter user password again" 0 0) || exit 1
clear
[[ "$password" == "$password2" ]] || ( echo "Passwords did not match"; exit 1; )
# Admin password
passwordroot=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
clear
: ${passwordroot:?"password cannot be empty"}
passwordroot2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
clear
[[ "$passwordroot" == "$passwordroot2" ]] || ( echo "Passwords did not match"; exit 1; )

######################################################################################
timedatectl set-ntp true

##### Partition the drive ############################################################
sgdisk -Z ${drive}

if [[ -d /sys/firmware/efi/efivars ]]; then
  #UEFI Partition
  parted ${drive} mklabel gpt mkpart primary fat32 1MiB 301MiB set 1 esp on mkpart primary ext4 301MiB 100%
  mkfs.fat -F32 ${drive}1
  mkfs.ext4 ${drive}2
  mount ${drive}2 /mnt
  mkdir /mnt/boot
  mount ${drive}1 /mnt/boot

else
  #BIOS Partition
  parted ${drive} mklabel msdos mkpart primary ext4 2MiB 100% set 1 boot on
  mkfs.ext4 ${drive}1
  mount ${drive}1 /mnt
fi
######################################################################################

##### Install base packages ##########################################################
pacstrap /mnt base base-devel linux linux-firmware nano networkmanager
genfstab -U /mnt >> /mnt/etc/fstab
######################################################################################
arch-chroot /mnt mkdir -p /boot/loader/entries
arch-chroot /mnt bootctl --path=/boot install

cat <<EOF > /mnt/boot/loader/loader.conf
default arch
timeout 3
console-mode max
editor no
EOF

cat >>/mnt/boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
#initrd  /intel-ucode.img
#initrd /amd-ucode.img
initrd  /initramfs-linux.img
options root=PARTUUID=$(blkid -s PARTUUID -o value "$drive"2) nowatchdog rw
EOF


##### Install a Bootloader ###########################################################
#if [[ -d /sys/firmware/efi/efivars ]]; then
  #pacstrap /mnt grub efibootmgr
  #arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
  #arch-chroot /mnt pacman -S --needed --noconfirm grub-customizer




#else
#  pacstrap /mnt grub
#  arch-chroot /mnt grub-install --target=i386-pc ${drive}
#  arch-chroot /mnt pacman -S --needed --noconfirm grub-customizer
#fi
######################################################################################

##### Setup some stuff ###############################################################
arch-chroot /mnt systemctl enable NetworkManager
ln -sf /run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf
arch-chroot /mnt systemctl enable systemd-resolved
pacstrap /mnt man-db man-pages git
sed -i "s/^#\(${alocale}\)/\1/" /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=${alocale}" > /mnt/etc/locale.conf
echo "${hostname}" > /mnt/etc/hostname
sed -i 's/^#\ \(%wheel\ ALL=(ALL)\ NOPASSWD:\ ALL\)/\1/' /mnt/etc/sudoers
echo 'KEYMAP='"${akeymap}" > /mnt/etc/vconsole.conf
sed -i "$ a FONT=${deffnt}" /mnt/etc/vconsole.conf
#echo 'FONT='"${deffnt}" > /mnt/etc/vconsole.conf
arch-chroot /mnt ln -sf /usr/share/zoneinfo/${timezne} /etc/localtime
sed -i 's/'#Color'/'Color'/g' /mnt/etc/pacman.conf
#sed -i 's/\#Include/Include'/g /mnt/etc/pacman.conf
sed -i '/^#\[multilib\]/{
  N
  s/^#\(\[multilib\]\n\)#\(Include\ .\+\)/\1\2/
}' /mnt/etc/pacman.conf
sed -i 's/\#\[multilib\]/\[multilib\]'/g /mnt/etc/pacman.conf
#######################################################################################

##### Setup swap ######################################################################
pacstrap /mnt systemd-swap
sed -i 's/'swapfc_enabled=0'/'swapfc_enabled=1'/g' /mnt/etc/systemd/swap.conf
#arch-chroot /mnt systemctl start systemd-swap
#arch-chroot /mnt systemctl stop systemd-swap
sed -i 's/'swapfc_force_preallocated=0'/'swapfc_force_preallocated=1'/g' /mnt/etc/systemd/swap.conf
#arch-chroot /mnt systemctl start systemd-swap
arch-chroot /mnt systemctl enable systemd-swap
#######################################################################################

##### Setup users and passwords #######################################################
arch-chroot /mnt useradd -m -g users -G storage,wheel,power,kvm -s /bin/bash "${user}"
echo "$password
$password
" | arch-chroot /mnt passwd $user

echo "$passwordroot
$passwordroot" | arch-chroot /mnt passwd
######################################################################################

##### Copy the GIT scripts to user directory #########################################
cp *.sh /home/$user/
#####################################################################################

#arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
echo "################################################################################"
echo "### Install of Arch Completed                                                ###"
echo "################################################################################"
sleep 2
