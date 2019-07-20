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
echo "Installing Complete Packages..........................."
echo "################################################################################"

sleep 2

rm *.txt
rm arch-lamp.sh

./arch-install.sh
rm arch-install.sh

./arch-cursor.sh
rm arch-cursor.sh

./arch-fonts.sh
rm arch-fonts.sh

#if using Gnome then uncomment the following two lines
#./arch-gnext.sh
#rm arch-gnext.sh

./arch-icons.sh
rm arch-icons.sh

./arch-sound.sh
rm arch-sound.sh

./arch-themes.sh
rm arch-themes.sh

./arch-software.sh
rm arch-software.sh
