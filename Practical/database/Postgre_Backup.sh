#!/bin/bash 
tarix=`date +%Y%m%d_%H%M%S`
pg_dumpall -Upostgres > /export/home/backup_dump/all_db_sql_$tarix.sql
pg_dump -Upostgres testdb -Fc --verbose > /export/home/backup_dump/testdb_$tarix.dump
# Remove backups more than 5 days old
rm -rf $(find /export/home/backup_dump/* -type f -mtime +4)

# ------------------------------------------------------------------------------------------------
[root@cent ~]# cat /export/home/scripts/refreshvoen.sh 
#!/bin/sh
echo `date`
dbname="testdb"
username="postgres"
psql $dbname $username << EOF
select test.refreshvoendata(2);
EOF
# -----------------------------------------------------------------------------------------------
#!/bin/sh
echo `date`
dbname="testdb"
username="postgres"
psql $dbname $username << EOF
select test.refreshobjectdata(2);
#commit;
EOF
# -----------------------------------------------------------------------------------------------
Crontab
0 2 * * * /export/home/scripts/full.sh
[root@cent ~]# cat /export/home/scripts/full.sh
tarix=`date +%d_%m_%Y`
log_file=/export/home/scripts/full.log

mkdir /export/home/backup_full/$tarix
chmod 700 /export/home/backup_full/$tarix

mv /var/lib/pgsql/10/archivedir/*backup /var/tmp/arch/

pg_basebackup -h 10.0.0.1 -D /export/home/backup_full/$tarix -U replica -v -P  >> $log_file 2>&1

# Remove backups older than last backup 
rm -rf $(find /export/home/backup_full/* -type d -mtime +0)
# -----------------------------------------------------------------------------------------------
0 3 * * * /export/home/scripts/wal_del.sh

[root@cent ~]# cat /export/home/scripts/wal_del.sh
[ -f /etc/profile ] && source /etc/profile
export PATH=$PATH:$HOME/bin:/usr/pgsql-10/bin
wal_file=/export/home/scripts/wal_del.log
tarix=`date`

echo '***********************************************************************' >> $wal_file
echo 'Deleting all WAL files before last full base backup........'$tarix >> $wal_file


cd /var/lib/pgsql/10/archivedir/
pg_archivecleanup -d /var/lib/pgsql/10/archivedir *backup >> $wal_file 2>&1 


tarix=`date`

echo '***********************************************************************' >> $wal_file
echo 'All WAL files before last full base backup have been deleted successfully!!!.......'$tarix >> $wal_file

# Remove backups older than last backup 
rm -rf $(find /export/home/backup_full/* -type d -mtime +0)

