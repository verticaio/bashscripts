#!/bin/bash
# Do it on  Server nc -k -l -p 8082
# On client client.sh ip port
host=$1
port=$2
telnet $host  $port >> send.txt
value=$(cat send.txt | tail -1 | grep -oP "Salam\s+\K\w+")    # extract valuabe information
echo "Sys Admin $value" | nc $host  $port                     # send message to server socket
kill -s SIGINT $(lsof -i :$port| awk '{print $2}' | tail -1)  # Kill created latest conections
