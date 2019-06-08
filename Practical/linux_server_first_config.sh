#!/bin/bash


########  Server install procedures and steps 
## 1.  Configure VMtools on servers if wmware
## 2.  Configure DNS and not using /etc/hosts file
## 3.  Configure Firewall and Selinux settings
## 4.  If needed proxy server configuration
## 5.  History format configure with timestamp and icrease hsit size
## 6.  Update sistem and install required packages 
## 7.  Install and configure ntp client
## 8.  Install zabbix-agent 
## 9.  Send server rsyslog,audit,journalctl logs to Grayl dog log server, old logs deleted
## 10. Install atop and write to file for future analysis
## 11. Set Grup Password and Secure console access for protecting login  
## 12. Completely disable default services (master-mail,cupsd, avahi-daemon,dnsmasq)
## 13. Monitor User activity 
## 14. Bacula client
## 15. Aide for veb directories and another important directories
## 16. Enable all sudo command on logs 
https://www.tecmint.com/sudoers-configurations-for-setting-sudo-in-linux/


ip="1.1.1.6
web_firewall_status='0'
MY_PROXY_URL="http://1.1.1.4:3128/"
DOMAIN="vahid.local"
DNS1="1.1.1.1"
DNS2="1.1.1.2"
NTPSERVER="1.1.1.3"
LOGFILE="status.log"
#UserVariables
USER_LIST="user1 user2 user3"
USER_HOME="/export/home"
#USER_PASS  set user pass inside of scripts


function update_rh7 () {
	yum update -y -q && yum install epel-release -y -q && yum install vim ftp perl glibc.i686 tuned net-tools make yum-utils iptables-services screen telnet  tmux openssh-server  mc iftop  htop iotop wget tcpdump lynx  links pinfo bash-completion   gcc sysstat lsof rsync nc -y -q
    result=$(echo $?)
    if [ $result -ne '0' ];
    then
    	echo "Unsuccesful  Update Operation "  >  $LOGFILE 2>&1
    else
    	echo "Succesful  Update Operation "  >  $LOGFILE 2>&1
    fi 
}


function firewall_rh7 ()
{
  cp /etc/selinux/config /etc/selinux/config_bck
  if [ $web_firewall_status == '1' ]
  then
      systemctl start firewalld >> /dev/null
      systemctl enable  firewalld >> /dev/null
      firewall-cmd --add-service=http --permanent >> /dev/null
      firewall-cmd --add-service=https  --permanent  >> /dev/null
      firewall-cmd --reload >> /dev/null 
      sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
      setenforce 0
  else
      systemctl stop firewalld >> /dev/null
      systemctl disable  firewalld >> /dev/null
      setenforce 0
      sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
  fi
}




function dns_client_rh7() {
if_name=$(nmcli con show | awk '{print $1}' | grep -iE -v "Name" | head -1)
nmcli con mod $if_name ipv4.dns-search "$DOMAIN"
#nmcli con mod $if_name ipv4.dns "$DNS1"
nmcli con mod $if_name ipv4.dns "$DNS1 $DNS2"
systemctl restart NetworkManager
linenum=$(grep -n -w hosts  /etc/nsswitch.conf | grep -v '#' | awk -F':' '{print $1}')
sed -i.bak -e "$linenum d" /etc/nsswitch.conf
echo "hosts:      dns files  myhostname" >> /etc/nsswitch.conf
}




function proxy_client_rh7() {
grep -iE $ip /etc/yum.conf
result=$(echo $?)
if [ $result -ne '0' ];
then
cp /etc/yum.conf /etc/yum.conf.bck
echo "proxy=$MY_PROXY_URL" >> /etc/yum.conf     
echo "
HTTP_PROXY=$MY_PROXY_URL
HTTPS_PROXY=$MY_PROXY_URL
FTP_PROXY=$MY_PROXY_URL
http_proxy=$MY_PROXY_URL
https_proxy=$MY_PROXY_URL
ftp_proxy=$MY_PROXY_URL
export HTTP_PROXY HTTPS_PROXY FTP_PROXY http_proxy https_proxy ftp_proxy 
" >> /etc/profile

cp /etc/wgetrc /etc/wgetrc.bck 
echo "
http_proxy=$MY_PROXY_URL
https_proxy=$MY_PROXY_URL
ftp_proxy=$MY_PROXY_URL
" >> /etc/wgetrc
source /etc/wgetrc
fi

}


function history_timeF_rh7() {
grep -iE 'HISTTIMEFORMAT' /etc/bashrc
result=$(echo $?)
if [ $result -ne '0' ];
then
cp /etc/bashrc /etc/bashrc.bck 
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> /etc/bashrc
echo 'export HISTSIZE=10000' >> /etc/bashrc
echo 'export HISEFILESIZE=10000'  >> /etc/bashrc
source /etc/bashrc
fi
}


ntp_client_rh7 () {

yum install ntp ntpdate  -y -q
cp /etc/ntp.conf /etc/ntp.conf.bck_1
echo "driftfile /var/lib/ntp/drift
logfile /var/log/ntp.log
restrict default nomodify notrap nopeer noquery
restrict 127.0.0.1 
restrict ::1
server $NTPSERVER prefer
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys
disable monitor" > /etc/ntp.conf
systemctl enable ntpd 
systemctl start ntpd 
timedatectl set-ntp yes
timedatectl set-ntp 1
#ntpdate -u $NTPIP 
systemctl restart ntpd 
#ntpq -pn 
result=$(echo $?)
   if [ $result -ne '0' ];
   then
   	echo "Unsuccesful  NTP client Operation "  >  $LOGFILE 2>&1
   else
    	echo "Succesful  NTP client Operation "  >  $LOGFILE 2>&1
   fi 



}

function create_users() {
	for i in $USER_LIST 
	do  
		if [ -d $USER_HOME ];
		then
			useradd -m -d  $USER_HOME/$i $i
			echo "pass" | passwd $i --stdin >> /dev/null
		else
			mkdir -p $USER_HOME
	        useradd -m -d  $USER_HOME/$i $i
	        echo "pass" | passwd $i --stdin >> /dev/null
	    fi
    done
}


install_java8_rh7 () {
    yum install glibc-devel.x86_64 glibc-utils.x86_64 glibc.i686 glibc-devel.i686 libstdc++-devel.i686 libstdc++-devel.x86_64 libstdc++.i686   -y -q
	mkdir /usr/java
    mv jdk-8u65-linux-i586.tar.gz /usr/java/
    cd /usr/java/
    tar -xzvf jdk-8u65-linux-i586.tar.gz 
    cd  jdk1.8.0_65/
    echo "export JAVA_HOME=/usr/java/jdk1.8.0_65" >> /etc/profile
    echo "export PATH=$PATH:/usr/java/jdk1.8.0_65/bin" >> /etc/profile
    source /etc/profile

}

## Call bash functions
proxy_client_rh7
firewall_rh7
history_timeF_rh7
update_rh7
ntp_client_rh7
dns_client_rh7

#####UBUNTU
NTPSERVER="10.0.108.161"
MY_PROXY_URL="http://10.0.108.161:3128/"
DOMAIN="eipoteka.local"
DNS1="10.0.108.161"
#DNS2="10.120.53.54"
NTPSERVER="10.0.108.161"
LOGFILE="status.log"
function history_timeF_rh7() {
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> /etc/bashrc
echo 'export HISTSIZE=10000' >> /etc/bashrc
echo 'export HISEFILESIZE=10000'  >> /etc/bashrc
source /etc/bashrc
}

ntp_client_rh7 () {
NTPSERVER="10.0.108.161"
LOGFILE="status.log"
apt install ntp  -y -q
cp /etc/ntp.conf /etc/ntp.conf.bck
echo "driftfile /var/lib/ntp/drift
logfile /var/log/ntp.log
restrict default nomodify notrap nopeer noquery
restrict 127.0.0.1 
restrict ::1
server $NTPSERVER prefer iburst
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys
disable monitor" > /etc/ntp.conf
systemctl enable ntp 
systemctl start ntp
timedatectl set-ntp on
#ntpdate -u $NTPIP 
systemctl restart ntp
#ntpq -pn 
result=$(echo $?)
   if [ $result -ne '0' ];
   then
   	echo "Unsuccesful  NTP client Operation "  >  $LOGFILE 2>&1
   else
    	echo "Succesful  NTP client Operation "  >  $LOGFILE 2>&1
   fi 

}
ntp_client_rh7
apt-get  update -y -q &&  apt-get install netcat vim perl net-tools make ftp  screen telnet  tmux openssh-server  mc iftop  htop iotop wget tcpdump lynx  links pinfo bash-completion   gcc sysstat lsof rsync  -y -q
for i in asan json proxy service abaxhtml 
do  
	mkdir /export/home 
	useradd -m -d  /export/home/$i 
	echo $i | passwd V$username!888 --stdin >> /dev/null
done
