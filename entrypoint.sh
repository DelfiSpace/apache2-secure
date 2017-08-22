#!/bin/bash

if [ ! -e "/etc/apache2/external/cert.pem" ] || [ ! -e "/etc/apache2/external/key.pem" ]
then
  echo ">> generating self signed cert"
  openssl req -x509 -newkey rsa:4096 \
  -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=localhost" \
  -keyout "/etc/apache2/external/key.pem" \
  -out "/etc/apache2/external/cert.pem" \
  -days 3650 -nodes -sha256
fi

echo ">> copy /etc/apache2/external/*.conf files to /etc/apache2/sites-enabled/"
cp /etc/apache2/external/*.conf /etc/apache2/sites-enabled/ 2> /dev/null > /dev/null

# exec CMD
echo ">> exec docker CMD"
echo "$@"
exec "$@"

