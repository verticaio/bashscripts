#!/bin/bash
config() {
    	ZabSerIP=$1
	    HST=$(hostname)
	    IP=$(ip a s |  grep inet | grep -v -e inet6  -e 127.0.0.1 -e 192.168.122.1 | awk '{print $2}' | awk -F'/' '{print $1}' | head -1)
	    rpm -Uvh $2
	    cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.orig
	    sed -i "s/Server=127.0.0.1/Server=$ZabSerIP/g" /etc/zabbix/zabbix_agentd.conf
	    sed -i "s/ServerActive=127.0.0.1/ServerActive=$ZabSerIP/g" /etc/zabbix/zabbix_agentd.conf
	    sed -i "s/Hostname=Zabbix server/Hostname=$IP/g" /etc/zabbix/zabbix_agentd.conf
	    chkconfig zabbix-agent on
	    service  zabbix-agent start
	    service  zabbix-agent status
}

redhat5() {
	redhat5=$(cat /etc/*release | grep -iE 'Red Hat|Centos' && grep -iE '5' /etc/*release && echo "yes")
	echo $redhat5 | grep -w yes
	if [ $? == '0' ]; then
		config '10.22.12.132' 'zabbix-agent-3.2.10-2.el5.x86_64.rpm'
    fi
}


redhat5


redhat5=$(cat /etc/*release | grep -iE 'Red Hat|Centos' && grep -iE '5' /etc/*release && echo "yes")
redhat6=$(cat /etc/*release | grep -iE 'Red Hat|Centos' && grep -iE '6' /etc/*release && echo "yes")
redhat7=$(cat /etc/*release | grep -iE 'Red Hat|Centos' && grep -iE '7' /etc/*release && echo "yes")
ubuntu14=$(cat /etc/*release | grep -iE 'Ubuntu' && grep -iE '16' /etc/*release && echo "yes")
ubuntu16=$(cat /etc/*release | grep -iE 'Ubuntu' && grep -iE '16' /etc/*release && echo "yes")
ubuntu18=$(cat /etc/*release | grep -iE 'Ubuntu' && grep -iE '18' /etc/*release && echo "yes")



echo $redhat5 | grep -w yes
if [ $? == '0' ]; then
	config '10.22.12.132' 'zabbix-agent-3.2.10-2.el5.x86_64.rpm'
fi

echo $redhat6 | grep -w yes
if [ $? == '0' ]; then
	config '10.22.12.132' 'zabbix-agent-3.2.10-2.el6.x86_64.rpm'
fi


echo $redhat6 | grep -w yes
if [ $? == '0' ]; then
	config '10.22.12.132' 'zabbix-agent-3.2.10-2.el6.x86_64.rpm'
fi






#ChangeHostnameWithIP
#!/bin/bash
HST=$(hostname)
IP=$(ip a s |  grep inet | grep -v -e inet6  -e 127.0.0.1 -e 192.168.122.1 | awk '{print $2}' | awk -F'/' '{print $1}')
if [ -f /etc/zabbix/zabbix_agentd.conf ] ;
then
    sed -i "s/$HST/$IP/g" /etc/zabbix/zabbix_agentd.conf
    systemctl restart zabbix-agent.service
    newip=$(cat /etc/zabbix/zabbix_agentd.conf  | egrep -i 'Hostname' | awk -F'=' '{print $2}')
    if [ $newip = $IP ]; then
    	systemctl is-active --quiet zabbix-agent.service && echo "Hostname Succesfuly changed to IP and ZabbixAgent Service in running"
    else 
        echo "Zabbix Config hostname doesn't changed"	
    fi
else
    echo "No Default Zabbix Agent Config file"
fi








------------------------------------------------------------
#!/bin/bash

#ReadFile and extract iplist
extractIP() {
while read line
do
	ip=$(echo $line  | awk -F',' '{ print $2}')
    #portstat=$(nmap -p 22 $ip -oG - | grep -o open)
    nc -w 3 -z $ip  22
    if [ $? == '0' ]; then
    	echo $ip
    fi
done < CMDB_UPDATE.csv | egrep -v '^$'
}

checkZabAgent() {
HST=$(hostname)
IP=$(ip a s |  grep inet | grep -v -e inet6  -e 127.0.0.1 -e 192.168.122.1 | awk '{print $2}' | awk -F'/' '{print $1}')
ps -fu zabbix
if [ $? == '0' ]; then
	if [ -f /etc/zabbix/zabbix_agentd.conf ] ;
    then
    	sed -i "s/$HST/$IP/g" /etc/zabbix/zabbix_agentd.conf
        systemctl restart zabbix-agent.service
        newip=$(cat /etc/zabbix/zabbix_agentd.conf  | egrep -i 'Hostname' | awk -F'=' '{print $2}')
        if [ $newip = $IP ]; then
    	systemctl is-active --quiet zabbix-agent.service && echo "Hostname Succesfuly changed to IP and ZabbixAgent Service in running"
        else
        	echo "Zabbix Config hostname doesn't changed"	
        fi
    else
    	echo "No Default Zabbix Agent Config file"
    fi


else;


fi


}
