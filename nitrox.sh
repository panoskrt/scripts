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

mod(){
   echo -n "NITROX mix: "; read mix
   MOD=`echo "scale=2; (((1.6/$mix)*10)*100)-10" | bc`
   echo " MOD for $mix NITROX: $MOD"
}

od(){
   echo -n "NITROX mix: "; read mix
   OD=`echo "scale=3; (((1.4/$mix)*10)*100)-10" | bc`
   echo " OD for $mix NITROX: $OD"
}

bestmix(){
   echo -n " Depth: "; read depth
   BESTMIX4=`echo "scale=2; 1.4/(($depth/10)+1)" | bc`
   BESTMIX6=`echo "scale=2; 1.6/(($depth/10)+1)" | bc`
   echo " Best mix for 1.4 PO2: $BESTMIX4"
   echo " Best mix for 1.6 PO2: $BESTMIX6"
}

ead(){
   echo -n " Depth: "; read depth
   echo -n " NITROX: "; read nitrox
   EAD=`echo "scale=2; ((((1-($nitrox/100))*4)/0.79)-1)*10" | bc`
   echo " EAD for $depth MSW and NITROX $nitrox: $EAD"
}

compare(){
   echo -n " NITROX: "; read nitrox
   EQU=`echo "scale=2; 100-(((1-($nitrox/100))/0.79)*100)" | bc`
   echo " ${EQU}% less nitrogen"
}

po2(){
   echo -n " Depth: "; read depth
   echo -n " NITROX: "; read nitrox
   PO2=`echo "scale=2; (($depth+10)/10)*($nitrox/100)" | bc`
   echo " PO2 at $depth MSW for NITROX $nitrox: $PO2 ATM"
}

cns(){
   echo -n " PO2 [1.4, 1.5, 1.6]: "; read po2
   echo -n " Duration: "; read duration
   if [ "$po2" == "1.4" ]; then
      CNS=`echo "scale=2; ($duration/150)*100" | bc`
   elif [ "$po2" == "1.5" ]; then
      CNS=`echo "scale=2; ($duration/120)*100" | bc`
   elif [ "$po2" == "1.6" ]; then
      CNS=`echo "scale=2; ($duration/45)*100" | bc`
   else
      echo " Choose between 1.4, 1.5 and 1.6 PO2"
      exit 1
   fi  
   echo " CNS for $duration minutes and $po2 PO2: ${CNS}%"
}

absolute(){
   echo -n " Depth: "; read depth
   ABS=`echo "scale=2; (($depth/10)+1)" | bc`
   echo " Absolute pressure at depth of $depth MSW: $ABS ATM"
}

disclaimer

echo " 1 - Maximum Operational Depth (MOD)"
echo " 2 - Operational Depth (OD)"
echo " 3 - Best mix"
echo " 4 - Equivelant Air Depth (EAD)"
echo " 5 - Nitrogen percentage compared to Air"
echo " 6 - Oxygen partial pressure (PO2)"
echo " 7 - Central Nervous Systems Toxicity (CNS)"
echo " 8 - Absolute pressure"
echo
echo -n " Function: "; read option

case "$option" in
	1)
	  mod
	  ;;
	2)
	  od
	  ;;
	3)
	  bestmix
	  ;;
	4)
	  ead
	  ;;
	5)
	  compare
	  ;;
	6)
	  po2
	  ;;
	7)
	  cns
	  ;;
	8)
	  absolute
	  ;;
	*)
	  echo " Please choose a valid option from the menu"
	  exit 1
esac
