#!/bin/bash

synergys --config ~/.config/Synergy/synergy-server.conf

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

vpn() {
  ping -w 1 -c 1 192.168.200.109 > /dev/null
  RETVAL=$?
  if [ $RETVAL -eq 0 ]; then
     echo -e ""
   else
     echo -e ""
  fi
}

sptfy(){
  [[ $(sp status) == "Playing" ]] && spsymb=" " || spsymb=" "
  currentsong=$(sp current-oneline)
   if [ $? -eq 1 ]
    then
      echo -e ""
    else
      echo -e "$spsymb $(echo $currentsong | sed -n "s/|/>/p")"
   fi
}

bat(){
  symbs=("" "" "" "" "")
  batlvl=$(acpi | grep -Po '(\d+)(?=%)')
  charging=$(acpi | grep -Po '(Charging)|(Unknown)')
  if [ -z "$charging" ]
   then
  	echo -e "$batlvl%"
   else
  	echo -e "+$batlvl%"
  fi 
}

sound(){
  soundstatus=$(amixer sget Master | grep -Po '(\[on\])|(\[off\])')
  volume=$(amixer sget Master | grep -Po '(?<=\[)\d+\%(?=\])' | head -n 1)
  if [ "$soundstatus" == "[off]" ]; then
	  echo -e ""
  else
	  echo -e " $volume"
  fi
}

while true; do
	xsetroot -name "$(sptfy) | $(sound) | $(vpn) | $(cpu) | $(mem) | $(dte)"
  sleep 0.1s
done &

while true; do
  feh --bg-fill ~/Pictures/Wallpapers/forest_hut.png
  sleep 10m
done &
