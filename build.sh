#!/usr/bin/env sh

if [ $# -eq 0 ]; then
  echo "[build.sh] Compiling ngrok with default certificates"
else 
  echo "[build.sh] Compiling ngrok with ngrokroot.crt from $1"
  SSLDIR="$(cd "$1" && pwd)"
fi

DIR="$(pwd)/build"
HOSTUID=$(id -u)
HOSTGID=$(id -g)

rm -rf "$DIR" && mkdir "$DIR"
[ $? -ne 0 ] && exit 1

cat > "${DIR}/build.sh" <<EOT
git clone https://github.com/inconshreveable/ngrok.git ngrok
cd ngrok

make clean >/dev/null 2>&1
[ -f /ssl/ngrokroot.crt ] && cp /ssl/ngrokroot.crt assets/client/tls/ngrokroot.crt
CGO_ENABLED=0 GOOS=linux make

cp bin/ngrok* /build
mkdir -p /build/assets/client
cp -r assets/client/tls /build/assets/client

chown -R ${HOSTUID}:${HOSTGID} /build
EOT

if [ -z $SSLDIR ]; then
  docker run \
    --rm \
    -v "${DIR}:/build" \
    tsertkov/builder
else
  docker run \
    --rm \
    -v "${DIR}:/build" \
    -v "${SSLDIR}:/ssl" \
    tsertkov/builder
fi

docker build \
  -f ngrokd.Dockerfile \
  -t tsertkov/ngrokd \
  .

docker build \
  -f ngrok.Dockerfile \
  -t tsertkov/ngrok \
  .
