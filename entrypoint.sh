#!/bin/sh

RESULT=0

# If the cert/key don't exist...
if [ ! -f "/var/lego/certificates/${DOMAIN}.crt" ] || [ ! -f "/var/lego/certificates/${DOMAIN}.key" ]; then
    # issue the certificate
    lego \
        --path="/var/lego" \
        --server="${LEGO_SERVER:=https://acme-v01.api.letsencrypt.org/directory}" \
        --email="${EMAIL}" \
        --domains=${DOMAIN} \
        --dns="${DNS_PROVIDER}" \
        -a \
        run
    RESULT=$?
fi

if [ $RESULT -eq 0 ]; then
  PUID=${PUID:-911}
  PGID=${PGID:-911}

  groupmod -o -g "$PGID" abc
  usermod -o -u "$PUID" abc

  chown abc:abc /config
  chown abc:abc /var/lib/nginx
  chown -R abc:abc /var/lib/nginx/tmp
  envsubst '${UPSTREAM_SERVER} ${DOMAIN}' < /config/nginx.conf > /etc/nginx/nginx.conf

  supervisord -c /supervisord.conf
fi

