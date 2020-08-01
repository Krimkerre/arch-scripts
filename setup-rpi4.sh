#!/bin/bash
################################################################################
### Installing Arch Linux By:                                                ###
### Erik Sundquist                                                           ###
################################################################################
### Review and edit before using                                             ###
################################################################################
set -e
################################################################################
### Pacman Key setup                                                         ###
################################################################################
function PACMAN_KEYS() {
  pacman-key --init
  pacman-key --populate archlinuxarm
}
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
###############################################################################
### Setting up Systemd Swap Here                                             ###
################################################################################
function SYSDSWAP() {
  rm /etc/systemd/swap.conf
  echo "zswap_enabled=1" >> /etc/systemd/swap.conf
  echo "zswap_compressor=zstd" >> /etc/systemd/swap.conf     # lzo lz4 zstd lzo-rle lz4hc
  echo "zswap_max_pool_percent=25" >> /etc/systemd/swap.conf # 1-99
  echo "zswap_zpool=z3fold" >> /etc/systemd/swap.conf        # zbud z3fold (note z3fold requires kernel 4.8+)
  echo "zram_enabled=1" >> /etc/systemd/swap.conf
  echo "zram_size=\$(( RAM_SIZE / 4 ))" >> /etc/systemd/swap.conf    # This is 1/4 of ram size by default.
  echo "zram_count=\${NCPU}" >> /etc/systemd/swap.conf               # Device count
  echo "zram_streams=\${NCPU}" >> /etc/systemd/swap.conf             # Compress streams
  echo "zram_alg=zstd" >> /etc/systemd/swap.conf                    # See $zswap_compressor
  echo "zram_prio=32767" >> /etc/systemd/swap.conf                  # 1 - 32767
  echo "swapfc_enabled=1" >> /etc/systemd/swap.conf
  echo "swapfc_force_use_loop=0" >> /etc/systemd/swap.conf          # Force usage of swapfile + loop
  echo "swapfc_frequency=1" >> /etc/systemd/swap.conf               # How often to check free swap space in seconds
  echo "swapfc_chunk_size=256M" >> /etc/systemd/swap.conf           # Size of swap chunk
  echo "swapfc_max_count=32" >> /etc/systemd/swap.conf              # Note: 32 is a kernel maximum
  echo "swapfc_min_count=2" >> /etc/systemd/swap.conf               # Minimum amount of chunks to preallocate
  echo "swapfc_free_ram_perc=35" >> /etc/systemd/swap.conf          # Add first chunk if free ram < 35%
  echo "swapfc_free_swap_perc=15" >> /etc/systemd/swap.conf         # Add new chunk if free swap < 15%
  echo "swapfc_remove_free_swap_perc=55" >> /etc/systemd/swap.conf  # Remove chunk if free swap > 55% && chunk count > 2
  echo "swapfc_priority=50" >> /etc/systemd/swap.conf               # Priority of swapfiles (decreasing by one for each swapfile).
  echo "swapfc_path=/var/lib/systemd-swap/swapfc/" >> /etc/systemd/swap.conf
# Only for swapfile + loop
  echo "swapfc_nocow=1" >> /etc/systemd/swap.conf              # Disable CoW on swapfile
  echo "swapfc_directio=1" >> /etc/systemd/swap.conf           # Use directio for loop dev
  echo "swapfc_force_preallocated=1" >> /etc/systemd/swap.conf # Will preallocate created files
  echo "swapd_auto_swapon=1" >> /etc/systemd/swap.conf
  echo "swapd_prio=1024" >> /etc/systemd/swap.conf
  systemctl enable systemd-swap
}
################################################################################
### Needed Packages To Install                                               ###
################################################################################
function NEEDEDPKGS() {
  clear
  pacman -S --noconfirm --needed neofetch
  pacman -S --noconfirm --needed git
  pacman -S --noconfirm --needed wget
  pacman -S --noconfirm --needed rsync
  pacman -S --noconfirm --needed go
  pacman -S --noconfirm --needed htop
  pacman -S --noconfirm --needed openssh
  systemctl enable sshd
  systemctl start sshd
  pacman -S --noconfirm --needed archlinux-wallpaper
  pacman -S --noconfirm --needed glances
  pacman -S --noconfirm --needed bashtop
  pacman -S --noconfirm --needed packagekit
  pacman -S --noconfirm --needed man-db
  pacman -S --noconfirm --needed man-pages
  pacman -S --noconfirm --needed btrfs-progs xfsprogs resierfsprogs jfsutils nilfs-utils
  pacman -S --noconfirm --needed systemd-swap
}
################################################################################
### Main Program                                                             ###
################################################################################
PACMAN_KEYS
LOCALE
COUNTRY
STIMEZONE
UNAMEPASS
ROOTPASSWORD

sed -i "s/^#\(${ALOCALE}\)/\1/" /etc/locale.gen
locale-gen
echo "LANG=${ALOCALE}" >> /etc/locale.conf
sed -i 's/^#\ \(%wheel\ ALL=(ALL)\ NOPASSWD:\ ALL\)/\1/' /etc/sudoers
ln -sf /usr/share/zoneinfo/${TIMEZNE} /etc/localtime

NEEDEDPKGS
################################################################################
### Setting Passwords and Creating the User                                  ###
################################################################################
useradd -m -g users -G storage,wheel,power,kvm -s /bin/bash "${USRNM}"
echo "$UPASSWD
$UPASSWD
" | passwd $USRNM

echo "$RPASSWD
$RPASSWD" | passwd
