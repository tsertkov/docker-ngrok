#!/usr/bin/env sh

source ./config/config.vars

CACRT="${CFGDIR}/ngrokroot.crt"
CAKEY="${CFGDIR}/ngrokroot.key"
CRT="${CFGDIR}/${DOMAIN}.crt"
CSR="${CFGDIR}/${DOMAIN}.csr"
KEY="${CFGDIR}/${DOMAIN}.key"

openssl genrsa -out "$CAKEY" 2048
openssl req -x509 -new -nodes -key "$CAKEY" -subj "/CN=${DOMAIN}" -days 365 -out "$CACRT"
openssl genrsa -out "$KEY" 2048
openssl req -new -key "$KEY" -subj "/CN=${DOMAIN}" -out "$CSR"
openssl x509 -req -in "$CSR" -CA "$CACRT" -CAkey "$CAKEY" -CAcreateserial -out "$CRT" -days 365

rm -f "$CAKEY" "$CSR" "${CFGDIR}/ngrokroot.srl"
