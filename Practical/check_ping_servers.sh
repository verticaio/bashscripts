#!/bin/sh
for i in `cat ip.txt`;
do
ping -c 2 $i >> /dev/null
if [ $? == 0 ]; 
then
    echo -e "Succesful $i"
else
	echo -e "UnSuccesful $i"
fi
done;

## ip.tct content
#cat ip.txt
#10.0.108.33
#10.0.108.34