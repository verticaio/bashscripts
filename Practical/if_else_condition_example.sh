#!/bin/bash
PORT=80
netstat -tulpn | grep $PORT >> /dev/null
 if [ $? == '0' ]; 
 then
 	echo "Port is Up"
 else
 	echo "Port is Down"
 fi