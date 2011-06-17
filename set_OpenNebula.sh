############################################################################
# Copyright (C) 2011  Panagiotis Kritikakos <pkritika@epcc.ed.ac.uk>       #
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

#!/bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
 echo
 echo " This script will generate the appropriate leases for the Open Nebula Virtual
         Machines."
 echo " It will generate leases that for unused IPs that map to the bridged interface."
 echo
 echo " The default bridge interface is br0. If you want to change this, pass another
        interface as an argument."
  echo
  exit
fi

if [ "$1" == "" ]; then
  BRIDGE=br0
else
  BRIDGE=$1
fi

IPADDR=`ifconfig $BRIDGE | grep "inet addr" | awk {'print $2'} | sed s/addr:*//g`
BCAST=`ifconfig $BRIDGE | grep "inet addr" | awk {'print $3'} | sed s/Bcast:*//g`
MASK=`ifconfig $BRIDGE | grep "inet addr" | awk {'print $4'} | sed s/Mask:*//g`
if [ -e /etc/debian_version ]; then
  NETWORK=`ipcalc -n $IPADDR $MASK | grep Network | awk {'print $2'} | sed 's/\./ /g' \
| awk {'print $1"."$2"."$3'}`
else
  NETWORK=`ipcalc -n $IPADDR $MASK | sed s/NETWORK=*//g | sed 's/\./ /g' | \
awk {'print $1"."$2"."$3'}`
fi

IPOCT=`ifconfig $BRIDGE | grep "inet addr" | awk {'print $2'} | sed s/addr:*//g | \
sed 's/\./ /g' | awk {'print $4'}`
BCASTOCT=`ifconfig $BRIDGE | grep "inet addr" | awk {'print $3'} | sed s/Bcast:*//g | \
sed 's/\./ /g' | awk {'print $4'}`

hostMin=$(($IPOCT + 1))
hostMax=$(($BCASTOCT - 2))
totalIP=$(($hostMax - $hostMin))

echo
echo " $(($totalIP + 1)) IPs will be checked for availability.
       That might take some time..."
iter=1

ONNET_FILE=hpce2_network.net

printf 'NAME = "HPCE2"\n' > $ONNET_FILE
printf 'TYPE = FIXED\n\n' >> $ONNET_FILE
printf "BRIDGE = ${BRIDGE}\n" >> $ONNET_FILE
echo
for LEASE in `seq $hostMin $hostMax`
do
  echo -n $iter " "
  ping -c 1 ${NETWORK}.$LEASE -W 1 > /dev/null;
  if [ $? -ne 0 ]; then
    printf 'LEASES = [ IP=''"'$NETWORK.$LEASE'"''] \n' >> $ONNET_FILE
  fi
  let iter++
done
echo
echo

