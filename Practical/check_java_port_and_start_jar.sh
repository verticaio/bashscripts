#!/bin/bash
PORT=3323
netstat -tulpn | grep $PORT >> /dev/null
 if [ $? == '0' ]; 
 then
 	echo "Application already started"
 else
	#echo "Application started"
	nohup java -jar java-jar-0.0.1-SNAPSHOT.jar > /dev/null 2>&1 &
 fi
