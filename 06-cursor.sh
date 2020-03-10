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
echo "### Installing cursor themes                                                 ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed capitaine-cursors
sudo pacman -S --noconfirm --needed xcursor-pinux
sudo pacman -S --noconfirm --needed xcursor-premium
yay -S --noconfirm --needed cinnxp-icons
yay -S --noconfirm --needed bibata-cursor-theme
yay -S --noconfirm --needed xcursor-chicago95-git
yay -S --noconfirm --needed numix-cursor-maia-git
yay -S --noconfirm --needed xcursor-arch-cursor-complete
yay -S --noconfirm --needed numix-cursor-theme
yay -S --noconfirm --needed xcursor-chicago95-git
#yay -S --noconfirm --needed starlabstheme-icons-git

echo "################################################################################"
echo "### Installation of cursors completed                                        ###"
echo "################################################################################"
sleep 2
