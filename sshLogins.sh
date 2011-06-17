############################################################################
# Copyright (C) 2008  Panagiotis Kritikakos <panoskrt@gmail.com>           #
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
month=`date +%b`
day=`date +%d`
if [ $day -lt 10 ]; then
  monthday=`printf "$month  ${day:1}"`
else
  monthday=`printf "$month $day"`
fi
hostname=`hostname`

echo "=====================" > logs
echo "= Successful logins =" >> logs
echo "=====================" >> logs
cat /var/lcfg/log/auth | grep -e "$monthday" | grep -e "authentication succeeds" \
-e "session opened" >> logs
echo "--------------------------------" >> logs
echo "================================" >> logs

printf "\n\n" >> auth_log

echo "==================" >> logs
echo "= Login failures =" >> logs
echo "==================" >> logs
cat /var/lcfg/log/auth | grep -e "$monthday" | grep -e "authentication failure" \
-e "Failed password" >> logs
echo "--------------------------------" >> logs
echo "================================" >> logs

/usr/bin/Mail -s "Logs for $hostname" foo@bar.com < logs
rm -f logs

