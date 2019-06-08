#######
#show all databases;
#mysql -u root -passp -e "show databases" | tr -d "|" | grep -v 'Database'
#or
#Create secret file
#vim /etc/my.cnf.d/.auth.cnf
#[client]
#user=root
#password=pass
# chmod 0400 /etc/my.cnf.d/auth.cnf

# mkdir /backup; cd /backup
# vim mysqlback.sh 
# chmod 0400 /etc/my.cnf.d/auth.cnf
# vim mysqlback.sh 
#!/bin/bash
BACKHOST=10.133.49.193
tarix=`date +%Y%m%d%H%M%S`
output="/export"
mkdir -p  $output/$tarix
databases=`mysql  --defaults-extra-file=/etc/mysql/conf.d/.auth.cnf -e "show databases" | tr -d "|" | grep -v Database`


echo -e "--- `date` Backup started for  below databases --- \n" >> $output/backupscripts.log  2>&1
for db in $databases;
do
if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != _* ]] ; then
echo -e "$db " >> $output/backupscripts.log  2>&1 
mysqldump   --defaults-extra-file=/etc/mysql/conf.d/.auth.cnf --databases $db  -R -E --triggers --single-transaction > $output/$tarix/$db.sql  
fi
done

cd  $output
tar -zcf $tarix.tar.gz $tarix >> $output/backupscripts.log  2>&1 
rsync -az $tarix.tar.gz   root@$BACKHOST:/export/backups/dbmaster  >> $output/backupscripts.log 2>&1 
rm -rf $tarix  >> $output/backupscripts.log 2>&1  
rm -rf $tarix.tar.gz   >> $output/backupscripts.log 2>&1 
if [ $? == 0 ]; then
       echo -e "--- `date` Backup finished succesfully and synced to $BACKHOST ---\n" >>  $output/backupscripts.log
else
       echo -e "--- `date` Backup  failed ---\n" >>  $output/backupscripts.log
fi


# chmod 700 mysqlback.sh

# crontab -e 
20 00 * * * /backup/mysqlback.sh

For restore 
mysql - u username -ppassword dbname < /where/is/your/backupfile.sql