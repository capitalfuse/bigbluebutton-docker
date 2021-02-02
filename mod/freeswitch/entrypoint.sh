#!/bin/bash

# remove all SIP (port 5060) iptable rules
iptables -S INPUT | grep "\-\-dport 5060 " | cut -d " " -f 2- | xargs -rL1 iptables -D

# block requests to 5060 (tcp/udp)
iptables -A INPUT -p tcp --dport 5060 -s 0.0.0.0/0 -j REJECT
iptables -A INPUT -p udp --dport 5060 -s 0.0.0.0/0 -j REJECT

# allow some IPs 
IFS=',' read -ra ADDR <<< "$SIP_IP_ALLOWLIST"
for IP in "${ADDR[@]}"; do
    # process "$i"
    echo "allow port 5060/udp for $IP"
    iptables -I INPUT  -p udp --dport 5060 -s $IP -j ACCEPT
done

# create user 'freeswitch'
# add it to group 'freeswitch'
# change owner and group of the freeswitch installation
cd /opt
groupadd freeswitch
adduser --quiet --system --home /opt/freeswitch --gecos "FreeSWITCH open source softswitch" --ingroup freeswitch freeswitch --disabled-password
chown -R freeswitch:freeswitch /opt/freeswitch/
chmod -R ug=rwX,o= /opt/freeswitch/
chmod -R u=rwx,g=rx /opt/freeswitch/bin/*

chown -R freeswitch:freeswitch /var/freeswitch/meetings
chmod 777 /var/freeswitch/meetings

dockerize \
    -template /etc/freeswitch/vars.xml.tmpl:/etc/freeswitch/vars.xml \
    -template /etc/freeswitch/autoload_configs/conference.conf.xml.tmpl:/etc/freeswitch/autoload_configs/conference.conf.xml \
    /opt/freeswitch/bin/freeswitch -u freeswitch -g freeswitch -nonat -nf
