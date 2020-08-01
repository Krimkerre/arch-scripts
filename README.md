# arch-scripts
A collection of my Arch scripts  **** NOW WITH RASPBERRY PI4 ****

They are constantly being updated right now and are mainly for me, but you can use/change them at will.  If you find better or have any suggestions please let me know.

****** WARNING *****
If you run the install script it will completely format your drive defined in the installer.sh file.  Please edit that file and be careful to know what you are doing or have that drive you want to install to installed only.
***************************************************************************************************************************

To use this script do the following:
Boot from Arch ISO
Type: wget http://raw.githubusrcontent.com/lotw69/arch-scripts/master/installer.sh  (if wget fails, pacman -Sy, then pacman -S wget)
Type: chmod +x *.sh
Type: ./installer.sh
Follow instructions, when completed it will copy the setup.sh automatically to the user directory
Reboot
Log in as user
Type: ./setup.sh
Follow instructions and answer which Desktop Enviroment you want installed, etc.
Reboot and enjoy...
