#!/bin/bash

if [ -d "/var/lib/znc/.znc/configs/znc.conf" ]; then
    exec "$@"
    exit 0
fi

CONFIG_TEMPLATE_DIR="/usr/local/share/znc/templates"
CONFIG_DIR="/var/lib/znc/.znc"

ZNC_PORT=${ZNC_PORT:-1337}

ADMIN_USER=${ADMIN_USER:-"admin"}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-$(pwgen -1 12)}
ADMIN_PASSWORD_SALT=${ADMIN_PASSWORD_SALT:-$(pwgen -sn1 20)}
ADMIN_PASSWORD_HASH=$(echo -n ${ADMIN_PASSWORD}${ADMIN_PASSWORD_SALT} | sha256sum | sed 's/\W//g')
ADMIN_PASSWORD_STRING="sha256#${ADMIN_PASSWORD_HASH}#${ADMIN_PASSWORD_SALT}#"
ADMIN_PASSWORD_STRING_ESCAPED=$(echo -n ${ADMIN_PASSWORD_STRING} | sed -e 's/[\/&]/\\&/g')
ADMIN_NICK=${ADMIN_NICK:-"admin"}
ADMIN_ALTERNATIVE_NICK=${ADMIN_ALTERNATIVE_NICK:-"admin_"}
ADMIN_IDENT=${ADMIN_IDENT:-"admin"}
ADMIN_REAL_NAME=${ADMIN_REAL_NAME:-"Administrator"}

cp -r ${CONFIG_TEMPLATE_DIR}/* ${CONFIG_DIR}/
sed "s/{{ZNC_PORT}}/${ZNC_PORT}/" -i ${CONFIG_DIR}/configs/znc.conf
sed "s/{{ADMIN_USER}}/${ADMIN_USER}/" -i ${CONFIG_DIR}/configs/znc.conf
sed "s/{{ADMIN_PASSWORD}}/${ADMIN_PASSWORD_STRING_ESCAPED}/" -i ${CONFIG_DIR}/configs/znc.conf
sed "s/{{ADMIN_NICK}}/${ADMIN_NICK}/" -i ${CONFIG_DIR}/configs/znc.conf
sed "s/{{ADMIN_ALTERNATIVE_NICK}}/${ADMIN_ALTERNATIVE_NICK}/" -i ${CONFIG_DIR}/configs/znc.conf
sed "s/{{ADMIN_IDENT}}/${ADMIN_IDENT}/" -i ${CONFIG_DIR}/configs/znc.conf
sed "s/{{ADMIN_REAL_NAME}}/${ADMIN_REAL_NAME}/" -i ${CONFIG_DIR}/configs/znc.conf

znc --makepem

echo "####################################"
echo "### znc admin:"
echo "### user: ${ADMIN_USER}"
echo "### password: ${ADMIN_PASSWORD}"
echo "### hash: ${ADMIN_PASSWORD_STRING}"
echo "####################################"

exec "$@"
