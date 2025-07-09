#!/bin/bash

csv=/usr/local/apache2/htdocs/stats.csv
[ ! -s $csv ] && echo "DateTime,Used,Total,Payout" > $csv

HOSTS=$(echo $HOSTS | tr ",;" "\n")
echo "Hosts:"
for host in $HOSTS; do
    echo "  - $host"
done

while true; do
  totalavailable=0
  totalused=0
  totalpayout=0

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
    
  datetime=$(date "+%Y-%m-%d %H:%M")
  totalused=$(jq -n "$totalused/1000000000|round/1000")
  totalavailable=$(jq -n "$totalavailable/1000000000|round/1000")
  totalpayout=$(jq -n "$totalpayout/100")

  echo "$datetime,$totalused,$totalavailable,$totalpayout" >> $csv

  sleep $INTERVAL
done
