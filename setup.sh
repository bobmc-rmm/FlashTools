#!/bin/sh
# Pixel phone flashing by GrapheneOS
# This script runs on Xubuntu which is based on Debian-Ubuntu Linux
# This script runs on Fedora

# edit PNAME phone nickname and firmware REVision
# before doing ./setup p1

PNAME="flame"
REV="2023080800"
PTOOLS="platform-tools_r34.0.4-linux"

# the following variables may change depending on Linux distro
# Debians, Ubuntu, and Mint use APT for installs
# Fedora38 uses DNF for installs
PREFIX=releases.grapheneos.org
IN_STALL="apt install"
RE_MOVE="apt remove"

# -----------------------------------------------------------
# Part 1 prepares the computer for the GrapheneOS flashing process
# The phone does not need to be connected yet
do_p1 ()
{
    sudo $IN_STALL git
    echo "...remove old adb and fastboot"
    sudo $RE_MOVE adb fastboot
    
    echo "...wget, curl, and bsdtar"
    sudo $IN_STALL wget curl  bsdtar
    
    echo "...get latest adb and fastboot"
    echo "...platform-tools_r34.0.4-linux.zip"
    curl -O https://dl.google.com/android/repository/$PTOOLS.zip
    bsdtar xvf $PTOOLS.zip
    rm $PTOOLS.zip
    
    echo "...add adbusers to my user profile"
    sudo groupadd adbusers
    myname=$(whoami)
    sudo usermod --append --groups adbusers $myname
    
    touch $HOME/.profile
    grep -q "android" $HOME/.profile
    if [ $? = 1 ]; then
	cp add_path.txt  $HOME/.profile
	echo "...added platform-tools directory to your PATH"
    else
	echo "...profile PATH already updated"
    fi
    
    echo "...get the latest udev rules"
    if [ -d android-udev-rules ]; then
	rm -rf android-udev-rules
    fi
    git clone https://github.com/M0Rf30/android-udev-rules.git
    cd android-udev-rules
    sudo cp -v 51-android.rules /etc/udev/rules.d/51-android.rules
    sudo chmod a+r /etc/udev/rules.d/51-android.rules
    
    $HOME/android/platform-tools/fastboot --version
    echo "..."
    echo "...Upgraded udev rules and added 'adbusers' group."
    echo "...Please restart your linux computer to realize new rules"
    echo "...and do part2 ..flashing the phone firmware."
    echo "..."
}	 

# -----------------------------------------------------------
# Part 2 is the GrapheneOS flashing process which is repeatable
# for several identical phones having the same firmware. Part 1
# is only done once for that use-case.
#
# The phone needs to be connected and in fastboot mode
do_p2 ()
{
    myvar="x"
    fastboot --version
    echo "...press <enter> for the following " 
    read -p "...start the phone fastboot mode " $myvar

    fastboot flashing unlock
    
    read -p "...press the phone buttons to confirm " $myvar
    
    echo "...flashing should be complete in about 3 minutes"
    echo "...many prints occur during the process"
    echo "...press control-c if fastboot becomes stuck"
    echo "..."
    echo "...downloading firmware files if not previously downloaded"
    
    if [ ! -f factory.pub ]; then
	echo "...factory.pub"
	curl -O https://$PREFIX/factory.pub
    fi
    
    if [ ! -f $PNAME-factory-$REV.zip ]; then
	echo "...factory 1 of 3"
	curl -O https://$PREFIX/$PNAME-factory-$REV.zip
    fi
    
    if [ ! -f $PNAME-factory-$REV.zip.sig ]; then
	echo "...factory 2 of 3"
	curl -O https://$PREFIX/$PNAME-factory-$REV.zip.sig
    fi
    
    if [ ! -f $PNAME-ota_update-$REV.zip.sig ]; then
	echo "...factory 3 of 3"
	curl -O https://$PREFIX/$PNAME-ota_update-$REV.zip.sig
    fi
    
    bsdtar xvf $PNAME-factory-$REV.zip
    cd $PNAME-factory-$REV
    
    ./flash-all.sh
    echo "...now the fastboot mode should be LOCKED again.."
    echo "...press enter to lock the fastboot, else press control-c"
    read -p "..lock the fastboot now "  $myvar
    fastboot flashing lock
}

do_other ()
{
    echo "...testing 123"
    read -p "...are you ready?"
    
}

########## select a procedure by command line ########
if [ "$1" = "p1" ]; then
   echo ".. do p1 .."
   do_p1
   exit 0
fi

if [ "$1" = "p2" ]; then
   echo ".. do p2 .."
   do_p2
   exit 0
fi

if [ "$1" = "other" ]; then
    echo ".. do other .."
    do_other
   exit 0
fi


# -----------------------------------------------------------

echo " 1. setup.sh p1"
echo " 2. setup.sh p2"
echo " 3. setup.sh other"
echo "bye...."

