#!/bin/bash

# set variables
VPNHOSTNAME="host.myvpn.com"
USERNAME="user"
PASSWORD="pass"
SERVICE="myvpn"
SERVER_IP="192.168.2.1"

# install dependencies
apt-get install pptp-linux

# set conf
cat > /etc/ppp/peers/$SERVICE <<EOF
pty "pptp $VPNHOSTNAME --nolaunchpppd --debug"
name $USERNAME
password $PASSWORD
remotename PPTP
require-mppe-128
require-mschap-v2
refuse-eap
refuse-pap
refuse-chap
refuse-mschap
noauth
debug
persist
maxfail 0
defaultroute
replacedefaultroute
usepeerdns
EOF

# set service
cat > /etc/init.d/vpn <<EOF
#! /bin/sh

case "$1" in
  start)
    pon $SERVICE
    echo "PPTP Started"
    ;;
  restart)
    poff $SERVICE
    sleep 1
    pon $SERVICE
    echo "PPTP Restarted"
    ;;
  stop)
    poff $SERVICE
    echo "PPTP Stopped."
    ;;
  *)
    echo "Usage: /etc/init.d/vpn {start|restart|stop}"
    exit 1
    ;;
esac

exit 0
EOF
chmod +x /etc/init.d/vpn
update-rc.d vpn defaults

# set cron
CRON=$(crontab -l | grep $SERVER_IP | wc -l)
if [ $CRON -eq 0 ]; then
    echo "*/1 * * * * ping -q -c5 $SERVER_IP || service vpn restart" | crontab
fi
