#!/bin/bash

# Copyright (c) 2007,2015,2016,2019 Jérémie DECOCK <jd.jdhp@gmail.com> (www.jdhp.org)
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
chown root:root /etc/iptables-*.sh
chmod 700 /etc/iptables-*.sh

# INSTALL LAUNCH FILES (SYSV) #################################################

cp ${RELATIVE_DIR}/init-scripts/systemd/iptables-rules.service /etc/systemd/system/
chown root:root /etc/systemd/system/iptables-rules.service
chmod 644 /etc/systemd/system/iptables-rules.service

# LAUNCH IPTABLES SCRIPTS (SYSTEMD) ###########################################

systemctl enable iptables-rules.service
systemctl start iptables-rules.service
systemctl status iptables-rules.service
