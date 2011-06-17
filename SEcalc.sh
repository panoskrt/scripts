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

if [ "$#" -eq "3" ]; then
   runtime1proc=$1
   runtimeNproc=$2
   totalprocs=$3
   speedup=`echo "${runtime1proc}/${runtimeNproc}" | bc -l`;
   efficiency=`echo "${speedup}/${totalprocs}" | bc -l`;

   printf "\n Total processors: ${totalprocs}\n\n";
   printf " Runtime for serial code: ${runtime1proc}\n Runtime for parallel code: \
   ${runtimeNproc}\n\n";
   printf " Speedup: ${speedup}\n Efficiency: ${efficiency}\n\n";
else
   printf "\n Usage: SEcalc.sh   \n\n";
   printf " SEcalc.sh 0.350 0.494 2\n\n";
fi
