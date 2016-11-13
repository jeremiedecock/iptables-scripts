[Iptables-scripts](https://github.com/jeremiedecock/iptables-scripts)
=====================================================================

Copyright (c) 2007,2015 Jeremie DECOCK (<http://www.jdhp.org>)

* Source code: <https://github.com/jeremiedecock/iptables-scripts>
* Issue tracker: <https://github.com/jeremiedecock/iptables-scripts/issues>

Description
-----------

This project contains some Iptables scripts made to setup Netfilter (the Linux
firewall).

Installation
------------

Type the following commands in a Linux console (from the administrator
account):

```shell
cp iptables-scripts/iptables-*.sh /etc/
chown root:root /etc/iptables-*.sh
chmod 700 /etc/iptables-*.sh
```

On `Upstart` compatible systems (former Debian, Ubuntu, ...):

```shell
cp init-scripts/upstart/iptables.conf /etc/init/
chown root:root /etc/init/iptables.conf
chmod 600 /etc/init/iptables.conf
```

On other systems (`System V` compatible systems):

```shell
cp init-scripts/sysv/iptables-rules /etc/init.d/
chown root:root /etc/init.d/iptables-rules
chmod 700 /etc/init.d/iptables-rules
update-rc.d iptables-rules defaults
```

Launch iptables scripts:

```shell
service iptables-rules start
```

Bug reports
-----------

To search for bugs or report them, please use the Iptables-scripts Bug Tracker
at:

> <https://github.com/jeremiedecock/iptables-scripts/issues>

License
-------

This project is provided under the terms and conditions of the
[MIT License](http://opensource.org/licenses/MIT).

