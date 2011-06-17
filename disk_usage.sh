############################################################################
# Copyright (C) 2009  Panagiotis Kritikakos <panoskrt@gmail.com>           #
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
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage ./disk_usage <percentage>";
  echo " Example: ./disk_usage 50";
  exit;
fi
space=(`df -h | awk '{sub(/%/,"");print $5}' | grep -v / | grep -v Use | grep -v ^$`)
spaceLen=${#space[*]}

i=0
echo "The disks bellow use more than ${1}% of their space" > /tmp/diskSpace
echo "-----------------------------------------------------" >> /tmp/diskSpace
while [ $i -lt $spaceLen ]; do
   checkval=${space[$i]}
   if [ $checkval -gt $1 ] || [ $checkval -eq $1 ]; then
        df -h | grep $checkval | awk '{print $1 "\t" $5 "\t" $6}' >> /tmp/diskSpace
   fi
        let i++
done
/usr/bin/Mail -s "Disk space usage" foo@bar.com < /tmp/diskSpace
rm -f /tmp/diskSpace

