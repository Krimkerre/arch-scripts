#!/bin/bash
###############################################################################
### Installing Arch Software By:                                            ###
### Erik Sundquist                                                          ###
###############################################################################
### Review and edit before using                                            ###
###############################################################################

set -e
clear
echo "################################################################################"
echo "### Installing Gnome Extensions                                              ###"
echo "################################################################################"
sleep 2
yay -S --noconfirm --needed --asdeps gnome-shell-extension-dash-to-dock
yay -S --noconfirm --needed --asdeps gnome-shell-extension-dash-to-panel-git
yay -S --noconfirm --needed --asdeps gnome-shell-extension-workspaces-to-dock
yay -S --noconfirm --needed --asdeps gnome-shell-extension-arc-menu-git
yay -S --noconfirm --needed --asdeps gnome-shell-extension-openweather-git
yay -S --noconfirm --needed --asdeps gnome-shell-extension-topicons-plus-git
yay -S --noconfirm --needed --asdeps gnome-shell-extension-audio-output-switcher-git
yay -S --noconfirm --needed --asdeps gnome-shell-extension-clipboard-indicator-git
yay -S --noconfirm --needed --asdeps gnome-shell-extension-coverflow-alt-tab-git
yay -S --noconfirm --needed --asdeps gnome-shell-extension-animation-tweaks-git
yay -S --noconfirm --needed --asdeps gnome-shell-extension-gamemode-git
#yay -S --noconfirm --needed --asdeps gnome-shell-extension-vitals
#yay -S --noconfirm --needed --asdeps gnome-shell-extension-drop-down-terminal-x
#yay -S --noconfirm --needed --asdeps gnome-shell-extension-dynamic-battery
#yay -S --noconfirm --needed --asdeps gnome-shell-extension-material-shell-git
#yay -S --noconfirm --needed --asdeps gnome-shell-extension-panel-osd
#yay -S --noconfirm --needed --asdeps gnome-shell-extension-slinger-git
#yay -S --noconfirm --needed --asdeps gnome-shell-extension-transparent-window-moving-git
#yay -S --noconfirm --needed --asdeps gnome-shell-extension-transparent-osd-git
#yay -S --noconfirm --needed --asdeps gnome-shell-extension-window-animations-git
#yay -S --noconfirm --needed --asdeps gnome-shell-extension-impatience-git
#yay -S --noconfirm --needed --asdeps gnome-appfolders-manager
echo "################################################################################"
echo "### Installation of Gnome extensions completed                               ###"
echo "################################################################################"
sleep 2
