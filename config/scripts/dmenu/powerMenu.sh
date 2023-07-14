
selection=$(echo "restart\nshutdown\nsleep\nexit" | rofi -dmenu -i)

case $selection in
    restart) reboot;;
    shutdown) shutdown now;;
    sleep) systemctl suspend;;
    exit) kill $XSESSION_PID
esac