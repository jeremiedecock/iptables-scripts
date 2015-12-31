# TODO

## Version 0.1

- [x] Add the initial version of the 4 iptables config scripts : iptables-off, iptable-paranoid, iptables-low and iptables-medium
- [x] Add the init scripts System V
- [x] Add the init scripts Updtart
- [ ] Add the init scripts Systemd
- [ ] Add the install script
- [ ] Add scripts to generate a Debian package
- [ ] Read the allowed IPs/Ports form a config file for iptables-low and iptables-medium: in /etc/default/iptables
- [ ] Write a short documentation in the README file
- [ ] Write a short documentation about TCP wrappers in the README file
- [ ] Guaranty the integrity of all scripts using SHA hashs and GPG signatures + sign (with GPG) critical (all?) Git commits and tags

## Version 0.2 and above

- [ ] Fix UDP management for iptables-low and iptables-medium
- [ ] Fix IPv6 management for iptables-low and iptables-medium
- [ ] Improve rules (search documentation in linuxmag, misc, ...)
- [ ] Write test scripts (functional testing) using packets generator tools
- [ ] Improve logs management

## Misc

- [ ] Create a new repository "nftables-scripts"
- [ ] Create a new repository "pf-scripts" (packet filter) for BSD/MacOSX

