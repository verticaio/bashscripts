#!/bin/bash
echo -e "Veb App Connections, CPU, RAM Monitoring"
read -p "Please enter application port: " port
while true ; 
  do
   clear
   # Connection Size
     echo "$(date) :  ##################################################################"   
     echo -e  "Connections Counts:" 
     echo -e  "Established:" 
     netstat -an | grep -iE ":$port"| grep -iE 'estab' | grep -v 'LISTEN' |  awk '{print $5}' | awk -v FS=':' '{print $1}' | sort | uniq -c ;
     echo -e  "Close_WAIT:" 
     netstat -an | grep -iE ":$port"| grep -iE 'close' |grep -v 'LISTEN' | awk '{print $5}' | awk -v FS=':' '{print $1}' | sort | uniq -c ;
     echo -e  "Time_WAIT:" 
     netstat -an | grep -iE ":$port"| grep -iE 'Time' | grep -v 'LISTEN' |awk '{print $5}' | awk -v FS=':' '{print $1}' | sort | uniq -c ;
     echo -e  "GeneralCount:" 
     netstat -an | grep -iE ":$port"| grep -v 'LISTEN' | awk '{print $5}'| awk -v FS=':' '{print $1}' | sort | uniq -c ;
     echo -e '\n'
   # MEMORY
     echo "RAM statistic:"
     b=$(free -t -m | awk '{print $2}' | head -2 | tail -1)
     echo "Total Memory,it is calculated with MB:" $b
     a=$(bc -l <<< "$(ps -orss= -p $(ps -fu $USER | grep -iE 'tomcat' | grep -iE java | grep -v grep | awk '{print $2}'))/1024")
     echo "Used memory from the $USER apps,it is calculated with MB:" $a| cut -d'.' -f1
     echo -e '\n'
   # CPU statistc
     echo "CPU statistic:"
     echo "$USER app cpu usage:" $(ps -eo pcpu,pid,user,args | grep $USER | grep java | grep -v grep | awk '{print $1}' | tail -1)
     sleep 2
  done



  