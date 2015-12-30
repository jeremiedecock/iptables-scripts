#!/bin/sh

IP4TABLES="/sbin/iptables -v"
IP6TABLES="/sbin/ip6tables -v"

for IPTABLES in "$IP4TABLES" "$IP6TABLES"
do
    $IPTABLES -F
    $IPTABLES -X

    $IPTABLES -P INPUT   ACCEPT
    $IPTABLES -P OUTPUT  ACCEPT
    $IPTABLES -P FORWARD ACCEPT
done


