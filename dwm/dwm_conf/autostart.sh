#!/bin/bash

feh --bg-scale ~/Pictures/Wallpapers/Rainy_day_snapshot.jpg
terminator &
light-locker &

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
  ping -w 1 -c 1 scl-nas > /dev/null
  RETVAL=$?
  if [ $RETVAL -eq 0 ]; then
     echo -e ""
   else
     echo -e ""
  fi
}

sptfy(){
  [[ $(sp status) == "Playing" ]] && spsymb="" || spsymb=""
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
  echo -e ${symbs[$(($batlvl / (100/5) - 1))]}
}

#FIFO=$(mktemp -u)
#[ -p ${FIFO} ] || mkfifo -m 600 ${FIFO}

while true; do
  xsetroot -name "$(sptfy) | $(vpn) | $(cpu) | $(mem) | $(bat) | $(dte)"
  sleep 1s
done &

