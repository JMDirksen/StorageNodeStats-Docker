# StorageNodeStats-Docker


## Dev

```
docker build -t storagenodestats .
touch stats.csv
docker run -it --rm --name storagenodestats \
  -e HOSTS=hostname1:14002,hostname2:14002 \
  -e INTERVAL=10s \
  -e MAXRECORDS=3 \
  -p 8080:80 \
  -v $(pwd)/stats.csv:/usr/local/apache2/htdocs/stats.csv \
  storagenodestats
```


## Deploy/Run

```
git clone https://github.com/JMDirksen/StorageNodeStats-Docker.git storagenodestats
cd storagenodestats
git pull
docker build -t storagenodestats .
docker rm -f storagenodestats
touch stats.csv
docker run -dit --name storagenodestats \
  -e HOSTS=hostname1:14002,hostname2:14002 \
  -e INTERVAL=3h \
  -e MAXRECORDS=240 \
  -p 8080:80 \
  -v $(pwd)/stats.csv:/usr/local/apache2/htdocs/stats.csv \
  --restart unless-stopped \
  storagenodestats
```
