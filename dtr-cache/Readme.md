## demo DTR cache using NFS datastore

See https://docs.docker.com/ee/dtr/admin/configure/deploy-caches/simple/ for detailed steps.

### Prerequisites:
- Set up a NFS server for storing data of DTR cache
- Run [create-ca-certs.sh](https://github.com/xinfengliu/docker-demo/blob/master/dtr-cache/certs/create-ca-certs.sh) to generate ca/cert/key files for dtr cache server
- Run [get-dtr-ca.sh](https://github.com/xinfengliu/docker-demo/blob/master/dtr-cache/certs/get-dtr-ca.sh) to download DTR cert.
- Use UCP client bundle to set up your Docker client environment before deploying `docker-stack.yml`

### After deploying the stack
- Run `register-cache-with-dtr.sh`
- On DTR web UI, in the user's account setting, change to use the cache.

### Setup your `docker pull` client.
First, you need to make your client trust DTR. See: https://docs.docker.com/ee/dtr/user/access-dtr/ for how to trust on various platforms. （You can also achieve the same effect by putting DTR cert under `/etc/docker/certs.d/<dtr-ip>/`. When you install DTR with `--dtr-external-url`, all UCP nodes are configured to trust DTR in this way)

Second, you need to make your client trust DTR cache server:
Put the generated `ca.pem` (not `cache.cert.pem`) from `certs` directory into some place for trusting DTR cache server.
For example, on Centos:
copy `ca.pem` to the machine where you run `docker pull` from DTR, then:
```bash
sudo cp ca.pem /etc/pki/ca-trust/source/anchors/
sudo mv /etc/pki/ca-trust/source/anchors/ca.pem 192.168.105.78:9443.crt
sudo update-ca-trust
sudo systemctl restart docker
```
Note: Alternatively you can use DTR's key/cert to *issue* the cert for DTR cache server, see [create-certs-signed-by-dtr.sh](https://github.com/xinfengliu/docker-demo/blob/master/dtr-cache/certs/create-certs-signed-by-dtr.sh). DTR's key/cert are `server-key.pem` and `server-cert.pem` in `/Config` directory of dtr-nginx-xxxx container. In this way, you don't have to add DTR cache server's cert to trusted list because your client already trusts DTR.

### Test
DTR cache is transparent to client, so you still run `docker pull` against *original* DTR

Note: 
- Do NOT use client bundle to pull images, use `docker login` first.
- Ensure your local node does NOT have the blob layers of the image to be pulled, otherwise the node will not pull layers at all.
```
docker login 192.168.105.74
docker pull 192.168.105.74/admin/busybox:1.28.3-glibc
```
Then it will be redirected to DTR cache server behind the scene. Check dtr-cache container logs and /nfsshare/dtr-cache to prove DTR cache is effective.

