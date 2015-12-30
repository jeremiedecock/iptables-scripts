#!/bin/sh

IP4TABLES="/sbin/iptables -v"
IP6TABLES="/sbin/ip6tables -v"

for IPTABLES in "$IP4TABLES" "$IP6TABLES"
do
    $IPTABLES -F
    $IPTABLES -X

    $IPTABLES -P INPUT   DROP
    $IPTABLES -P OUTPUT  DROP
    $IPTABLES -P FORWARD DROP

    $IPTABLES -A INPUT -i lo -j ACCEPT
    $IPTABLES -A OUTPUT -o lo -j ACCEPT
done

