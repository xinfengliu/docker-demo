#!/bin/bash

# Note: this script uses local file/dir bind mount, so do not run it with UCP client bundle, otherwise would hit errors.
cd "$(dirname "$0")"
docker run  -d --name ng -p 9000:80 -p 9443:443 \
  -v "$PWD/html":/usr/share/nginx/html:ro \
  -v "$PWD/logs":/var/log/nginx \
  -v "$PWD/nginx.crt":/run/secrets/nginx.crt:ro \
  -v "$PWD/nginx.key":/run/secrets/nginx.key:ro \
  xinfengliu/nginx:stable-alpine-tls
