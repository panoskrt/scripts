#!/bin/bash

HOME=/home/<account>
DATE=`date +%d-%m-%Y`

DB_USER=<username>
DB_PASS="<password>"
DB_NAME=<database>

mkdir $HOME/backup/$DATE

cp -Rf $HOME/public_html $HOME/backup/$DATE/public_html
tar czf public_html.tar.gz $HOME/backup/$DATE/public_html
mv public_html.tar.gz $HOME/backup/$DATE/
rm -Rf $HOME/backup/$DATE/public_html

cp -Rf $HOME/mail $HOME/backup/$DATE/mail
tar czf mail.tar.gz $HOME/backup/$DATE/mail
mv mail.tar.gz $HOME/backup/$DATE/
rm -Rf $HOME/backup/$DATE/mail

mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $HOME/backup/$DATE/$DB_NAME.mysql
gzip -9 $HOME/backup/$DATE/$DB_NAME.mysql
rm -f $HOME/backup/$DATE/$DB_NAME.mysql

tar czf $HOME/backup/$DATE.tar.gz $HOME/backup/$DATE
rm -Rf $HOME/backup/$DATE
