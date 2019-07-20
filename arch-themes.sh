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
echo "Installing GTK Themes..........................."
echo "################################################################################"

sleep 2

sudo pacman -S --noconfirm --needed --asdeps adapta-gtk-theme
sudo pacman -S --noconfirm --needed --asdeps arc-gtk-theme
sudo pacman -S --noconfirm --needed --asdeps arc-solid-gtk-theme
sudo pacman -S --noconfirm --needed --asdeps breeze-gtk
sudo pacman -S --noconfirm --needed --asdeps deepin-gtk-theme
sudo pacman -S --noconfirm --needed --asdeps materia-gtk-theme
sudo pacman -S --noconfirm --needed --asdeps numix-gtk-theme
sudo pacman -S --noconfirm --needed --asdeps oxygen-gtk2

yay -S --noconfirm --needed --asdeps flat-remix-gtk
yay -S --noconfirm --needed --asdeps vimix-gtk-themes-git
yay -S --noconfirm --needed --asdeps windows10-gtk-theme-git windows10-dark-gtk-theme-git
yay -S --noconfirm --needed --asdeps abrus-gtk-theme-git
yay -S --noconfirm --needed --asdeps pop-gtk-theme-git pop-shell-theme-git
yay -S --noconfirm --needed --asdeps paper-gtk-theme-git
yay -S --noconfirm --needed --asdeps ant-nebula-gtk-theme
yay -S --noconfirm --needed --asdeps chicago95-gtk-theme-git
yay -S --noconfirm --needed --asdeps canta-gtk-theme
yay -S --noconfirm --needed --asdeps pro-dark-gtk-theme-git
