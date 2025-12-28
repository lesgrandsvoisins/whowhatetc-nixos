#!/bin/sh
mkdir -p /etc/homarr
mkdir -p /var/cache/homarr
mkdir -p /var/lib/homarr
if [ ! -f /etc/homarr/homarr.env ]
  cp $(dirname $(dirname $0))/homarr.env /etc/homarr/homarr.env
fi
sed -i "s/@SECRET_API_KEY@/${`openssl rand -base64 32`}/" 
sed -i "s/@SECRET_ENCRYPTION_KEY@/${`openssl rand -hex 32`}/" 
sed -i "s/@SECRET_AUTH@/${`openssl rand -hex 32`}/" 
sed -i "s/@DB_DRIVER@/better-sqlite3/" 
sed -i "s/@DB_URL@/\/var\/lib\/homarr\/homarr.sqlite3/" 
if [ ! -f /var/lib/homarr/homarr.sqlite3 ]
  touch /var/lib/homarr/homarr.sqlite3
fi