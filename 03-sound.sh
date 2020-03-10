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
echo "### Installing sound themes                                                  ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed deepin-sound-theme
yay -S --noconfirm --needed yaru-sound-theme
yay -S --noconfirm --needed sound-theme-smooth
yay -S --noconfirm --needed sound-theme-elementary-git
#yay -S --noconfirm --needed starlabstheme-sounds-git
echo "################################################################################"
echo "### Installation of sound themes completed                                   ###"
echo "################################################################################"
sleep 2
