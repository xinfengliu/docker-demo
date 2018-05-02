# use GET method or use browser to get the cache ID: https://192.168.105.74/api/v0/content_caches
ID=$1
curl -u admin:admin123 -X DELETE -k -H "Content-Type: application/json" https://192.168.105.74/api/v0/content_caches/${ID}
