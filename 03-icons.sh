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
echo "Installing icons..........................."
echo "################################################################################"

sleep 2

sudo pacman -S --noconfirm --needed --asdeps breeze-icons
sudo pacman -S --noconfirm --needed --asdeps deepin-icon-theme
sudo pacman -S --noconfirm --needed --asdeps elementary-icon-theme
sudo pacman -S --noconfirm --needed --asdeps gnome-icon-theme
sudo pacman -S --noconfirm --needed --asdeps gnome-icon-theme-extras
sudo pacman -S --noconfirm --needed --asdeps gnome-icon-theme-symbolic
sudo pacman -S --noconfirm --needed --asdeps oxygen-icons
sudo pacman -S --noconfirm --needed --asdeps papirus-icon-theme
sudo pacman -S --noconfirm --needed --asdeps arc-icon-theme

yay -S --noconfirm --needed --asdeps numix-icon-theme-git
yay -S --noconfirm --needed --asdeps numix-circle-icon-theme-git
yay -S --noconfirm --needed --asdeps numix-circle-arc-icons-git
yay -S --noconfirm --needed --asdeps suru-plus-git
yay -S --noconfirm --needed --asdeps faenza-icon-theme
yay -S --noconfirm --needed --asdeps paper-icon-theme-git
yay -S --noconfirm --needed --asdeps windows-longhorn-icons-git
yay -S --noconfirm --needed --asdeps evolvere-icons-git
yay -S --noconfirm --needed --asdeps sardi-icons
yay -S --noconfirm --needed --asdeps buuf-icon-theme
yay -S --noconfirm --needed --asdeps cinnxp-icon-theme-git
yay -S --noconfirm --needed --asdeps candy-icons-git
#yay -S --noconfirm --needed --asdeps starlabstheme-icons-git
