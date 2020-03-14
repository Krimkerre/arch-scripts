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
echo "### Installing icon themes                                                   ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed breeze-icons
sudo pacman -S --noconfirm --needed deepin-icon-theme
sudo pacman -S --noconfirm --needed elementary-icon-theme
sudo pacman -S --noconfirm --needed gnome-icon-theme
sudo pacman -S --noconfirm --needed gnome-icon-theme-extras
sudo pacman -S --noconfirm --needed gnome-icon-theme-symbolic
sudo pacman -S --noconfirm --needed oxygen-icons
sudo pacman -S --noconfirm --needed papirus-icon-theme
sudo pacman -S --noconfirm --needed arc-icon-theme
yay -S --noconfirm --needed numix-icon-theme-git
yay -S --noconfirm --needed numix-circle-icon-theme-git
yay -S --noconfirm --needed numix-circle-arc-icons-git
yay -S --noconfirm --needed suru-plus-git
yay -S --noconfirm --needed faenza-icon-theme
yay -S --noconfirm --needed paper-icon-theme-git
yay -S --noconfirm --needed windows-longhorn-icons-git
yay -S --noconfirm --needed evolvere-icons-git
yay -S --noconfirm --needed sardi-icons
yay -S --noconfirm --needed buuf-icon-theme
yay -S --noconfirm --needed cinnxp-icon-theme-git
yay -S --noconfirm --needed candy-icons-git
yay -S --noconfirm --needed boston-icon-theme
yay -S --noconfirm --needed chicago95-icon-theme-git
yay -S --noconfirm --needed qogir-icon-theme-git
yay -S --noconfirm --needed mcmojave-circle-icon-theme-git
yay -S --noconfirm --needed windows10-icon-theme-git
#yay -S --noconfirm --needed  starlabstheme-icons-git
echo "################################################################################"
echo "### Installation of icon themes completed                                    ###"
echo "################################################################################"
sleep 2
