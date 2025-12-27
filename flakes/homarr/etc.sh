#!/bin/bash
folder="/etc/homarr/"
file="homarr.env"
user=`whoami`
if [ ! -d $folder ]
then 
  sudo mkdir -p $folder
  sudo chown $user $folder
fi
if [ ! -f $folder$file ]
then
  sudo cp ./.env.example $folder$file
  sudo chmod ug+w $folder$file
  sudo chown $user $folder$file
  sed -i 's|FULL_PATH_TO_YOUR_SQLITE_DB_FILE|/etc/homarr/homarr.sqlite3|' $folder$file
  RAND=`openssl rand -hex 32`
  sed -i "s|0000000000000000000000000000000000000000000000000000000000000000|$RAND|" $folder$file
  RAND=`openssl rand -hex 32`
  sed -i "s|supersecret|$RAND|" $folder$file
  RAND=`openssl rand -base64 32`
  sed -i "s|your-generated-api-key|$RAND|" $folder$file
fi
echo $folder$file
file="homarr.sqlite3"
if [ ! -f $folder$file ]
then
  touch $folder$file
fi