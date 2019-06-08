#!/bin/bash

if [ -z $1 ]; then 
echo "Enter your name:"
read Name
else
Name=$1
fi
echo "You have entered the text $Name"
exit 0

