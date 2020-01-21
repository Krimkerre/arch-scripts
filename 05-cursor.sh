#!/bin/bash
###############################################################################
### Installing Arch Software By:                                               ###
### Erik Sundquist                                                          ###
###############################################################################
### Review and edit before using                                            ###
###############################################################################

set -e
clear
echo "################################################################################"
echo "Installing mouse cursors..........................."
echo "################################################################################"

sleep 2

sudo pacman -S --noconfirm --needed --asdeps capitaine-cursors
sudo pacman -S --noconfirm --needed --asdeps xcursor-pinux
sudo pacman -S --noconfirm --needed --asdeps xcursor-premium

yay -S --noconfirm --needed --asdeps cinnxp-icons
yay -S --noconfirm --needed --asdeps bibata-cursor-theme
yay -S --noconfirm --needed --asdeps xcursor-chicago95-git
yay -S --noconfirm --needed --asdeps numix-cursor-maia-git
yay -S --noconfirm --needed --asdeps xcursor-arch-cursor-complete
yay -S --noconfirm --needed --asdeps numix-cursor-theme
#yay -S --noconfirm --needed --asdeps starlabstheme-icons-git
