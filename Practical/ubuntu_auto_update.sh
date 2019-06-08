#!/bin/bash
DATEFILE="/var/log/update.$(date +%F).log"
LOG="tee -a $DATEFILE"
com="update dist-upgrade autoremove"
apt () {
	$1 $u -y | $LOG
}
for u in $com
do
    apt "apt-get"
done

if [ "$?" == 0 ]
then
    echo "$?" > $DATEFILE
else
    echo "BAD result " >> $DATEFILE
fi


#Crontab file
20 2 * * 0 /root/auto_update.sh > /var/log/auto-update/last.log
