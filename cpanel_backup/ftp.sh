#! /bin/sh

HOST=<server>
FILE=`date +%d-%m-%Y`.tar.gz
LCD=<local directory to save file>

#BEGIN
ftp <<**
open $HOST
cd backup
bin
get $FILE
delete $FILE
bye
**
#END
echo ftp transfer completed.
