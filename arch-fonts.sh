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
echo "### Installing extra fonts                                                   ###"
echo "################################################################################"

sleep 2

sudo pacman -S --noconfirm --needed --asdeps adobe-source-sans-pro-fonts
sudo pacman -S --noconfirm --needed --asdeps cantarell-fonts
sudo pacman -S --noconfirm --needed --asdeps noto-fonts
sudo pacman -S --noconfirm --needed --asdeps terminus-font
sudo pacman -S --noconfirm --needed --asdeps ttf-bitstream-vera
sudo pacman -S --noconfirm --needed --asdeps ttf-dejavu
sudo pacman -S --noconfirm --needed --asdeps ttf-droid
sudo pacman -S --noconfirm --needed --asdeps ttf-inconsolata
sudo pacman -S --noconfirm --needed --asdeps ttf-liberation
sudo pacman -S --noconfirm --needed --asdeps ttf-roboto
sudo pacman -S --noconfirm --needed --asdeps ttf-ubuntu-font-family
sudo pacman -S --noconfirm --needed --asdeps tamsyn-font
sudo pacman -S --noconfirm --needed --asdeps awesome-terminal-fonts
sudo pacman -S --noconfirm --needed --asdeps ttf-hack
yay -S --noconfirm --needed --asdeps ttf-ms-fonts
yay -S --noconfirm --needed --asdeps steam-fonts

echo "################################################################################"
echo "### Installing extra fonts completed                                         ###"
echo "################################################################################"
