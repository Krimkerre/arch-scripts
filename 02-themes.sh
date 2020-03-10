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
echo "### Installing GTK+ themes                                                   ###"
echo "################################################################################"
sleep 2
sudo pacman -S --noconfirm --needed adapta-gtk-theme
sudo pacman -S --noconfirm --needed arc-gtk-theme
sudo pacman -S --noconfirm --needed arc-solid-gtk-theme
sudo pacman -S --noconfirm --needed breeze-gtk
sudo pacman -S --noconfirm --needed deepin-gtk-theme
sudo pacman -S --noconfirm --needed materia-gtk-theme
sudo pacman -S --noconfirm --needed oxygen-gtk2
yay -S --noconfirm --needed numix-gtk-theme-git
yay -S --noconfirm --needed windows10-gtk-theme-git windows10-dark-gtk-theme-git
yay -S --noconfirm --needed abrus-gtk-theme-git
yay -S --noconfirm --needed paper-gtk-theme-git
yay -S --noconfirm --needed ant-nebula-gtk-theme
yay -S --noconfirm --needed chicago95-gtk-theme-git
yay -S --noconfirm --needed canta-gtk-theme
yay -S --noconfirm --needed pro-dark-gtk-theme-git
yay -S --noconfirm --needed aqua-git
yay -S --noconfirm --needed evopop-gtk-theme-git
yay -S --noconfirm --needed chromeos-gtk-theme-git
yay -S --noconfirm --needed gtk-theme-inspire-ui
yay -S --noconfirm --needed oomox
yay -S --noconfirm --needed pop-gtk-theme-git
yay -S --noconfirm --needed qogir-gtk-theme-git
yay -S --noconfirm --needed candy-gtk-theme
yay -S --noconfirm --needed mojave-gtk-theme-git
#yay -S --noconfirm --needed vimix-gtk-themes-git
#yay -S --noconfirm --needed starlabstheme-gtk-git
echo "################################################################################"
echo "### Installation of GTK+ themes completed                                     ###"
echo "################################################################################"
sleep 2
