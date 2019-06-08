#!/bin/bash
file=/etc/resolv.conf 

while IFS= read -r line 
do

echo $line

done < "$file"

