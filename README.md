# [Iptables-scripts](https://github.com/jeremiedecock/iptables-scripts)

Copyright (c) 2007,2015 Jeremie DECOCK (<http://www.jdhp.org>)

* Source code: <https://github.com/jeremiedecock/iptables-scripts>
* Issue tracker: <https://github.com/jeremiedecock/iptables-scripts/issues>

## Description

This project contains some Iptables scripts made to setup Netfilter (the Linux
firewall).

## Installation

### Using installation scripts 

On `Upstart` compatible systems (former Debian, Ubuntu, ...), run the following command as root:

```shell
./install-upstart.sh
```

On other systems (`System V` compatible systems):

```shell
./install-sysv.sh
```

### Alternative: detailled installation

First, type the following commands in a Linux console (from the administrator
account):

```shell
cp iptables-scripts/iptables-*.sh /etc/
chown root:root /etc/iptables-*.sh
chmod 700 /etc/iptables-*.sh
```

Then, on `Upstart` compatible systems (former Debian, Ubuntu, ...) type:

```shell
cp init-scripts/upstart/iptables.conf /etc/init/
chown root:root /etc/init/iptables.conf
chmod 600 /etc/init/iptables.conf
```

or on other systems (`System V` compatible systems):

```shell
cp init-scripts/sysv/iptables-rules /etc/init.d/
chown root:root /etc/init.d/iptables-rules
chmod 700 /etc/init.d/iptables-rules
update-rc.d iptables-rules defaults
```

Finally, launch iptables scripts with:

```shell
service iptables-rules start
```

## Change the security level

The install scripts [install-sysv.sh](https://github.com/jeremiedecock/iptables-scripts/blob/master/install-sysv.sh) and [install-upstart.sh](https://github.com/jeremiedecock/iptables-scripts/blob/master/install-upstart.sh) put [firewall scripts](https://github.com/jeremiedecock/iptables-scripts/tree/master/iptables-scripts) in `/etc/`.

To *temporary* change the security level (i.e. until the next reboot), launch one of these scripts as root:
* `/etc/iptables-low.sh` to restrict incoming connections only (on IPv4 only)
* `/etc/iptables-medium.sh` to restrict incoming and outgoing connections (on IPv4 only)
* `/etc/iptables-paranoid.sh` to reject everything but loopback (on IPv4 and IPv6)
* `/etc/iptables-off.sh` to switch off the firewall (accept everything on IPv4 and IPv6)

The current policy can be checked with:
* `iptables -L -n -v` for IPv4
* `ip6tables -L -n -v` for IPv6.

Assuming the firewall scripts have been installed with [install-sysv.sh](https://github.com/jeremiedecock/iptables-scripts/blob/master/install-sysv.sh) (as *upstart* is deprecated on recent Linux distributions), you can make this change permanent in [/etc/init.d/iptables-rules](https://github.com/jeremiedecock/iptables-scripts/blob/master/init-scripts/sysv/iptables-rules#L46) changing line 46 with the desired script.

For instance, to use the "medium" level at startup:

`IPTABLES_SCRIPT=/etc/iptables-medium.sh`

## Bug reports

To search for bugs or report them, please use the Iptables-scripts Bug Tracker
at:

> <https://github.com/jeremiedecock/iptables-scripts/issues>

## License

This project is provided under the terms and conditions of the
[MIT License](http://opensource.org/licenses/MIT).
