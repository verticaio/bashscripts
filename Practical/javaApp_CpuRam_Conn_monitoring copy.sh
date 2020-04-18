#!/bin/bash
while true ; 
  do
   clear
   # Connection Size
     echo "$(date) :  ##################################################################"   
     echo -e  "Connections Counts:" 
     netstat -ntu | awk ' $5 ~ /^(::ffff:|[0-9|])/ { gsub("::ffff:","",$5); print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head -10
     sleep 2
  done



  