#!/bin/bash
file=/etc/passwd
# set field delimeter to : 
# read all 7 fields into vars 

while IFS=: read user enpass uid gid desc home shell 

do
[ $uid -ge 500 ] && echo "User $user ($uid) assigned \"$home\" home directory with $shell shell."
#echo "salam"

done < "$file" 

