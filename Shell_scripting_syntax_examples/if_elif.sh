#!/bin/bash
# run this script with one argument
# the goal is to find out if the argument is a file or a directoryi, socket file and etc.
if [ -f $1 ]; then

echo "$1 is a file"

elif [ -d $1 ]; then

echo "$1 is a directory"

elif [ -D $1 ]; then

echo "$1 is a Socket file"

else 

echo "I don't know what is exactl $1 file type is" 

fi 
exit 0
  
