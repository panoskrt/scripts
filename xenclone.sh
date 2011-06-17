#!/bin/bash
############################################################################
# Copyright (C) 2009  Panagiotis Kritikakos <pkritika@epcc.ed.ac.uk>       #
#                                                                          #
#    This program is free software: you can redistribute it and/or modify  #
#    it under the terms of the GNU General Public License as published by  #
#    the Free Software Foundation, either version 3 of the License, or     #
#    (at your option) any later version.                                   #
#                                                                          #
#    This program is distributed in the hope that it will be useful,       #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#    GNU General Public License for more details.                          #
#                                                                          #
#    You should have received a copy of the GNU General Public License     #
#    along with this program.  If not, see <http://www.gnu.org/licenses/>. #
############################################################################
if [ $UID != "0" ]; then
  echo " You must be root to run the script or run it with sudo"
  exit 1;
fi
if [ $# -lt 3 ]; then
  echo " Usage: ./xenclone <disk images dir> <disk name> <clone name> <vm type>"
  echo " The script assumes the guest being clone is a Red Hat based system"
  exit 1;
fi
DISKPATH=$1
DISK=$2
CLONE=$3
MOUNTDIR=`mktemp -d`
if [ ! -e $DISKPATH/$DISK.img ]; then
  echo " Primary disk image can't be found."
  exit 1;
fi
clear

TEMPF1=`mktemp`
TEMPF2=`mktemp`
TEMPF3=`mktemp`
TEMPHOSTS=`mktemp`
TEMPNETWORK=`mktemp`
TEMPIFCFG=`mktemp`

echo "Copying ${DISK} to ${CLONE}..."
dd if=$DISKPATH/$DISK.img of=$DISKPATH/$CLONE.img

echo "Mapping the image..."
loopPart=`kpartx -l $DISKPATH/$CLONE.img | awk {'print $1'}`
kpartx -a $DISKPATH/$CLONE.img

echo "Mounting the image..."
mount /dev/mapper/$loopPart $MOUNTDIR

echo "Editing files and creating configuration file for ${CLONE}..."
sed "s/$DISK/$CLONE/g" < $MOUNTDIR/etc/hosts > $TEMPHOSTS
cp -f $TEMPHOSTS $MOUNTDIR/etc/hosts
sed "s/$DISK/$CLONE/g" < $MOUNTDIR/etc/sysconfig/network > $TEMPNETWORK
cp -f $TEMPNETWORK $MOUNTDIR/etc/sysconfig/network

sed "s/$DISK/$CLONE/g" < /etc/xen/$DISK > $TEMPF1
olduuid=`grep uuid $TEMPF1 | awk {'print $3'} |  sed s/'"'*'"'//g`
newuuid=`uuidgen`
sed "s/$olduuid/$newuuid/g" < $TEMPF1 > $TEMPF2
oldmac=`grep mac $TEMPF2 | sed s/vif.*mac=//g | sed s/,.*']'//g`
newmac=`echo $RANDOM | openssl md5 | sed 's/\(..\)/\1:/g' | cut -b1-17`
oldhwaddr=`grep HWADDR $MOUNTDIR/etc/sysconfig/network-scripts/ifcfg-eth0 | sed s/HWADDR.*=//g`
sed "s/$oldmac/$newmac/g" < $TEMPF2 > $TEMPF3
cp -f $TEMPF3 /etc/xen/$CLONE
sed "s/$oldhwaddr/$newmac/g" < $MOUNTDIR/etc/sysconfig/network-scripts/ifcfg-eth0 > $TEMPIFCFG
cp -f $TEMPIFCFG $MOUNTDIR/etc/sysconfig/network-scripts/ifcfg-eth0

echo "Removing temporary files..."
rm -f $TEMPF1 $TEMPF2 $TEMPF3 $TEMPHOSTS $TEMPNETWORK $TEMPIFCFG

echo "Unmounting the image..."
umount /dev/mapper/$loopPart

echo "Unmapping the image..."
kpartx -d $DISKPATH/$CLONE.img

echo "Cloning of ${DISK} to ${CLONE} finished."
