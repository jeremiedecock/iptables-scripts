#!/bin/bash

# iptables-high.sh - filter incoming and outgoing packets.

# Copyright (c) 2007,2015 Jérémie DECOCK <jd.jdhp@gmail.com> (www.jdhp.org)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# For more information, see https://github.com/jeremiedecock/iptables-scripts
#
# To display the curent Netfilter rules, type the following commands in a Linux
# console (from the administrator account):
#
#   iptables -L -n -v
#   ip6tables -L -n -v

IP4TABLES="/sbin/iptables"
IP6TABLES="/sbin/ip6tables"

[ -x $IP4TABLES ] || { echo "Error: $IP4TABLES not found" ; exit 1 ; }
[ -x $IP6TABLES ] || { echo "Error: $IP6TABLES not found" ; exit 1 ; }

# Kernel params ###############################################################

#modprobe ip_conntrack_ftp

# IPv6 ########################################################################

# Flush rules
$IP6TABLES -F
$IP6TABLES -X

# Default rule: reject every packet (incoming, outgoing and forwarded)
$IP6TABLES -P INPUT   DROP
$IP6TABLES -P OUTPUT  DROP
$IP6TABLES -P FORWARD DROP

# Accept everything on the loopback interface
$IP6TABLES -A INPUT -i lo -j ACCEPT
$IP6TABLES -A OUTPUT -o lo -j ACCEPT

# IPv4 ########################################################################

# Flush rules
$IP4TABLES -F
$IP4TABLES -X

# Default rule: reject every packet (incoming, outgoing and forwarded)
$IP4TABLES -P INPUT   DROP
$IP4TABLES -P OUTPUT  DROP
$IP4TABLES -P FORWARD DROP

# Accept everything on the loopback interface
$IP4TABLES -A INPUT -i lo -j ACCEPT
$IP4TABLES -A OUTPUT -o lo -j ACCEPT

# Reject invalid incoming packets
$IP4TABLES -A INPUT -m state --state INVALID -j DROP

# Reject invalid incoming TCP packets (i.e. with flags not equals to "ALL" or "SYN")
$IP4TABLES -A INPUT -m state --state NEW,RELATED -p tcp ! --tcp-flags ALL SYN -j DROP

# Reject (and notify) incoming connexions on port 113/TCP ("authentication tap ident")
$IP4TABLES -A INPUT -p tcp --destination-port auth -j REJECT --reject-with tcp-reset

# DNS #################################

# DNS_IP contains the list of trusted DNS servers (IPs allowed for DNS
# resolution). For instance:
#
#    DNS_IP=(192.168.0.1 192.168.0.2 8.8.8.8 8.8.4.4)
#   or:
#    DNS_IP=(192.168.0.1)
#   or:
#    DNS_IP=()
#
# DNS_PROTOCOL contains the list of allowed DNS protocols. For instance:
#
#    DNS_PROTOCOL=(tcp udp)
#   or:
#    DNS_PROTOCOL=(tcp)

DNS_IP=()
DNS_PROTOCOL=(tcp udp)

for IP in ${DNS_IP[@]}; do
    for PROTOCOL in ${DNS_PROTOCOL[@]}; do
        $IP4TABLES -A INPUT  -p $PROTOCOL -s $IP --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT
        $IP4TABLES -A OUTPUT -p $PROTOCOL -d $IP --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    done
done

# ALLOWED_OUTGOING_UDP_SERVICES #######

# ALLOWED_REMOTE_UDP_SERVICES contains the list of reachable UDP outgoing services.
# For instance:
#
#    ALLOWED_REMOTE_UDP_SERVICES=(123 514)
#   or:
#    ALLOWED_REMOTE_UDP_SERVICES=(123)
#   or:
#    ALLOWED_REMOTE_UDP_SERVICES=()
#
# Here is a list of common TCP services:
#
#  123 : NTP
#  514 : SYSLOG
#
# The full list is available in /etc/services

ALLOWED_REMOTE_UDP_SERVICES=(123)

for SERVICE in ${ALLOWED_REMOTE_UDP_SERVICES[@]}; do
    $IP4TABLES -A INPUT  -p udp --sport $SERVICE -m state --state ESTABLISHED,RELATED -j ACCEPT
    $IP4TABLES -A OUTPUT -p udp --dport $SERVICE -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
done

# ALLOWED_OUTGOING_TCP_SERVICES #######

# ALLOWED_REMOTE_TCP_SERVICES contains the list of reachable TCP outgoing services.
# For instance:
#
#    ALLOWED_REMOTE_TCP_SERVICES=(80 443)
#   or:
#    ALLOWED_REMOTE_TCP_SERVICES=(80)
#   or:
#    ALLOWED_REMOTE_TCP_SERVICES=()
#
# Here is a list of common TCP services:
#
#   22 : SSH
#   23 : TELNET
#   25 : SMTP
#   80 : HTTP
#  110 : POP3
#  123 : NTP
#  194 : IRC
#  443 : HTTPS
#  465 : SMTP over SSL (POP)
#  515 : Line printer spooler
#  587 : SMTP over TSL (IMAP)
#  993 : IMAP over SSL
#  995 : POP3 over SSL
# 3690 : SVN
# 5222 : XMPP
# 5223 : XMPP over SSL
# 6667 : IRCD
# 9418 : GIT
#
# The full list is available in /etc/services

ALLOWED_REMOTE_TCP_SERVICES=(80 443)

for SERVICE in ${ALLOWED_REMOTE_TCP_SERVICES[@]}; do
    $IP4TABLES -A INPUT  -p tcp --sport $SERVICE -m state --state ESTABLISHED,RELATED -j ACCEPT
    $IP4TABLES -A OUTPUT -p tcp --dport $SERVICE -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
done

# ALLOWED_INCOMING_TCP_SERVICES #######

# TRUSTED_IP contains the list of trusted IPs (IPs allowed to connect to this
# computer). For instance:
#
#    TRUSTED_IP=(192.168.0.1 192.168.0.2)
#   or:
#    TRUSTED_IP=(192.168.0.1)
#   or:
#    TRUSTED_IP=()
#
# ALLOWED_LOCAL_TCP_SERVICES contains the list of services made available for
# trusted IPs. For instance:
#
#    ALLOWED_LOCAL_TCP_SERVICES=(80 443)
#   or:
#    ALLOWED_LOCAL_TCP_SERVICES=(80)
#   or:
#    ALLOWED_LOCAL_TCP_SERVICES=()

TRUSTED_IP=()
ALLOWED_LOCAL_TCP_SERVICES=()

for IP in ${TRUSTED_IP[@]}; do
    for SERVICE in ${ALLOWED_LOCAL_TCP_SERVICES[@]}; do
        $IP4TABLES -A INPUT  -p tcp -s $IP --dport $SERVICE -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
        $IP4TABLES -A OUTPUT -p tcp -d $IP --sport $SERVICE -m state --state ESTABLISHED,RELATED -j ACCEPT
    done
done

# USERS RULES #########################

#$IP4TABLES -A OUTPUT -p tcp -m tcp --dport 80 -m owner --uid-owner john -j DROP
#$IP4TABLES -A OUTPUT -p tcp -m tcp --dport 80 -m owner --uid-owner alice -j DROP

# DEFAUT ##############################

#$IP4TABLES -A INPUT -m limit --limit 4/s -j LOG --log-prefix "NETFILTER (IN) : "
#$IP4TABLES -A OUTPUT -m limit --limit 4/s -j LOG --log-prefix "NETFILTER (OUT) : "
