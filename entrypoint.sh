#!/bin/bash

RESULT=0

# If the cert/key don't exist...
if [ ! -f "/var/lego/certificates/${DOMAIN}.crt" ] || [ ! -f "/var/lego/certificates/${DOMAIN}.key" ]; then
    # issue the certificate
    lego \
        --path="/var/lego" \
        --server="${LEGO_SERVER:=https://acme-v02.api.letsencrypt.org/directory}" \
        --email="${EMAIL}" \
        --domains=${DOMAIN} \
        --dns="${DNS_PROVIDER}" \
        --dns.resolvers="${DNS_RESOLVER:="8.8.8.8"}" \
        -a \
        run
    RESULT=$?
fi

# If the cert/key don't exist...
if [ ! -f "/var/lego/certificates/${DOMAIN2}.crt" ] || [ ! -f "/var/lego/certificates/${DOMAIN2}.key" ]; then
    # issue the certificate
    lego \
        --path="/var/lego" \
        --server="${LEGO_SERVER:=https://acme-v02.api.letsencrypt.org/directory}" \
        --email="${EMAIL}" \
        --domains=${DOMAIN2} \
        --dns="${DNS_PROVIDER}" \
        --dns.resolvers="${DNS_RESOLVER:="8.8.8.8"}" \
        -a \
        run
    RESULT=$?
fi

# If the cert/key don't exist...
if [ ! -f "/var/lego/certificates/${DOMAIN3}.crt" ] || [ ! -f "/var/lego/certificates/${DOMAIN3}.key" ]; then
    # issue the certificate
    lego \
        --path="/var/lego" \
        --server="${LEGO_SERVER:=https://acme-v02.api.letsencrypt.org/directory}" \
        --email="${EMAIL}" \
        --domains=${DOMAIN3} \
        --dns="${DNS_PROVIDER}" \
        --dns.resolvers="${DNS_RESOLVER:="8.8.8.8"}" \
        -a \
        run
    RESULT=$?
fi

# If the cert/key don't exist...
if [ ! -f "/var/lego/certificates/${DOMAIN4}.crt" ] || [ ! -f "/var/lego/certificates/${DOMAIN4}.key" ]; then
    # issue the certificate
    lego \
        --path="/var/lego" \
        --server="${LEGO_SERVER:=https://acme-v02.api.letsencrypt.org/directory}" \
        --email="${EMAIL}" \
        --domains=${DOMAIN4} \
        --dns="${DNS_PROVIDER}" \
        --dns.resolvers="${DNS_RESOLVER:="8.8.8.8"}" \
        -a \
        run
    RESULT=$?
fi

if [ $RESULT -eq 0 ]; then
  envsubst '${UPSTREAM_SERVER} ${DOMAIN} ${UPSTREAM_SERVER2} ${DOMAIN2} ${UPSTREAM_SERVER3} ${DOMAIN3} ${UPSTREAM_SERVER4} ${DOMAIN4}' < /config/nginx.conf > /etc/nginx/nginx.conf

  supervisord -c /supervisord.conf
fi
