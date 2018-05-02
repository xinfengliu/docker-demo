## demo DTR cache

See https://docs.docker.com/ee/dtr/admin/configure/deploy-caches/simple/#configure-your-user-account for detailed steps.

### Prerequisites:
- Set up a NFS server for storing data of DTR cache
- Run scripts under `certs` to generate ca/cert/key files for dtr cache server
- Use UCP client bundle to set up your Docker client environment before deploying `docker-stack.yml`

### After deploying the stack
- Run `register-cache-with-dtr.sh`
- On DTR web UI, in the user's account setting, change to use the cache.

### setup your `docker pull` client.
Put generated `ca.pem` (not cache.cert.pem) in `certs` directory into some place trusting DTR cache server.
see: https://docs.docker.com/ee/dtr/user/access-dtr/ for how to trust on various platforms. For example, on Centos:
copy `ca.pem` to the machine where you run `docker pull` from DTR, then:
```bash
sudo cp ca.pem /etc/pki/ca-trust/source/anchors/
sudo mv /etc/pki/ca-trust/source/anchors/ca.pem 192.168.105.78:9443.crt
sudo update-ca-trust
sudo systemctl restart docker
```
### test
DTR cache is transparent to client, so you still run `docker pull` against *original* DTR
`docker pull 192.168.105.74/admin/busybox:1.28.3-glibc`
Then it will be redirected to DTR cache server behind the scene.

