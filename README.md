# arch-scripts
A collection of my Arch scripts  **** REMOVED RASPI4 VERSIONS (for now) ****

They are constantly being updated right now and are mainly for me, but you can use/change them at will.  If you find better or have any suggestions please let me know.

If you would like to help make this script better or have any suggestions please let me know, I am new at doing this so I am willing to listen and learn.

****** WARNING *****
If you run the install script it will completely format your drive defined in the base.sh file.  Please edit that file and be careful to know what you are doing or have that drive you want to install to installed only.
***************************************************************************************************************************

********************************* NEWS ****************************
I have removed the RasPi4 support do to the way they install.
I am currently re-working both scripts to add and make more sense of them for when you have to edit or want to look at them.
*******************************************************************

To use this script do the following:
Boot from Arch ISO
Type: wget http://raw.githubusercontent.com/lotw69/arch-scripts/master/base.sh  (if wget fails, pacman -Sy, then pacman -S wget)
Type: chmod +x *.sh
Type: ./base.sh
Follow instructions, when completed it will copy the setup.sh automatically to the user directory
Reboot
Log in as user
Type: ./complete.sh
Follow instructions and answer which Desktop Enviroment you want installed, etc.
Reboot and enjoy...
