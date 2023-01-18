# run the failsafe through hooks
cat << EOF > client.conf
route-noexec
comp-lzo no
pull-filter ignore "ifconfig-ipv6 "
pull-filter ignore "route-ipv6 "
script-security 2
up /etc/openvpn/vpnfailsafe.sh
down /etc/openvpn/vpnfailsafe.sh
mute-replay-warnings
EOF
# start the VPN connection
# disable ipv6
sudo bash ~/.local/bin/disable-ipv6.sh