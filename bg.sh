#!/bin/bash

csv=/usr/local/apache2/htdocs/stats.csv
[ ! -s $csv ] && echo "DateTime,Used,Total,Payout" > $csv

# Split hosts string
HOSTS=$(echo $HOSTS | tr " ,;" "\n")
sleep 5s
echo "Checking hosts..."
for host in $HOSTS; do
  api="http://$host/api"
  sno="$api/sno/"
  version=$(curl -s "$sno" | jq -r ".version")
  echo "Host '$host' running version: $version."
done

while true; do

  # Hourly timer
  while [ ! $(date +%M) -eq 00 ]; do sleep 10; done
  echo "Time: $(date +%H:%M:%S)"

  # Reset variables
  totalavailable=0
  totalused=0
  totalpayout=0

  # Iterate hosts
  for host in $HOSTS; do
    api="http://$host/api"
    sno="$api/sno/"
    ep="$api/sno/estimated-payout"
  
    used=$(curl -s "$sno" | jq -r ".diskSpace.used")
    trash=$(curl -s "$sno" | jq -r ".diskSpace.trash")
    available=$(curl -s "$sno" | jq -r ".diskSpace.available")
    payout=$(curl -s "$ep" | jq -r ".currentMonthExpectations")

    totalused=$(jq -n "$totalused+$used+$trash")
    totalavailable=$(jq -n "$totalavailable+$available")
    totalpayout=$(jq -n "$totalpayout+$payout")
  done

  # Output formatting
  datetime=$(date "+%Y-%m-%d %H:%M")
  totalused=$(jq -n "$totalused/1000000000|round/1000")
  totalavailable=$(jq -n "$totalavailable/1000000000|round/1000")
  totalpayout=$(jq -n "$totalpayout/100")

  # Store to csv
  echo "$datetime,$totalused,$totalavailable,$totalpayout" >> $csv

  # Remove extra records from csv
  count=$(cat $csv | wc -l)
  diff=$(($count-1440))   # ~2 months (2 * 30 * 24)
  ln=0
  cat $csv | while read line; do
    ln=$(($ln+1))
    [ $ln -eq 1 ] && echo "$line" > $csv.new
    [ $ln -gt 1 -a $ln -gt $diff ] && echo "$line" >> $csv.new
  done
  cp $csv.new $csv

  sleep 1m
done
