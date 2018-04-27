openssl req \
  -new \
  -newkey rsa:4096 \
  -days 3650 \
  -nodes \
  -x509 \
  -subj "/C=CN/ST=Shanghai/L=SH/O=Docker-demo/CN=web.example.org" \
  -keyout nginx.key \
  -out nginx.crt
