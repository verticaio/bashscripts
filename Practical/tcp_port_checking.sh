#!/bin/bash
####
# Port Monitoring Script by writing Babak Mammadov
####
RCPT="babakmammadov15@gmail.com"
CC1="babek.mammadov@gmail.com"
CC2="example@cybernet.az"
POLL_INTERVAL=15
PORTS="8080 1521 10900 1920 22 1905 1904 1903"
notify() {
         echo " `date` : Service State Changed to $1 the on PORT $2 " | mail -s "Service Status Notification" -c "$CC1,$CC2"   $RCPT
        }
while true;
        do
             for p in $PORTS
             do
                       portstat=`nmap -p $p localhost -oG - | grep -o open`
                       if [ $portstat ]; then
                          laststate="UP"
                       else
                          laststate="DOWN"
                          echo "$p Port is Not Listening:Closed"
                          if [[ "$laststate" != "UP" ]]; then
                          notify $laststate  $p
                          fi
                       fi
             done
           echo $PORTS
           sleep $POLL_INTERVAL 
        done