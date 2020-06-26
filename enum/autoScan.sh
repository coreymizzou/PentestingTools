#!/bin/bash
# author: Mark Kaiser (@c0braKai)
# date: 6 May 2020
# scan that combines the speed of masscan and the thoroughness of nmap nse

echo provide an ip address to scan:

read ip;

`sleep 3m && pkill masscan` &

masscan -p1-65535,U:1-65535 $ip --rate=1200 -e tun0 >> mass.scan ;

cat mass.scan | cut -d ' ' -f 4 | grep udp | cut -d '/' -f 1 > udp.ports;
cat mass.scan | cut -d ' ' -f 4 | grep tcp | cut -d '/' -f 1 > tcp.ports;

if test -f "udp.ports" ; then
sed -i ':a;N;$!ba;s/\n/,/g' udp.ports;
nmap -sUVC $ip -p `cat udp.ports` -oG $ip ;
fi

if test -f "tcp.ports" ; then
sed -i ':a;N;$!ba;s/\n/,/g' tcp.ports;
nmap -sSVC $ip -p `cat tcp.ports` -oG $ip ;
fi
