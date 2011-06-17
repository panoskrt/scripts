############################################################################
# Copyright (C) 2011  Panagiotis Kritikakos <panoskrt@gmail.com>           #
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

option=$1
logfile=$2
code=$3

getAvg(){
  totalwatts=`cat ${logfile} | awk '{total = total + $1}END{print total}'`
  elements=`cat  ${logfile} | wc -l`
  avgwatts=`expr ${totalwatts} / ${elements}`

  printf "\n\n Average watts: ${avgwatts}\n\n"
}

if [ "${option}" == "average" ]; then
   getAvg
   exit 0
fi

if [ $# -lt 3 ] || [ $# -gt 3 ]; then
  echo " Specify logfile and code"
  exit 1
fi

if [ -e ${logfile} ]; then rm -f ${logfile}; fi

codeis=`ps aux | grep ${code} | grep -v grep | wc -l`

while [ ${codeis} -gt 0 ]; do

  sudo /usr/sbin/ipmi-sensors | grep -w "System Level" | awk {'print $5'} | \
  awk ' sub("\\.*0+$","") ' >> ${logfile}
  sleep 1
  codeis=`ps aux | grep ${code} | grep -v grep | wc -l`

done

getAvg

