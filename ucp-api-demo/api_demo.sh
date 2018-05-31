#!/bin/bash

# Note: set env with UCP client bundle before running this program
# if you are on Mac, please follow https://stackoverflow.com/questions/40712352/curl-error-58-ssl-cant-load-the-certificate-and-its-private-key-osstat to use curl with openssl support

CURL=/usr/local/opt/curl/bin/curl # installed by brew

if [ -z ${DOCKER_CERT_PATH} -o -z ${DOCKER_HOST} ]; then
  echo "Error: Please set env with UCP client bundle before running this program"
  echo "Exit."
  exit 1
fi

URL="${DOCKER_HOST/tcp/https}"

${CURL} -s \
     --cert ${DOCKER_CERT_PATH}/cert.pem \
     --key ${DOCKER_CERT_PATH}/key.pem \
     --cacert ${DOCKER_CERT_PATH}/ca.pem \
     ${URL}/"$@"

# example: "$0 api/banner"
