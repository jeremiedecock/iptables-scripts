#!/bin/bash

# Copyright (c) 2007,2015,2016 Jérémie DECOCK <jd.jdhp@gmail.com> (www.jdhp.org)
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

RELATIVE_DIR="$(dirname "$0")"

# INSTALL IPTABLES SCRIPTS ####################################################

cp ${RELATIVE_DIR}/iptables-scripts/iptables-*.sh /etc/
chown root:root /etc/iptables-*.s
chmod 700 /etc/iptables-*.s

# INSTALL LAUNCH FILES (UPSTART) ##############################################

cp ${RELATIVE_DIR}/init-scripts/upstart/iptables.conf /etc/init/
chown root:root /etc/init/iptables.conf
chmod 600 /etc/init/iptables.conf