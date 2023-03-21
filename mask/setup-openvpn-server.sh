#!/bin/bash

SERVERNAME=server1
CLIENTNAME=client1

# https://wiki.archlinux.org/title/Easy-RSA
# https://wiki.archlinux.org/title/OpenVPN

################ ca side

# edit vars
mv vars.example vars

# setup pki
./easyrsa init-pki

# setup ca (nopass is optional)
./easyrsa build-ca nopass

# move the relevant files to the server
scp /etc/easy-rsa/pki/ca.crt root@1.2.3.4:/etc/openvpn/server/ca.crt

################ server side

# setup pki
./easyrsa init-pki

# setup server certificate & key
./easyrsa gen-req ${SERVERNAME} nopass
cp /etc/easy-rsa/pki/private/${SERVERNAME}.key /etc/openvpn/server/

# generate Diffie-Hellman parameters
openssl dhparam -out /etc/openvpn/server/dh.pem 2048

# generate the HMAC key
openvpn --genkey secret /etc/openvpn/server/ta.key

# send cert signing requests to the ca
cp /etc/easy-rsa/pki/reqs/*.req /tmp
chown archie /tmp/*.req

################ client side

# can be done on any machine

# setup pki
./easyrsa init-pki

# setup client cert & key
easyrsa gen-req ${CLIENTNAME} nopass

# send cert signing requests to the ca
cp /etc/easy-rsa/pki/reqs/*.req /tmp
chown archie /tmp/*.req

################ ca side

# get the signing requests
scp archie@server:/tmp/*.req /tmp
scp archie@client:/tmp/*.req /tmp

# sign the requests
cd /etc/easy-rsa
./easyrsa import-req /tmp/${SERVERNAME}.req ${SERVERNAME}
./easyrsa import-req /tmp/${CLIENTNAME}.req ${CLIENTNAME}
./easyrsa sign-req server ${SERVERNAME}
./easyrsa sign-req client ${CLIENTNAME}

# clear tmp files
rm -f /tmp/*.req

# send the signed certificates
cp /etc/easy-rsa/pki/issued/*.crt /tmp
chown archie /tmp/*.crt
scp /tmp/*.crt archie@server:/tmp

################ server side

# import the certificates
mv /tmp/${SERVERNAME}.crt /etc/openvpn/server/
mv /tmp/${CLIENTNAME}.crt /etc/openvpn/client/
chown root:openvpn /etc/openvpn/server/${SERVERNAME}.crt
chown root:openvpn /etc/openvpn/client/${CLIENTNAME}.crt

# server configuration; edit the following lines:
# ca ca.crt
# cert SERVERNAME.crt
# key SERVERNAME.key
# dh dh.pem
# tls-crypt ta.key # Replaces tls-auth ta.key 0
# user nobody
# group nobody
cp /usr/share/openvpn/examples/server.conf /etc/openvpn/server/server.conf

# client configuration; edit the following lines:
# client
# remote elmer.acmecorp.org 1194
# user nobody
# group nobody
# ca ca.crt
# cert client.crt
# key client.key
# tls-crypt ta.key # Replaces tls-auth ta.key 1
cp /usr/share/openvpn/examples/client.conf /etc/openvpn/client/${CLIENTNAME}.conf

# enable ip forwarding
perl -pi -e 's#;net.ipv4.ip_forward#net.ipv4.ip_forward#g' /etc/sysctl.conf
sudo sysctl -p

# setup the firewall
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -A INPUT -i tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A INPUT -i tap+ -j ACCEPT
iptables -A FORWARD -i tap+ -j ACCEPT
iptables -A INPUT -i eth0 -m state --state NEW -p udp --dport 1194 -j ACCEPT
iptables -A FORWARD -i tun+ -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o tun+ -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i tap+ -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o tap+ -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables-save -f /etc/iptables/iptables.rules

# merge all the parameters into a single config file
BASE_CONFIG=client.conf
CA_CERT=ca.crt
CLIENT_CERT=client.crt
CLIENT_KEY=client.key
TLS_KEY=ta.key
OUTPUT_FILE=client.ovpn
cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${CA_CERT} \
    <(echo -e '</ca>\n<cert>') \
    ${CLIENT_CERT} \
    <(echo -e '</cert>\n<key>') \
    ${CLIENT_KEY} \
    <(echo -e '</key>\n<tls-crypt>') \
    ${TLS_KEY} \
    <(echo -e '</tls-crypt>') \
    > ${OUTPUT_FILE}
