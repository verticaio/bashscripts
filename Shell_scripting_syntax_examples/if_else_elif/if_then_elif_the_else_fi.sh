#!/bin/bash
read -p "Ilkin reqemi daxiul edin:" count

if [ $count -eq 100 ]
then
  echo "Count is 100"
elif [ $count -gt 100 ]
then
  echo "Count is greater than 100"
else
  echo "Count is less than 100"
fi
