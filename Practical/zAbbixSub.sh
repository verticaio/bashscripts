#!/bin/bash

zabbix_server=10.0.0.1
ping -q -c2  $zabbix_server  > /dev/null

if [ $? -eq 0 ] 
then
    echo -e "Select OS version:\n1. redhat7\n2. centos7\n3. ubuntu17\n4. ubuntu16\n5. ubuntu14Or12\n6. Centos&Redhat6"
    read   osrelease

    if [[ "$osrelease" -eq "6" ]] || [[ "$osrelease" -eq "6" ]]
    then
        rpm --quiet -ivh http://repo.zabbix.com/zabbix/3.2/rhel/6/x86_64/zabbix-release-3.2-1.el6.noarch.rpm 
        yum install zabbix-agent -y -q
        service zabbix-agent start
        chkconfig zabbix-agent on 
        echo "PidFile=/var/run/zabbix/zabbix_agentd.pid
        LogFile=/var/log/zabbix/zabbix_agentd.log
        LogFileSize=5
        DebugLevel=3
        Server=$zabbix_server
        ServerActive=$zabbix_server
        Hostname=`hostname`
        Include=/etc/zabbix/zabbix_agentd.d/
        " >  /etc/zabbix/zabbix_agentd.conf
        echo -e "\n"
        service zabbix-agent restart
        service zabbix-agent status
        echo -e "\n"
        echo -e '\E[32m'"Zabbix Agent Successfully installed"
        echo -e "\n"
    fi

    if [[ "$osrelease" -eq "1" ]] || [[ "$osrelease" -eq "2" ]] 
    then
    rpm --quiet -ivh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm
    yum install zabbix-agent -y -q
    systemctl start zabbix-agent.service 
    systemctl enable  zabbix-agent.service > /dev/null
    echo "PidFile=/var/run/zabbix/zabbix_agentd.pid
    LogFile=/var/log/zabbix/zabbix_agentd.log
    LogFileSize=5
    DebugLevel=3
    Server=$zabbix_server
    ServerActive=$zabbix_server
    Hostname=`hostname`
    Include=/etc/zabbix/zabbix_agentd.d/
    " >  /etc/zabbix/zabbix_agentd.conf
    echo -e "\n"
    systemctl restart zabbix-agent.service
    systemctl status zabbix-agent.service  | head -3  | sed '2d'
    echo -e "\n"
    echo -e '\E[32m'"Zabbix Agent Successfully installed"
    echo -e "\n"

    elif [[ "$osrelease" -eq "3" ]] ||  [[ "$osrelease" -eq "4" ]]
    then
    wget --quiet http://repo.zabbix.com/zabbix/3.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.2-1+xenial_all.deb
    dpkg -i    zabbix-release_3.2-1+xenial_all.deb  > /dev/null 
    apt-get update -qq
    apt-get install zabbix-agent -qq
    systemctl start zabbix-agent.service
    systemctl enable zabbix-agent.service  > /dev/null
    echo "PidFile=/var/run/zabbix/zabbix_agentd.pid
    LogFile=/var/log/zabbix/zabbix_agentd.log
    LogFileSize=5
    DebugLevel=3
    Server=$zabbix_server
    ServerActive=$zabbix_server
    Hostname=`hostname`
    Include=/etc/zabbix/zabbix_agentd.d/
    " >  /etc/zabbix/zabbix_agentd.conf
    echo -e "\n"
    systemctl restart zabbix-agent.service
    systemctl status zabbix-agent.service  | head -3  | sed '2d'
    echo -e "\n"
    echo -e '\E[32m'"Zabbix Agent Successfully installed"
    echo -e "\n"
    #ForRedhat6
    #else if [[ "$osrelease" -eq "redhat6" ]] ||  && [[ "$osrelease" -eq "centos6"]]; then
    #For Ubuntu12or14
    #else if  if [[ "$osrelease" -eq "ubuntu12" ]] ||  && [[ "$osrelease" -eq "ubuntu14" ]] ; then
    else
    echo "You must enter right os release"
fi
fi
ping -q -c2  $zabbix_server  > /dev/null
if [ $? != 0 ]
then
echo -e '\E[32m'"Have Connection Problem with Zabbix Server"
fi
