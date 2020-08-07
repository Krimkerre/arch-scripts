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
  sudo pacman-key --init
  sudo pacman-key --populate archlinuxarm
  sudo pacman --noconfirm -Syyu
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
  sudo sh -c "echo 'zswap_enabled=1' >> /etc/systemd/swap.conf"
  sudo sh -c "echo 'zswap_compressor=zstd' >> /etc/systemd/swap.conf"     # lzo lz4 zstd lzo-rle lz4hc
  sudo sh -c "echo 'zswap_max_pool_percent=25' >> /etc/systemd/swap.conf" # 1-99
  sudo sh -c "echo 'zswap_zpool=z3fold' >> /etc/systemd/swap.conf"        # zbud z3fold (note z3fold requires kernel 4.8+)
  sudo sh -c "echo 'zram_enabled=1' >> /etc/systemd/swap.conf"
  sudo sh -c "echo 'zram_size=\$(( RAM_SIZE / 4 ))' >> /etc/systemd/swap.conf"    # This is 1/4 of ram size by default.
  sudo sh -c "echo 'zram_count=\${NCPU}' >> /etc/systemd/swap.conf"              # Device count
  sudo sh -c "echo 'zram_streams=\${NCPU}' >> /etc/systemd/swap.conf"             # Compress streams
  sudo sh -c "echo 'zram_alg=zstd' >> /etc/systemd/swap.conf"                    # See $zswap_compressor
  sudo sh -c "echo 'zram_prio=32767' >> /etc/systemd/swap.conf"                  # 1 - 32767
  sudo sh -c "echo 'swapfc_enabled=1' >> /etc/systemd/swap.conf"
  sudo sh -c "echo 'swapfc_force_use_loop=0' >> /etc/systemd/swap.conf"          # Force usage of swapfile + loop
  sudo sh -c "echo 'swapfc_frequency=1' >> /etc/systemd/swap.conf"               # How often to check free swap space in seconds
  sudo sh -c "echo 'swapfc_chunk_size=256M' >> /etc/systemd/swap.conf"           # Size of swap chunk
  sudo sh -c "echo 'swapfc_max_count=32' >> /etc/systemd/swap.conf"              # Note: 32 is a kernel maximum
  sudo sh -c "echo 'swapfc_min_count=2' >> /etc/systemd/swap.conf"               # Minimum amount of chunks to preallocate
  sudo sh -c "echo 'swapfc_free_ram_perc=35' >> /etc/systemd/swap.conf"          # Add first chunk if free ram < 35%
  sudo sh -c "echo 'swapfc_free_swap_perc=15' >> /etc/systemd/swap.conf"         # Add new chunk if free swap < 15%
  sudo sh -c "echo 'swapfc_remove_free_swap_perc=55' >> /etc/systemd/swap.conf"  # Remove chunk if free swap > 55% && chunk count > 2
  sudo sh -c "echo 'swapfc_priority=50' >> /etc/systemd/swap.conf"               # Priority of swapfiles (decreasing by one for each swapfile).
  sudo sh -c "echo 'swapfc_path=/var/lib/systemd-swap/swapfc/' >> /etc/systemd/swap.conf"
# Only for swapfile + loop
  sudo sh -c "echo 'swapfc_nocow=1' >> /etc/systemd/swap.conf"              # Disable CoW on swapfile
  sudo sh -c "echo 'swapfc_directio=1' >> /etc/systemd/swap.conf"           # Use directio for loop dev
  sudo sh -c "echo 'swapfc_force_preallocated=1' >> /etc/systemd/swap.conf" # Will preallocate created files
  sudo sh -c "echo 'swapd_auto_swapon=1' >> /etc/systemd/swap.conf"
  sudo sh -c "echo 'swapd_prio=1024' >> /etc/systemd/swap.conf"
  sudo systemctl enable systemd-swap
}
################################################################################
### Needed Packages To Install                                               ###
################################################################################
function NEEDEDPKGS() {
  clear
  sudo pacman -S --noconfirm --needed neofetch
  sudo pacman -S --noconfirm --needed git
  sudo pacman -S --noconfirm --needed wget
  sudo pacman -S --noconfirm --needed rsync
  sudo pacman -S --noconfirm --needed go
  sudo pacman -S --noconfirm --needed htop
  sudo pacman -S --noconfirm --needed openssh
  sudo systemctl enable sshd
  sudo systemctl start sshd
  sudo pacman -S --noconfirm --needed archlinux-wallpaper
  sudo pacman -S --noconfirm --needed glances
  sudo pacman -S --noconfirm --needed bashtop
  sudo pacman -S --noconfirm --needed packagekit
  sudo pacman -S --noconfirm --needed man-db
  sudo pacman -S --noconfirm --needed man-pages
  sudo pacman -S --noconfirm --needed btrfs-progs xfsprogs reiserfsprogs jfsutils nilfs-utils
  sudo pacman -S --noconfirm --needed systemd-swap
  sudo pacman -S --noconfirm --needed sudo
  sudo pacman -S --noconfirm --needed base-devel
  sudo pacman -S --noconfirm --needed linux-raspberrypi4-headers
  sudo pacman -S --noconfirm --needed networkmanager
}
################################################################################
### Add Neofetch to CLI                                                      ###
################################################################################
function ADD_NEOFETCH() {
  sudo sh -c "echo 'if [ -f /usr/bin/neofetch ]; then neofetch; fi' >> /etc/bash.bashrc"
}
################################################################################
### Install YAY (AUR Helper)                                                 ###
################################################################################
function INSTALLYAY() {
  clear
  echo "################################################################################"
  echo "### Installing YAY                                                           ###"
  echo "################################################################################"
  sleep 2
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm --needed
  cd ..
  rm yay -R -f
}
################################################################################
### Setting Up Sound                                                         ###
################################################################################
function SOUNDSETUP() {
  clear
  echo "################################################################################"
  echo "### Setting up sound                                                         ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed pulseaudio
  sudo pacman -S --noconfirm --needed pulseaudio-alsa
  sudo pacman -S --noconfirm --needed pavucontrol
  sudo pacman -S --noconfirm --needed alsa-utils
  sudo pacman -S --noconfirm --needed alsa-plugins
  sudo pacman -S --noconfirm --needed alsa-lib
  sudo pacman -S --noconfirm --needed alsa-firmware
  sudo pacman -S --noconfirm --needed gstreamer
  sudo pacman -S --noconfirm --needed gst-plugins-good
  sudo pacman -S --noconfirm --needed gst-plugins-bad
  sudo pacman -S --noconfirm --needed gst-plugins-base
  sudo pacman -S --noconfirm --needed gst-plugins-ugly
  sudo pacman -S --noconfirm --needed volumeicon
  sudo pacman -S --noconfirm --needed playerctl
}
################################################################################
### Setting Up Bluetooth                                                     ###
################################################################################
function BLUETOOTHSETUP() {
  clear
  echo "################################################################################"
  echo "### Installing and setting up bluetooth                                      ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed pulseaudio-bluetooth
  sudo pacman -S --noconfirm --needed bluez
  sudo pacman -S --noconfirm --needed bluez-libs
  sudo pacman -S --noconfirm --needed bluez-utils
  sudo pacman -S --noconfirm --needed bluez-plugins
  sudo pacman -S --noconfirm --needed blueberry
  sudo pacman -S --noconfirm --needed bluez-tools
  sudo pacman -S --noconfirm --needed bluez-cups
  sudo systemctl enable bluetooth.service
  sudo systemctl start bluetooth.service
  sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf
}
################################################################################
### Setup Printing                                                           ###
################################################################################
function PRINTERSETUP() {
  clear
  echo "################################################################################"
  echo "### Installing and setting up printers                                       ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed cups
  sudo pacman -S --noconfirm --needed cups-pdf
  sudo pacman -S --noconfirm --needed ghostscript
  sudo pacman -S --noconfirm --needed gsfonts
  sudo pacman -S --noconfirm --needed gutenprint
  sudo pacman -S --noconfirm --needed gtk3-print-backends
  sudo pacman -S --noconfirm --needed libcups
  #sudo sudo pacman -S --noconfirm --needed hplip
  sudo pacman -S --noconfirm --needed system-config-printer
  sudo pacman -S --noconfirm --needed foomatic-db
  sudo pacman -S --noconfirm --needed foomatic-db-ppds
  sudo pacman -S --noconfirm --needed foomatic-db-gutenprint-ppds
  sudo pacman -S --noconfirm --needed foomatic-db-engine
  sudo pacman -S --noconfirm --needed foomatic-db-nonfree
  sudo pacman -S --noconfirm --needed foomatic-db-nonfree-ppds
  yay -S --noconfirm --needed epson-inkjet-printer-escpr
  sudo systemctl enable org.cups.cupsd.service
}
################################################################################
### Samba Share Setup                                                        ###
################################################################################
function SAMBASETUP() {
  clear
  echo "################################################################################"
  echo "### Installing Samba and network sharing                                     ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed  samba
  sudo wget "https://git.samba.org/samba.git/?p=samba.git;a=blob_plain;f=examples/smb.conf.default;hb=HEAD" -O /etc/samba/smb.conf
  sudo sed -i -r 's/MYGROUP/WORKGROUP/' /etc/samba/smb.conf
  sudo sed -i -r "s/Samba Server/$HOSTNAME/" /etc/samba/smb.conf
  sudo systemctl enable smb.service
  sudo systemctl start smb.service
  sudo systemctl enable nmb.service
  sudo systemctl start nmb.service
  #Change your username here
  sudo smbpasswd -a $(whoami)
  #Access samba share windows
  sudo pacman -S --noconfirm --needed  gvfs-smb avahi
  sudo systemctl enable avahi-daemon.service
  sudo systemctl start avahi-daemon.service
  sudo pacman -S --noconfirm --needed  nss-mdns
  sudo sed -i 's/dns/mdns dns wins/g' /etc/nsswitch.conf
  #Set-up user sharing (disable this section if you dont want user shares)
  sudo mkdir -p /var/lib/samba/usershares
  sudo groupadd -r sambashare
  sudo chown root:sambashare /var/lib/samba/usershares
  sudo chmod 1770 /var/lib/samba/usershares
  sudo sed -i -r '/\[global\]/a\username path = /var/lib/samba/usershares\nusershare max shares = 100\nusershare allow guests = yes\nusershare owner only = yes' /etc/samba/smb.conf
  sudo gpasswd sambashare -a $(whoami)
}
################################################################################
### Installing the Display Manager                                           ###
################################################################################
function DISPLAYMGR() {
  clear
  echo "################################################################################"
  echo "### Install and setup display manager and desktop                            ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed xorg
  sudo pacman -S --noconfirm --needed xorg-drivers
  sudo pacman -S --noconfirm --needed xorg-xinit
  sudo pacman -S --noconfirm --needed xterm
  sudo pacman -S --noconfirm --needed vkd3d
  sudo pacman -S --noconfirm --needed kvantum-qt5
  sudo pacman -S --noconfirm --needed opencl-mesa
  sudo pacman -S --noconfirm --needed opencl-headers
  sudo pacman -S --noconfirm --needed terminator
  sudo pacman -S --noconfirm --needed mesa-vdpau
  sudo pacman -S --noconfirm --needed ocl-icd
}
################################################################################
### Install Deepin DE                                                        ###
################################################################################
function DEEPIN_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Deepin Desktop                                            ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed deepin
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed packagekit-qt5
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo sed -i 's/'#user-session=default'/'user-session=deepin'/g' /etc/lightdm/lightdm.conf
}
################################################################################
### Install Gnome DE                                                         ###
################################################################################
function GNOME_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Gnome Desktop                                             ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed gdm gnome
  sudo pacman -S --noconfirm --needed nautilus-share
  sudo pacman -S --noconfirm --needed chrome-gnome-shell
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -R --noconfirm gnome-terminal
  sudo pacman -S --noconfirm --needed gnome-packagekit gnome-software-packagekit-plugin
  yay -S --noconfirm --needed gnome-terminal-transparency
  #sudo systemctl enable gdm
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo sed -i 's/'#user-session=default'/'user-session=gnome'/g' /etc/lightdm/lightdm.conf
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-userdock
  yay -S --noconfirm --needed lightdm-webkit-theme-tendou
  yay -S --noconfirm --needed lightdm-webkit-theme-wisp
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
}
################################################################################
### Install KDE Plasma DE                                                    ###
################################################################################
function PLASMA_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The KDE Plasma Desktop                                        ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed plasma kde-applications
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed redshift
  sudo pacman -S --noconfirm --needed packagekit-qt5
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
  sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo sed -i 's/'#user-session=default'/'user-session=plasma'/g' /etc/lightdm/lightdm.conf
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-userdock
  yay -S --noconfirm --needed lightdm-webkit-theme-tendou
  yay -S --noconfirm --needed lightdm-webkit-theme-wisp
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
}
################################################################################
### Installing MATE DE                                                       ###
################################################################################
function MATE_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The MATE Desktop                                              ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed mate mate-extra
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed file-roller unrar p7zip
  #yay -S --noconfirm --needed user-admin
  yay -S --noconfirm --needed mate-tweak
  yay -S --noconfirm --needed brisk-menu
  yay -S --noconfirm --needed mate-screensaver-hacks
  yay -S --noconfirm --needed mugshot
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
  sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-userdock
  yay -S --noconfirm --needed lightdm-webkit-theme-tendou
  yay -S --noconfirm --needed lightdm-webkit-theme-wisp
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo sed -i 's/'#user-session=default'/'user-session=mate'/g' /etc/lightdm/lightdm.conf
}
###############################################################################
### Installing XFCE DE                                                       ###
################################################################################
function XFCE_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The XFCE Desktop                                              ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed xfce4 xfce4-goodies
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed alacarte
  sudo pacman -S --noconfirm --needed gnome-calculator
  sudo pacman -S --noconfirm --needed picom
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed libnma
  sudo pacman -S --noconfirm --needed networkmanager
  sudo pacman -S --noconfirm --needed networkmanager-openconnect
  sudo pacman -S --noconfirm --needed networkmanager-openvpn
  sudo pacman -S --noconfirm --needed networkmanager-pptp
  sudo pacman -S --noconfirm --needed nm-connection-editor
  sudo pacman -S --noconfirm --needed network-manager-applet
  sudo pacman -S --noconfirm --needed onboard
  yay -S --noconfirm --needed xfce4-screensaver
  yay -S --noconfirm --needed xfce4-panel-profiles-git
  yay -S --noconfirm --needed mugshot
  yay -S --noconfirm --needed solarized-dark-themes
  yay -S --noconfirm --needed gtk-theme-glossyblack
  yay -S --noconfirm --needed mcos-mjv-xfce-edition
  #yay -S --noconfirm --needed compton-conf-git
  #yay -S --noconfirm --needed xfce-theme-manager
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
  sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-userdock
  yay -S --noconfirm --needed lightdm-webkit-theme-tendou
  yay -S --noconfirm --needed lightdm-webkit-theme-wisp
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
  yay -S --noconfirm --needed xfce4-theme-switcher
  yay -S --noconfirm --needed xts-windows10-theme
  yay -S --noconfirm --needed xts-macos-theme
  yay -S --noconfirm --needed xts-dark-theme
  yay -S --noconfirm --needed xts-arcolinux-theme
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo sed -i 's/'#user-session=default'/'user-session=xfce'/g' /etc/lightdm/lightdm.conf
}
################################################################################
### Installing Budgie DE                                                     ###
################################################################################
function BUDGIE_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Budgie Desktop                                            ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed budgie-desktop budgie-extras
  sudo pacman -S --noconfirm --needed gnome-system-monitor
  sudo pacman -S --noconfirm --needed nautilus
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed gnome-control-center
  sudo pacman -S --noconfirm --needed gnome-backgrounds
  sudo pacman -S --noconfirm --needed gnome-calculator
  sudo pacman -S --noconfirm --needed gedit
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
  sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed file-roller unrar p7zip
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-userdock
  yay -S --noconfirm --needed lightdm-webkit-theme-tendou
  yay -S --noconfirm --needed lightdm-webkit-theme-wisp
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo sed -i 's/'#user-session=default'/'user-session=budgie-desktop'/g' /etc/lightdm/lightdm.conf
}
################################################################################
### Install The Cinnamon DE                                                  ###
################################################################################
function CINNAMON_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Cinnamon Desktop                                          ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed cinnamon
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed gnome-system-monitor
  sudo pacman -S --noconfirm --needed gnome-calculator
  sudo pacman -S --noconfirm --needed gpicview
  sudo pacman -S --noconfirm --needed gedit
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
  sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-userdock
  yay -S --noconfirm --needed lightdm-webkit-theme-tendou
  yay -S --noconfirm --needed lightdm-webkit-theme-wisp
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo sed -i 's/'#user-session=default'/'user-session=cinnamon'/g' /etc/lightdm/lightdm.conf
}
################################################################################
### Install The LXDE DE                                                      ###
################################################################################
function LXDE_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The LXDE Desktop                                              ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed lxde
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed gnome-calculator
  sudo pacman -S --noconfirm --needed gedit
  sudo pacman -S --noconfirm --needed picom
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed file-roller unrar p7zip
  yay -S --noconfirm --needed mugshot
  #yay -S --noconfirm --needed compton-conf
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
  sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-userdock
  yay -S --noconfirm --needed lightdm-webkit-theme-tendou
  yay -S --noconfirm --needed lightdm-webkit-theme-wisp
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo sed -i 's/'#user-session=default'/'user-session=lxde'/g' /etc/lightdm/lightdm.conf
}
################################################################################
### Install The LXQT DE                                                      ###
################################################################################
function LXQT_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The LXQT Desktop                                              ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed lxqt
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed picom
  sudo pacman -S --noconfirm --needed gnome-calculator
  sudo pacman -S --noconfirm --needed gedit
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed packagekit-qt5
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
  sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-userdock
  yay -S --noconfirm --needed lightdm-webkit-theme-tendou
  yay -S --noconfirm --needed lightdm-webkit-theme-wisp
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo sed -i 's/'#user-session=default'/'user-session=lxqt'/g' /etc/lightdm/lightdm.conf
}
################################################################################
### Install The i3 Window Manager                                            ###
################################################################################
function I3_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The i3 Window Manager                                         ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed i3
  sudo pacman -S --noconfirm --needed gnome-disk-utility
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
  sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-userdock
  yay -S --noconfirm --needed lightdm-webkit-theme-tendou
  yay -S --noconfirm --needed lightdm-webkit-theme-wisp
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo sed -i 's/'#user-session=default'/'user-session=i3'/g' /etc/lightdm/lightdm.conf
}
################################################################################
### Install Enlightenment DE                                                 ###
################################################################################
function ENLIGHTENMENT_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Enlightenment Desktop                                     ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed enlightenment efl efl-docs
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
  sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed connman
  #yay -S --noconfirm --needed econnman
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-userdock
  yay -S --noconfirm --needed lightdm-webkit-theme-tendou
  yay -S --noconfirm --needed lightdm-webkit-theme-wisp
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo systemctl enable connman.service
  sudo sed -i 's/'#user-session=default'/'user-session=enlightenment'/g' /etc/lightdm/lightdm.conf
}
################################################################################
### Install Sway Window Tiling Manager                                       ###
################################################################################
function SWAY_DE() {
  clear
  echo "################################################################################"
  echo "### Installing The Sway Tiling Window Manager                                ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed sway
  sudo pacman -S --noconfirm --needed swaybg
  sudo pacman -S --noconfirm --needed swayidle
  sudo pacman -S --noconfirm --needed swaylock
  sudo pacman -S --noconfirm --needed waybar
  sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  sudo pacman -S --noconfirm --needed lightdm-webkit-theme-litarvan
  sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
  sudo pacman -S --noconfirm --needed onboard
  sudo pacman -S --noconfirm --needed file-roller unrar p7zip
  sudo pacman -S --noconfirm --needed dmenu
  sudo pacman -S --noconfirm --needed alacritty
  yay -S --noconfirm --needed lightdm-webkit2-theme-material2
  yay -S --noconfirm --needed lightdm-webkit-theme-aether
  yay -S --noconfirm --needed lightdm-webkit-theme-userdock
  yay -S --noconfirm --needed lightdm-webkit-theme-tendou
  yay -S --noconfirm --needed lightdm-webkit-theme-wisp
  yay -S --noconfirm --needed lightdm-webkit-theme-petrichor-git
  yay -S --noconfirm --needed lightdm-webkit-theme-sequoia-git
  yay -S --noconfirm --needed lightdm-webkit-theme-contemporary
  yay -S --noconfirm --needed lightdm-webkit2-theme-sapphire
  yay -S --noconfirm --needed lightdm-webkit2-theme-tty-git
  yay -S --noconfirm --needed lightdm-webkit2-theme-obsidian
  sudo systemctl enable lightdm.service -f
  sudo systemctl set-default graphical.target
  sudo sed -i 's/'#user-session=default'/'user-session=sway'/g' /etc/lightdm/lightdm.conf
}
################################################################################
### Desktop Environment selection                                            ###
################################################################################
function DE_SELECTION() {
  clear
  echo "##############################################################################"
  echo "What is your preferred desktop environment"
  echo "1)  Deepin - NOT CURRENTLY WORKING ON ARM"
  echo "2)  Gnome"
  echo "3)  KDE Plasma"
  echo "4)  Mate"
  echo "5)  XFCE4"
  echo "6)  Budgie"
  echo "7)  Cinnamon"
  echo "8)  LXDE"
  echo "9)  LXQT"
  echo "10) i3"
  echo "11) Enlightenment"
  echo "12) Sway"
  echo "13) None"
  echo "##############################################################################"
  read case;

  case $case in
    1)
    DEEPIN_DE
    ;;
    2)
    GNOME_DE
    ;;
    3)
    PLASMA_DE
    ;;
    4)
    MATE_DE
    ;;
    5)
    XFCE_DE
    ;;
    6)
    BUDGIE_DE
    ;;
    7)
    CINNAMON_DE
    ;;
    8)
    LXDE_DE
    ;;
    9)
    LXQT_DE
    ;;
    10)
    I3_DE
    ;;
    11)
    ENLIGHTENMENT_DE
    ;;
    12)
    SWAY_DE
    ;;
    13)
    clear
    echo "##############################################################################"
    echo "### You Have Selected None                                                 ###"
    echo "##############################################################################"
    ;;
  esac
}
################################################################################
### Install Software Centers (Pamac/Snaps/Flatpak)                           ###
################################################################################
function SOFTWARECENTER() {
  clear
  echo "################################################################################"
  echo "### Installing Software Centers (Pamac/Snaps/Flatpak)                        ###"
  echo "################################################################################"
  sleep 2
  yay -S --noconfirm --needed pamac-aur
  yay -S --noconfirm --needed snapd
  sudo pacman -S --noconfirm --needed flatpak
  sudo systemctl enable snapd.service
  yay -S --noconfirm --needed bauh
  yay -S --noconfirm --needed flatseal
}
################################################################################
### Software To Install (My Standard Applications)                           ###
################################################################################
function SOFTWAREINSTALLSTD() {
  clear
  echo "################################################################################"
  echo "### Installing Standard Applications                                         ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S --noconfirm --needed firefox
  sudo pacman -S --noconfirm --needed cockpit cockpit-dashboard cockpit-docker cockpit-machines cockpit-pcp cockpit-podman
  sudo systemctl enable --now cockpit.socket
  yay -S --noconfirm --needed rpimonitor
  yay -S --noconfirm --needed rpi-imager
  yay -S --noconfirm --needed rpi-eeprom
  yay -S --noconfirm --needed tuned
  sudo systemctl enable tuned
  sudo systemctl enable rpimonitord
}
################################################################################
### Main Program                                                             ###
################################################################################
#PACMAN_KEYS     #Removed because of having to install sudo first before running script
LOCALE
COUNTRY
STIMEZONE
UNAMEPASS
ROOTPASSWORD

sudo sed -i "s/^#\(${ALOCALE}\)/\1/" /etc/locale.gen
sudo locale-gen
sudo sh -c "echo 'LANG=${ALOCALE}' >> /etc/locale.conf"
sudo ln -sf /usr/share/zoneinfo/${TIMEZNE} /etc/localtime

NEEDEDPKGS
INSTALLYAY
SOUNDSETUP
BLUETOOTHSETUP
PRINTERSETUP
clear
echo "##############################################################################"
echo "Do you want SAMBA network sharing installed?"
echo "1)  Yes"
echo "2)  No"
echo "##############################################################################"
read case;

case $case in
  1)
  SAMBASETUP
  ;;
  2)
  ;;
esac
clear
echo "##############################################################################"
echo "Do you want a the Display Manager installed?"
echo "1)  Yes"
echo "2)  No"
echo "##############################################################################"
read case;

case $case in
  1)
  DISPLAYMGR
  ;;
  2)
  ;;
esac
clear
echo "##############################################################################"
echo "Do you want a Desktop Environment (Gnome, Plasma, etc) installed?"
echo "1)  Yes"
echo "2)  No"
echo "##############################################################################"
read case;

case $case in
  1)
  DE_SELECTION
  ;;
  2)
  ;;
esac

SOFTWARECENTER
SOFTWAREINSTALLSTD

ADD_NEOFETCH
sudo sed -i 's/^#\ \(%wheel\ ALL=(ALL)\ NOPASSWD:\ ALL\)/\1/' /etc/sudoers
################################################################################
### Setting Passwords and Creating the User                                  ###
################################################################################
sudo useradd -m -g users -G storage,wheel,power,kvm -s /bin/bash "${USRNM}"
sudo echo "$UPASSWD
$UPASSWD
" | sudo passwd $USRNM

echo "$RPASSWD
$RPASSWD" | sudo passwd
#sudo userdel --remove alarm
sudo systemctl enable NetworkManager
