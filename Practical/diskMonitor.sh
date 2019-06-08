#! /bin/bash
cat /etc/fstab | grep -v -e swap -e "^#" -e '^$' -e 'pts' -e 'sys' -e 'proc' -e 'shm'| awk '{print $2}' > /tmp/disks.txt
file="/tmp/disks.txt"
while IFS= read line
do
    CURRENT=$(df $line | grep / | awk '{ print $5}' | sed 's/%//g')
	THRESHOLD=25
	if [ "$CURRENT" -gt "$THRESHOLD" ];then
		echo -e "It is Test. Your $line partition remaining free space is critically low. Used: $CURRENT%" | mail -s "Disk Space problem"  -r "babek.mammadov@gmail.com"  babek.mammadov@cybernet.az
	fi
done <"$file"