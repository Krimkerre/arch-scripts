#!/bin/bash
################################################################################
### Installing Arch Linux By:                                                ###
### Erik Sundquist                                                           ###
################################################################################
### Review and edit before using                                             ###
################################################################################
set -e
################################################################################
### Set Your System Locale Here                                              ###
################################################################################
function LOCALE() {
  ALOCALE="en_US.UTF-8"
}
################################################################################
### Set Your Country                                                         ###
################################################################################
function COUNTRY() {
  CNTRY="US"
}
################################################################################
### Set Your Keyboard Map Here                                               ###
################################################################################
function KEYMAP() {
  AKEYMAP="us"
}
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
  DEFFNT=$(dialog --stdout --title "Select your terminal (CLI) font" --fselect /usr/share/kbd/consolefonts/ 24 48)
}
################################################################################
### Set Your Timezone Here                                                   ###
################################################################################
function STIMEZONE() {
  TIMEZNE='America/Los_Angeles'
}
################################################################################
### Set Username And Password Here                                           ###
################################################################################
function UNAMEPASS() {
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
################################################################################
### Set Admin (Root) Password Here                                           ###
################################################################################
function ROOTPASSWORD() {
  RPASSWD=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
  clear
  : ${RPASSWD:?"password cannot be empty"}
  RPASSWD2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
  clear
  [[ "$RPASSWD" == "$RPASSWD2" ]] || ( echo "Passwords did not match"; exit 1; )
}
################################################################################
### Partition And Format The Hard Drive Here                                 ###
################################################################################
function PARTHD() {
  sgdisk -Z ${HD}
  if [[ -d /sys/firmware/efi/efivars ]]; then
    #UEFI Partition
    parted ${HD} mklabel gpt mkpart primary fat32 1MiB 301MiB set 1 esp on mkpart primary ext4 301MiB 100%
    mkfs.fat -F32 ${HD}1
    mkfs.ext4 ${HD}2
    #mkfs.btrfs -f ${HD}2
  else
    #BIOS Partition
    parted ${HD} mklabel msdos mkpart primary ext4 2MiB 100% set 1 boot on
    mkfs.ext4 ${HD}1
    #mkfs.btrfs ${HD}1
  fi
}
################################################################################
### Mount The Hard Drive Here                                                ###
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
### Install the Base Packages Here                                           ###
################################################################################
function BASEPKG() {
  pacstrap /mnt base base-devel linux linux-firmware linux-headers nano networkmanager man-db man-pages git btrfs-progs systemd-swap
  genfstab -U /mnt >> /mnt/etc/fstab
}
################################################################################
### Systemd Boot Setting Here                                                ###
################################################################################
function SYSDBOOT() {
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
  echo "options root=PARTUUID="$(blkid -s PARTUUID -o value "$HD"2)" nowatchdog rw" >> /mnt/boot/loader/entries/arch.conf
}
################################################################################
### Grub Boot Settings Here                                                  ###
################################################################################
function GRUBBOOT() {
  if [[ -d /sys/firmware/efi/efivars ]]; then
    pacstrap /mnt grub efibootmgr
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --removable
    arch-chroot /mnt pacman -S --needed --noconfirm grub-customizer
  else
    pacstrap /mnt grub
    arch-chroot /mnt grub-install --target=i386-pc ${HD}
    arch-chroot /mnt pacman -S --needed --noconfirm grub-customizer
  fi
}
################################################################################
### Setting up Systemd Swap Here                                             ###
################################################################################
function SYSDSWAP() {
  rm /mnt/etc/systemd/swap.conf
  NCPU=$(nproc --all)
  echo "zswap_enabled=1" >> /mnt/etc/systemd/swap.conf
  echo "zswap_compressor=zstd" >> /mnt/etc/systemd/swap.conf
  echo "zswap_max_pool_percent=25" >> /mnt/etc/systemd/swap.conf
  echo "zswap_zpool=z3fold" >> /mnt/etc/systemd/swap.conf
  echo "zram_enabled=1"  >> /mnt/etc/systemd/swap.conf
  echo "zram_size=$(( RAM_SIZE / 4 ))"  >> /mnt/etc/systemd/swap.conf
  echo "zram_count=${NCPU}"  >> /mnt/etc/systemd/swap.conf
  echo "zram_streams=${NCPU}" >> /mnt/etc/systemd/swap.conf
  echo "zram_alg=zstd" >> /mnt/etc/systemd/swap.conf
  echo "zram_prio=32767" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_enabled=1" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_force_use_loop=0" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_frequency=1" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_chunk_size=256M" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_max_count=32" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_min_count=0" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_free_swap_perc=15" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_remove_free_swap_perc=55" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_priority=-2" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_path=/var/lib/systemd-swap/swapfc/" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_nocow=1" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_directio=1" >> /mnt/etc/systemd/swap.conf
  echo "swapfc_force_preallocated=1" >> /mnt/etc/systemd/swap.conf
  echo "swapd_auto_swapon=1" >> /mnt/etc/systemd/swap.conf
  echo "swapd_prio=1024" >> /mnt/etc/systemd/swap.conf
  arch-chroot /mnt systemctl enable systemd-swap
}
################################################################################
### Updating Pacman (Repos), Installing Reflector And Getting Fastest Repos  ###
################################################################################
function REPOFIX() {
  pacman -Sy
  pacman -S --noconfirm --needed reflector
  reflector --country ${CNTRY} --age 24 --sort rate --save /etc/pacman.d/mirrorlist
  pacman -Sy
}
################################################################################
### Main Program - Edit At Own Risk                                          ###
################################################################################
clear
timedatectl set-ntp true
COUNTRY
REPOFIX
clear
LOCALE
KEYMAP
STIMEZONE
HOSTNAME
CLIFONT
DRVSELECT
UNAMEPASS
ROOTPASSWORD
clear
PARTHD
MNTHD
BASEPKG
SYSDBOOT
SYSDSWAP
################################################################################
### Misc Settings                                                            ###
################################################################################
arch-chroot /mnt systemctl enable NetworkManager
ln -sf /run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf
arch-chroot /mnt systemctl enable systemd-resolved
sed -i "s/^#\(${ALOCALE}\)/\1/" /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=${ALOCALE}" >> /mnt/etc/locale.conf
echo "${HOSTNM}" >> /mnt/etc/hostname
sed -i 's/^#\ \(%wheel\ ALL=(ALL)\ NOPASSWD:\ ALL\)/\1/' /mnt/etc/sudoers
echo "KEYMAP="${AKEYMAP} >> /mnt/etc/vconsole.conf
#sed -i "$ a FONT=${DEFFNT}" /mnt/etc/vconsole.conf
echo "FONT="${DEFFNT} >> /mnt/etc/vconsole.conf
arch-chroot /mnt ln -sf /usr/share/zoneinfo/${TIMEZNE} /etc/localtime
sed -i 's/'#Color'/'Color'/g' /mnt/etc/pacman.conf
#sed -i 's/\#Include/Include'/g /mnt/etc/pacman.conf
sed -i '/^#\[multilib\]/{
  N
  s/^#\(\[multilib\]\n\)#\(Include\ .\+\)/\1\2/
}' /mnt/etc/pacman.conf
sed -i 's/\#\[multilib\]/\[multilib\]'/g /mnt/etc/pacman.conf

################################################################################
### Setting Passwords and Creating the User                                  ###
################################################################################
arch-chroot /mnt useradd -m -g users -G storage,wheel,power,kvm -s /bin/bash "${USRNM}"
echo "$UPASSWD
$UPASSWD
" | arch-chroot /mnt passwd $USRNM

echo "$RPASSWD
$RPASSWD" | arch-chroot /mnt passwd
