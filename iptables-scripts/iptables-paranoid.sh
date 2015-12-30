#!/bin/sh

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

IP4TABLES="/sbin/iptables -v"
IP6TABLES="/sbin/ip6tables -v"

# Setup Netfilter for IPv4 and IPv6
for IPTABLES in "$IP4TABLES" "$IP6TABLES"
do
    # Flush rules
    $IPTABLES -F
    $IPTABLES -X

    # Default rule: silently reject every packet (incoming, outgoing and forwarded)
    $IPTABLES -P INPUT   DROP
    $IPTABLES -P OUTPUT  DROP
    $IPTABLES -P FORWARD DROP

    # Accept every communication on the loopback interface
    $IPTABLES -A INPUT -i lo -j ACCEPT
    $IPTABLES -A OUTPUT -o lo -j ACCEPT
done

