Here are the steps I have been using to enable autostarting of Oracle Datbase Enterprise Edition 10g, 11g or 12c during boot time of Oracle Linux 5 and 6. I also use these steps with Oracle Linux 7. These steps are useful for the kinds of demonstration and development setups that I typically need.

These steps are not needed for Oracle XE, since its install will prompt whether to autostart the DB and will configure the system automatically.

Create a new service script

Create a file /etc/init.d/dbora using dbora

Set permissions on the script

# chmod 750 /etc/init.d/dbora
Tell Linux to autostart/stop the service

# chkconfig --add dbora
# chkconfig dbora on
Edit /etc/oratab

In /etc/oratab, change the autostart field from N to Y for any databases that you want autostarted.

Starting / Stopping the DB

The DB will start and stop at machine boot and shutdown.

Or it can be manually controlled with:

# service dbora start
and

# service dbora stop
Starting Oracle Database 12c Multitenant PDBs

To also start all pluggable databases when the container database starts, run this in SQL*Plus as SYSDBA:

create or replace trigger sys.after_startup
   after startup on database
begin
   execute immediate 'alter pluggable database all open';
end after_startup;
/

----------------------------------------------------------------------------------------------------------
#!/bin/sh -x

# Create this file as /etc/init.d/dbora and execute:
#  chmod 750 /etc/init.d/dbora
#  chkconfig --add dbora
#  chkconfig dbora on
# chkconfig: 2345 80 05
# description: start and stop Oracle Database Enterprise Edition on Oracle Linux 5 and 6,7

ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1/
ORACLE=oracle
PATH=${PATH}:$ORACLE_HOME/bin
HOST=`hostname`
PLATFORM=`uname`
export ORACLE_HOME PATH

case $1 in
'start')
        echo -n $"Starting Oracle: "
        su - $ORACLE -c "$ORACLE_HOME/bin/dbstart $ORACLE_HOME" & # > $USER_HOME/service.log 2>&1 &
        ;;
'stop')
        echo -n $"Shutting down Oracle: "
        su - $ORACLE -c "$ORACLE_HOME/bin/dbshut $ORACLE_HOME " & # > $USER_HOME/service.log 2>&1
        ;;
'restart')
        echo -n $"Shutting down Oracle: "
        su - $ORACLE -c "$ORACLE_HOME/bin/dbshut $ORACLE_HOME" & #> $USER_HOME/service.log 2>&1
        sleep 10
        echo -n $"Starting Oracle: "
        su $ORACLE -c "$ORACLE_HOME/bin/dbstart $ORACLE_HOME" & # > $USER_HOME/service.log 2>&1
        ;;
'status')
       su - oracle -c "$ORACLE_HOME/bin/lsnrctl status"
       ;;
*)
        echo "usage: $0 {start|stop|restart}"
        exit
        ;;
esac



Set this for oracle user for restarting oracle
visudo
oracle  ALL = NOPASSWD: /sbin/service
oracle  ALL = NOPASSWD:  /sbin/service dbora restart
oracle  ALL = NOPASSWD:  /sbin/service dbora stop
oracle  ALL = NOPASSWD:   /sbin/service dbora start
oracle  ALL = NOPASSWD:  /sbin/service dbora status



https://hadafq8.wordpress.com/2016/03/05/rhel-7oel-7centos-7-configuring-automatic-startup-of-oracle-db-under-systemd/
http://www.tldp.org/HOWTO/Oracle-7-HOWTO-6.html



