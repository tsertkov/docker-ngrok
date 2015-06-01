#!/usr/bin/env sh

source ./config/config.vars

exec docker run \
  --rm \
  -p 80:80 \
  -p 443:443 \
  -p 4443:4443 \
  -v "${CFGDIR}:/data" \
  tsertkov/ngrokd \
    -domain="$DOMAIN" \
    -tlsCrt="/data/${DOMAIN}.crt" \
    -tlsKey="/data/${DOMAIN}.key"
