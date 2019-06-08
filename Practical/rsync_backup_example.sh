#!/bin/bash
# Rsycn incremental  backup script and if backup failed send email notificationl
RSYNC=`which rsync`
SSHPORT=22
DATE=`date +"%Y%m%d"`
#BACKUPDIR=
#LOGFILE=
BACKHOST=1.1.1.1
FRONTHOST=1.1.1.2
SSOHOST=1.1.1.4
APPALFAHOST=1.1.1.5
#Log to File
echo -e "--- `date` It backups --- \n" >>  /backup/scripts/scripts.log 
#backup backend 
$RSYNC -az -e 'ssh -p22' root@$BACKHOST:/export/home   /backup/backprod/incremental  2>> /backup/scripts/scripts.log  && \
echo -e "        Backup finished succesfully  for $BACKHOST ---\n" >> /backup/scripts/scripts.log && \
#backup frontend
$RSYNC -az -e 'ssh -p22' root@$FRONTHOST:/var/www   /backup/frontprod/incremental  2>> /backup/scripts/scripts.log && \
$RSYNC -az -e 'ssh -p22' root@$FRONTHOST:/etc/httpd   /backup/frontprod/incremental  2>> /backup/scripts/scripts.log && \
echo -e "        Backup finished succesfully  for $FRONTHOST ---\n" >> /backup/scripts/scripts.log && \
#backup app_front_alfa
$RSYNC -az -e 'ssh -p22' root@$APPALFAHOST:/export/home   /backup/appfrontalfa/incremental  2>> /backup/scripts/scripts.log  && \
$RSYNC -az -e 'ssh -p22' root@$APPALFAHOST:/var/www    /backup/appfrontalfa/incremental  2>> /backup/scripts/scripts.log  && \
$RSYNC -az -e 'ssh -p22' root@$APPALFAHOST:/etc/httpd  /backup/appfrontalfa/incremental  2>> /backup/scripts/scripts.log  && \
echo -e "        Backup finished succesfully  for $APPALFAHOST ---\n" >> /backup/scripts/scripts.log && \
#backup ssohost
$RSYNC -az -e 'ssh -p22' root@$SSOHOST:/opt  /backup/ssoprod/incremental  2>> /backup/scripts/scripts.log && \
echo -e "        Backup finished succesfully  for $SSOHOST ---\n" >> /backup/scripts/scripts.log 
#Check_Backup_Status_and_Send_Mail
if [ $? == 0 ]; then 
       echo -e "--- `date` Backup finished succesfully  for $BACKHOST,$FRONTHOST,$SSOHOST,$APPALFAHOST ---\n" >> /backup/scripts/scripts.log 
else
       echo "Rsync backup script goes failed $DATE for $BACKHOST,$FRONTHOST,$APPALFAHOST,$SSOHOST"   | mail -s "  Backup Script does failed" -r "test@gmail.com" babakmammadov15@gmail.com
       echo -e "--- `date` Backup  failed  for $BACKHOST,$FRONTHOST,$APPALFAHOST,$SSOHOST ---\n" >> /backup/scripts/scripts.log 
fi 
exit 0
