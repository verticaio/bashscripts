#!/bin/bash

#FROM INTERNET
#DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')

#MY SCRIPT
CURRENT=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
THRESHOLD=90

if [ "$CURRENT" -gt "$THRESHOLD" ] ; then
    mail -s 'Disk Space Alert' mailid@domainname.com << EOF
Your root partition remaining free space is critically low. Used: $CURRENT%
EOF
fi

chmod +x diskspace.sh
For crontab daily 
@daily ~/diskspace.sh
---------------------------------------------------------------------------------------------------------------
RAM USAGE
#!/bin/bash

#From Internet 
current=$(free -m | awk 'NR==2{printf "%.2f%%\t\t",100-$4*100/$2 }')
echo  "Ram usage with percent : $current"
#MY script
#total=$(free  |grep -iE Mem | awk '{print $2}') && freesp=$(free  |grep -iE Mem | awk '{print $4}')
#rest=$(($freesp*100/$total ))
#usage=$((100-$rest))
exit
------------------------------------------------------------------------------------------------------------------
CPU  USAGE 

#! /bin/bash
end=$((SECONDS+3600))
printf "Memory\t\tDisk\t\tCPU\n"
while [ $SECONDS -lt $end ]; do
MEMORY=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
CPU=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')
echo "$MEMORY$DISK$CPU"
sleep 5
done