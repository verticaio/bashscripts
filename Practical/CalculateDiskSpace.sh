#!/bin/bash
echo -e "Disk Usage For `hostname` server:"
df -h --output=size --total | tail -1 | awk '{a=a+$1} END{print "Total:",a"GB"}'
df -h --output=used --total | tail -1 | awk '{a=a+$1} END{print "Used:",a"GB"}'
df -h --output=avail --total | tail -1 | awk '{a=a+$1} END{print "Free:",a"GB"}'
exit 0
#df -m | awk 'NR>2{sum+=$4}END{print sum}'















