#!/bin/sh
# Network data Script by Jonas Keidel 2012

LANG=C
echo "Network data:"

for i in $(ifconfig -a | egrep '^eth.+|^enp.+' | cut -d ':' -f 1); do
  # detect link
  link=$(ethtool $i | grep "Link detected" | tr -s ' ' | cut -d: -f2)
  # get mac address
  mac=$(ip link show dev $i | grep ether | tr -s ' ' | cut -d ' ' -f3)
  # get ip address
  ip=$(ip a show $i | grep -m1 inet | tr -s ' ' | cut -d' ' -f3 | cut -d/ -f1)
  if [ -z "$ip" ] ; then
    ip="(none)"
  fi
  ip6=$(ip a show $i | grep inet6 | grep -m1 global | awk '{print $2}')
  if [ -z "$ip6" ] ; then
    ip6="(none)"
  fi
  modul=$(ethtool -i $i | grep driver | tr -s ' ' | cut -d' ' -f2)
  if [ -n "$modul" ] ; then
    modul=$(modinfo -d $modul 2>/dev/null)
  fi

  printf "   %-6s%s\n" "$i" "LINK:$link"
  printf "%9s%s\n" " " "MAC:  $mac"
  printf "%9s%s\n" " " "IP:   $ip"
  printf "%9s%s\n" " " "IPv6: $ip6"
  if [ -n "$modul" ] ; then
    printf "%9s%s\n" " " "$modul"
  fi
done

echo
