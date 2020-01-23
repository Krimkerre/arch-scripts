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
sudo pacman -S --noconfirm --needed  adobe-source-sans-pro-fonts
sudo pacman -S --noconfirm --needed  cantarell-fonts
sudo pacman -S --noconfirm --needed  noto-fonts
sudo pacman -S --noconfirm --needed  terminus-font
sudo pacman -S --noconfirm --needed  ttf-bitstream-vera
sudo pacman -S --noconfirm --needed  ttf-dejavu
sudo pacman -S --noconfirm --needed  ttf-droid
sudo pacman -S --noconfirm --needed  ttf-inconsolata
sudo pacman -S --noconfirm --needed  ttf-liberation
sudo pacman -S --noconfirm --needed  ttf-roboto
sudo pacman -S --noconfirm --needed  ttf-ubuntu-font-family
sudo pacman -S --noconfirm --needed  tamsyn-font
sudo pacman -S --noconfirm --needed  awesome-terminal-fonts
sudo pacman -S --noconfirm --needed  ttf-hack
sudo pacman -S --noconfirm --needed  ttf-ibm-plex
yay -S --noconfirm --needed  ttf-ms-fonts
yay -S --noconfirm --needed  steam-fonts
#yay -S --noconfirm --needed  starlabstheme-font-git

echo "################################################################################"
echo "### Installing extra fonts completed                                         ###"
echo "################################################################################"
