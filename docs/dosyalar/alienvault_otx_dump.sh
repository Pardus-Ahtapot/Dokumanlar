#!/bin/bash
#AlienVault OTX Data And API information dump
#This script must be run online ossim device
#Fatih USTA <fatihusta@labrisnetworks.com>

GZFILE=alienvault_otx_dump.tar.gz

MYSQL_HOST=$(grep "^db_ip" /etc/ossim/ossim_setup.conf|cut -d"=" -f 2)
MYSQL_USER=$(grep "^user" /etc/ossim/ossim_setup.conf|cut -d"=" -f 2)
MYSQL_PASSWORD=$(grep "^pass" /etc/ossim/ossim_setup.conf|cut -d"=" -f 2)
MYSQL_DATABASE=alienvault

ENC_KEY=$(grep '^key=' /etc/ossim/framework/db_encryption_key|cut -d"=" -f2)

_mysql=/usr/bin/mysql
_tar=/bin/tar

MYSQL_COMMAND="$_mysql -sN --host=${MYSQL_HOST} --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} ${MYSQL_DATABASE}"


executeQuery() {
    ${MYSQL_COMMAND} <<< $1 2> /dev/null
}

API_KEY=$(executeQuery "select AES_DECRYPT(value, '${ENC_KEY}') from config where conf = 'open_threat_exchange_key';")
LAST_UPDATE=$(executeQuery "select value from config where conf='open_threat_exchange_latest_update';")
KEY_VER=$(executeQuery "select value from config where conf='open_threat_exchange_key_version';")
OTX_USER=$(executeQuery "select value from config where conf='open_threat_exchange_username';")
OTX_USER_ID=$(executeQuery "select value from config where conf='open_threat_exchange_user_id';")

echo -e "API_KEY=${API_KEY}\nLAST_UPDATE=\"${LAST_UPDATE}\"\nKEY_VER=${KEY_VER}\nOTX_USER=${OTX_USER}\nOTX_USER_ID=${OTX_USER_ID}" > /var/lib/redis/alienvault_otx_vars.txt

/etc/init.d/alienvault-redis-server-otx stop &>/dev/null && \
$_tar -czf /var/www/${GZFILE} -C /var/lib/redis appendonly-otx.aof dump-otx.rdb alienvault_otx_vars.txt && \
/etc/init.d/alienvault-redis-server-otx start &>/dev/null

exit 0
