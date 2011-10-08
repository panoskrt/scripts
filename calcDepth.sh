###########################################################################
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
MSW=10.0584
MFW=10.3632
SSDSW=5
ALT=$1
Da=$2

disclaimer()
{
echo "
=======================================================
Every individual diver is responsible for planning 
and conducting dives using SCUBA equipment up to the 
trained and certified qualification he or she holds.

The creator of this program does not have any 
responsibility for symptoms of Decompressions Sickness 
when the suggested values of this program are used 
for conducting a dive.
========================================================
"
}

if [ -z $ALT ] || [ -z $Da ]; then
  echo " Specify altitude and depth: ./calcDepth.sh 1350 24"
  exit 1
else
  clear
  Pa=`echo "100-(0.01*$ALT)" | bc`

  TOD=`echo "scale=5; ($Da*(1/$Pa)*($MSW/$MFW))*100" | bc`
  SSDA=`echo "scale=2; ($SSDSW*($Pa/1)*($MFW/$MSW))/100" | bc`

  PAatm=`echo "scale=2; $Pa/100" | bc`

  N1=`echo "scale=2; 100*(1.2/(($TOD/10)+1))" | bc`
  N2=`echo "scale=2; 100*(1.4/(($TOD/10)+1))" | bc`
  N3=`echo "scale=2; 100*(1.6/(($TOD/10)+1))" | bc`
  
  echo  
  disclaimer
  echo

  printf "Altitude: \t$ALT m\n"
  printf "Depth: \t\t$Da mfw\n"
  printf "Pressure: \t$PAatm atm\n"
  printf "TOD: \t\t$TOD msw\n"
  printf "Safety Stop: \t$SSDA mfw\n\n"
  printf "Best NITROX mix with 1.2 PO2: $N1\n"
  printf "Best NITROX mix with 1.4 PO2: $N2\n"
  printf "Best NITROX mix with 1.6 PO2: $N3\n\n"
  exit 0
fi
