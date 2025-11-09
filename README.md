# StorageNodeStats-Docker

## Dev
```
docker build -t storagenodestats .
docker run -it --rm --name storagenodestats \
  -e HOSTS=hostname1:14002,hostname2:14002 \
  -e WEBSTORE=https://webstore.domain.com/yoursecretkey \
  storagenodestats
```

## Deploy/Run
```
git clone https://github.com/JMDirksen/StorageNodeStats-Docker.git storagenodestats
cd storagenodestats
git pull
docker build -t storagenodestats .
docker rm -f storagenodestats
docker run -dit --name storagenodestats \
  -e HOSTS=hostname1:14002,hostname2:14002 \
  -e WEBSTORE=https://webstore.domain.com/yoursecretkey \
  --restart unless-stopped \
  storagenodestats
docker logs -ft storagenodestats
```

# Compose file
You can also use the compose file like so:
```
docker compose up -d
docker compose logs -ft
```
