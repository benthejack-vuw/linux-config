#!/bin/bash

/home/ben/linux-configuration/config/scripts/start-synergy.sh

dte(){
  dte="$(date +"%b %d - %I:%M")"
  echo -e "$dte"
}

mem(){
  memusage="$(free | awk '/Mem/ {printf "%.1f/%.1fGB\n", $3/1024000, $2/1024000 }')"
  echo -e " $memusage"
}

cpu(){
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e " `printf %03d $cpu`%"
}

while true; do
	xsetroot -name "$(cpu) | $(mem) | $(dte)"
  sleep 0.1s
done &

#while true; do
  feh --bg-fill ~/Pictures/Wallpapers/Rainy_day_snapshot.jpg
 # sleep 10m
#done &
