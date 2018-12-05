#!/bin/bash
#AlienVault OTX Data And API information restore
#This script must be run onffline ossim device
#Fatih USTA <fatihusta@labrisnetworks.com>

OSSIMIP=$1

GZFILE=alienvault_otx_dump.tar.gz

TMP_DIR=/tmp/otx_tmp

if [ -z "${OSSIMIP}" ];then
    echo "Please give me Online OSSIM IP with arg"
    echo "Ex: 10.10.10.10"
    exit 1
fi

OSSIMURL="https://${OSSIMIP}"

MYSQL_HOST=$(grep "^db_ip" /etc/ossim/ossim_setup.conf|cut -d"=" -f 2)
MYSQL_USER=$(grep "^user" /etc/ossim/ossim_setup.conf|cut -d"=" -f 2)
MYSQL_PASSWORD=$(grep "^pass" /etc/ossim/ossim_setup.conf|cut -d"=" -f 2)
MYSQL_DATABASE=alienvault

ENC_KEY=$(grep '^key=' /etc/ossim/framework/db_encryption_key|cut -d"=" -f2)

_mysql=/usr/bin/mysql
_tar=/bin/tar
_wget=/usr/bin/wget
_cp=/bin/cp
_mkdir=/bin/mkdir
_rm=/bin/rm
_chown=/bin/chown

MYSQL_COMMAND="$_mysql -sN --host=${MYSQL_HOST} --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} ${MYSQL_DATABASE}"


executeQuery() {
    ${MYSQL_COMMAND} <<< $1 2> /dev/null
}

$_mkdir -p ${TMP_DIR}
$_rm -f ${TMP_DIR}/{appendonly-otx.aof,dump-otx.rdb,alienvault_otx_vars.txt}

$_wget --no-check-certificate --timeout=10 -cqO - ${OSSIMURL}/${GZFILE} | $_tar -xz -C ${TMP_DIR} && \
/etc/init.d/alienvault-redis-server-otx stop &>/dev/null || exit 1

$_rm -f /var/lib/redis/{appendonly-otx.aof,dump-otx.rdb,alienvault_otx_vars.txt} 
$_cp ${TMP_DIR}/{appendonly-otx.aof,dump-otx.rdb,alienvault_otx_vars.txt} /var/lib/redis/
$_chown redis.alienvault /var/lib/redis/{appendonly-otx.aof,dump-otx.rdb}
/etc/init.d/alienvault-redis-server-otx start &>/dev/null

#Load VARS
source /var/lib/redis/alienvault_otx_vars.txt

executeQuery "update config SET value=(AES_ENCRYPT('${API_KEY}', '${ENC_KEY}')) where conf='open_threat_exchange_key';"
executeQuery "update config SET value='${ENC_KEY}' where conf='encryption_key';"
executeQuery "update config SET value='${LOWERKEY}' where conf='server_id';"
executeQuery "update config SET value='${KEY_VER}' where conf='open_threat_exchange_key_version';"
executeQuery "update config SET value='${OTX_USER}' where conf='open_threat_exchange_username';"
executeQuery "update config SET value='${OTX_USER_ID}' where conf='open_threat_exchange_user_id';"

executeQuery "update config SET value='no' where conf='open_threat_exchange';"


exit 0
