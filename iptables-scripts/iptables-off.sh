#!/bin/sh

# iptables-off.sh - switch off the firewall (for IPv4 and IPv6).

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

# Setup Netfilter for IPv4 and IPv6
for IPTABLES in "$IP4TABLES" "$IP6TABLES"
do
    # Flush rules
    $IPTABLES -F
    $IPTABLES -X

    # Default rule: accept every packet (incoming, outgoing and forwarded)
    $IPTABLES -P INPUT   ACCEPT
    $IPTABLES -P OUTPUT  ACCEPT
    $IPTABLES -P FORWARD ACCEPT
done


