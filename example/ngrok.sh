#!/usr/bin/env sh

source ./config/config.vars

CONFIG=$(cat <<EOT
server_addr: $DOMAIN:4443
trust_root_certs: false
EOT
)

echo "$CONFIG" > "${CFGDIR}/ngrok.yml"

exec docker run \
  --rm -ti \
  -v "${CFGDIR}:/data" \
  tsertkov/ngrok \
    -config /data/ngrok.yml 80
