#!/bin/bash
# run this script with a few arguments echo you have entered $# arguments
echo $#     //counter that how many arguments were used when starting scripts 
for i in "$@"
do
echo $i
done
exit 0

