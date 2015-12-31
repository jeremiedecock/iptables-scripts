#!/bin/bash

# iptables-low.sh - filter incoming packets only.

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

modprobe ip_conntrack_ftp

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

# Default rule: only accept outgoing packets
$IP4TABLES -P INPUT   DROP
$IP4TABLES -P OUTPUT  ACCEPT
$IP4TABLES -P FORWARD DROP

# Accept incoming packets on the loopback interface
$IP4TABLES -A INPUT -i lo -j ACCEPT

# Reject invalid incoming packets
$IP4TABLES -A INPUT -m state --state INVALID -j DROP

# Reject invalid incoming TCP packets (i.e. with flags not equals to "ALL" or "SYN")
$IP4TABLES -A INPUT -m state --state NEW,RELATED -p tcp ! --tcp-flags ALL SYN -j DROP

# Accept incoming TCP packets related to an already established connexion
$IP4TABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Reject (and notify) incoming connexions on port 113/TCP ("authentication tap ident")
$IP4TABLES -A INPUT -p tcp --destination-port auth -j REJECT --reject-with tcp-reset

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
        $IP4TABLES -A INPUT -p tcp -s $IP --dport $SERVICE -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    done
done

# USERS RULES #########################

#$IP4TABLES -A OUTPUT -p tcp -m tcp --dport 80 -m owner --uid-owner john -j DROP
#$IP4TABLES -A OUTPUT -p tcp -m tcp --dport 80 -m owner --uid-owner alice -j DROP

# DEFAUT ##############################

#$IP4TABLES -A INPUT -m limit --limit 4/s -j LOG --log-prefix "NETFILTER (IN) : "
