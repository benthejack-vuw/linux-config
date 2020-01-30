#!/bin/bash

#exec 6>&1
#exec >> /dev/null
#exec 2>&1

if pgrep -x openvpn > /dev/null
  then
    echo "killing"
    sudo cp ~/.config/dwm/dhcp_settings_disconnected /etc/resolv.conf
    sudo pkill openvpn
    exit 0
fi

username=$(dmenu -p "user name:" -fn "mononoki:size=16" <&-)
password=$(dmenu -p "password:" -fn "mononoki:size=16" <&-)

# Create a fifo
FIFO=$(mktemp -u)
[ -p ${FIFO} ] || mkfifo -m 600 ${FIFO}
# Start openvpn and tell it to get auth data from the fifo
#pfexec nohup /usr/local/openvpn/sbin/openvpn --daemon --auth-user-pass ${FIFO} --config ~/.ssh/aslate-internal.ovpn >>~aslate/logs/vpn.log&
# Write the auth data to the fifo

sudo cp ~/.config/dwm/dhcp_settings_connected /etc/resolv.conf
sudo dhcpcd

sudo nohup /usr/sbin/openvpn --config ~/.ssh/bjack.ovpn --daemon --auth-user-pass ${FIFO}>>~/logs/vpn.log&
printf "%s\n%s\n" $username $password > ${FIFO}
rm ${FIFO}

#Wait for one or other of the following in /var/adm/messages
# Initialization Sequence Completed - we are done
# auth-failure - invalid username/password
# SIGTERM - some other failure

alert() {
  message="naughty.notify({title=\"OpenVPN\", text=\"$1\"})"
  echo $message | awesome-client
}

log=$(sudo bash ~/.config/awesome/widgets/openvpn-widget/watch_for_vpn_message.sh)
if [[ $log =~ "Initialization Sequence Completed" ]]; then
  alert "VPN connected"
elif [[ $log =~ "AUTH_FAILED" ]]; then
  alert "VPN auth failed"
  exit 1
else
  alert "Error: $log"
  exit 1
fi