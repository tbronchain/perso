#!/bin/bash

# set variables
USERNAME="user"
PASSWORD='pass'
NETWORK="net"

echo "please input your vpn username"
read USER1
echo "please input your vpn user password"
read PW1
echo "please input the box vpn password"
read PASSWORD

echo "Configuring auto VPN server ..."

# install dependencies
apt-get install pptpd

# set conf
cat >> /etc/pptpd.conf <<EOF
localip ${NETWORK}.1
remoteip ${NETWORK}.100-201
EOF

# set pass conf
cat >> /etc/ppp/chap-secrets <<EOF
$USERNAME * $PASSWORD ${NETWORK}.200
$USER1 * $PW1 ${NETWORK}.101
EOF

# set ip forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# add iptables rules
iptables -t nat -A POSTROUTING -s ${NETWORK}.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -p tcp --syn -s ${NETWORK}.0/24 -j TCPMSS --set-mss 1356

# start vpn
/etc/init.d/pptpd restart

echo "Configuration done."

# TODO IN TCP 1723
