#!/bin/bash
# apache.sh - A simple menu driven shell script to install and configure apache on centos 7
# Linux server / desktop.
# Author: Babak Mammadov
# Date: 31/08/2018

# Module 1. Check Internet Connection,Update and Install Apache/Php Packages
# Module 2. User Creation and No Access to server with ssh  only SFTP access for Web Developers
# Module 3. Prepare General Apache Configuration
# Module 4. Prepare Apache HTTP VirtualHosts
# Module 5. Prepare Apache HTTPS Virtual Host and Self-Signed Certificate Creation
# Module 6. Write Firewall Rules For Web Server
# Module 7. Give report about WebSite and  send to Web Developer with email 
# Module 8. DELETE vHOSTS
# Activate Logging

#Problem Check packages succesfully installed, uninstall fully apache and delete virtual host, 
#correct https module of the project,correct ius and php7.1 sohbetii and php72-cgi
#Solve below error
##Please select one of 1 or 2): 2
#cp: missing destination file operand after ‘/etc/httpd/conf.d/ssltest.conf’
#Try 'cp --help' for more information.


# ERROR ssl inter sozu certifikatin onunde gelir, plus da ssl conf faylinda Virtual Hostlar alt atla yazilmalidir, plusda Ancaq Execcgi gelmelidir
##################





#General variables
host_name="$(hostname)"
host_ip=$(ip a s | grep -w  inet | awk '{print $2}' | sed '2q;d' | cut -d'/' -f1)
log_file="./instal_log.txt"

# Check Internet Connection and take ip
function check_net_con_install_packages() {
ping -c3 www.az >> /dev/null
result=$(echo $?)
    if [ $result -ne '0' ];
    then
        echo "You have internet problem, Please check internet connection or dns settings"
        exit 0   #Exit Program
    else
        echo "Updating sistem  and install Apache and php7.1 packages take some time .... "
        /usr/bin/yum update -y -q
        /usr/bin/yum install yum-utils wget zip unzip curl vim openssh-server openssh expect -y -q >> /dev/null
        /usr/bin/yum install mod_ssl mod_fcgid httpd  -y -q >> /dev/null
        /usr/bin/yum install https://centos7.iuscommunity.org/ius-release.rpm -y -q >> /dev/null
        /usr/bin/yum install php71u php71u-cli php71u-common php71u-fpm php71u-gd php71u-mbstring php71u-mysqlnd php71u-opcache php71u-pdo php71u-pear php71u-pecl-igbinary php71u-pecl-memcache php71u-pecl-memcached php71u-process php71u-xml php71u-json php71u-bcmath -y -q >> /dev/null
        /usr/bin/yum list installed | grep -iE -e 'wget' -e 'httpd' -e 'mod_ssl' -e 'mod_fcgid'   >> /dev/null
        if [ $? == '0' ];
        then
            echo "Successfully Updating and Installing packages"
        else
            echo "UnSuccessfully Updating and Installing packages" 
            exit 0 #Exit Program
        fi    
    fi
}

function web_firewall ()
{
  read -p "1. Enable Firewall or 2. Disable Firewall (1/2):" result
  if [ $result == '1' ]
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



function create_user () {
  username=$1
  pass=$2
  useradd $username -s /sbin/nologin
  echo $pass | passwd $username --stdin >> /dev/null
  
  #Create Only FileZilla access developer code with Chroot ssh
  cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
  sed -i 's/\/usr\/libexec\/openssh\/sftp-server/internal-sftp/' /etc/ssh/sshd_config
  echo -e "Match User $username \n X11Forwarding no \n AllowTcpForwarding no \n ChrootDirectory /var/www/html \n ForceCommand internal-sftp" >> /etc/ssh/sshd_config
  chown root.root /var/www/html
  chmod 755 /var/www/html
}


function check_web_status () {
   systemctl enable  httpd >> /dev/null && systemctl start httpd 
   if [ $? == '0' ]
   then 
     echo "Apache Successfully installed"
   else
      echo "Apache Failed installed"
      systemctl status httpd 
   fi

   cat ./web_report.txt
}

function apache_general_conf () {
  # Status Page Access by Everyone and For Zabbix
  pub_ip="$(wget -qO- ipinfo.io/ip)"
  #mv /etc/httpd/conf.d/php.conf /etc/httpd/conf.d/php.conf.orig
  cp ./confs/servername.conf /etc/httpd/conf.d/
  sed -i 's/test.az/'$host_name'/g' /etc/httpd/conf.d/servername.conf 
  cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.orig
  cp ./confs/httpd.conf  /etc/httpd/conf/httpd.conf
  cp  /etc/httpd/conf.d/fcgid.conf /etc/httpd/conf.d/fcgid.conf.orig
  cp ./confs/fcgid.conf  /etc/httpd/conf.d/fcgid.conf
  #echo "Enable Apache Worker Mode"
  cp ./confs/worker.conf /etc/httpd/conf.d/worker.conf
  cp ./confs/00-mpm.conf /etc/httpd/conf.modules.d/
  #echo  "Enable Status Page"
  cp ./confs/server-status.conf /etc/httpd/conf.d/
  #echo  "Take public ip and restriction to access to site with IP address"
  sed -i 's/1.1.1.1/'$pub_ip'/g'  /etc/httpd/conf/httpd.conf
  #echo  "For SSL Conf file"
  cp /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.orig
  cp ./confs/ssl.conf /etc/httpd/conf.d/ssl.conf
  sed -i 's/1.1.1.1/'$pub_ip'/g' /etc/httpd/conf.d/ssl.conf
}


function web_report()
{
  vhostname=$1
  documentRoot=$2
  sftp_ip=$3
  sftp_user=$4
  sftp_pass=$5
echo -e "Good afternoon, \nAs requested, your new domain has been created.  \nThe information you will need to access and use your new domain are posted below:
---------------------------------------------------------------
Website Information
---------------------------------------------------------------
Domain:            $vhostname
DocumentRoot:      $documentRoot
SFTP IP:           $sftp_ip
SFTP Username:     $sftp_user
SFTP Password:     $sftp_pass"
}

function apache_https_vhost ()
{
  verify=$1
  vhostname=$2 
  username=$3
  country_name='AZ' 
  state_name='Baku'
  locality_name='Baku'
  org_name='ICT LLC'
  org_unit_name='ICT'
  common_name=$2
  email_addr=info@$2



if [ $verify == 'yes' ]
then
    read -p "1.Import Exist certificate or 2.Create New Self-Signed One (1/2): " key

    if [ $key == '1' ]
    then
      read -p "Please set certificate path): " pub_cert
      read -p "Please set Intermediate certificate path): " inter_cert
      read -p "Please set private key path): " pri_key
      cp ./confs/sslhttpvhost.conf /etc/httpd/conf.d/ssltest.conf
      sed -i 's/test.az/'$vhostname'/g' /etc/httpd/conf.d/ssltest.conf
      sed -i 's/user/'$username'/g' /etc/httpd/conf.d/ssltest.conf
      sed -i 's/public_cert/'$pub_cert'/g' /etc/httpd/conf.d/ssltest.conf
      sed -i 's/private_key/'$pri_key'/g' /etc/httpd/conf.d/ssltest.conf
      sed -i 's/inter_public_cert/'$inter_cert'/g' /etc/httpd/conf.d/ssltest.conf
      cat /etc/httpd/conf.d/ssltest.conf >> /etc/httpd/conf.d/ssl.conf
      rm -rf /etc/httpd/conf.d/ssltest.conf
    else
        mkdir /etc/httpd/SSL
        /usr/bin/expect<<EOF
        log_user 0
        log_file create_certificate.log
        spawn openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/httpd/SSL/$vhostname.key   -out /etc/httpd/SSL/$vhostname.crt
        expect "]:"                             {send "$country_name\r"}
        expect "]:"                             {send "$state_name\r"}
        expect "]:"                             {send "$locality_name\r"}
        expect "]:"                             {send "$org_name\r"}
        expect "]:"                             {send "$org_unit_name\r"}
        expect "]:"                             {send "$common_name\r"}
        expect "]:"                             {send "$email_addr\r"}
        expect eof
EOF
      cp ./confs/sslhttpvhost.conf /etc/httpd/conf.d/ssltest.conf
      sed -i 's/test.az/'$vhostname'/g' /etc/httpd/conf.d/ssltest.conf
      sed -i 's/user/'$username'/g' /etc/httpd/conf.d/ssltest.conf
      sed -i 's/public_cert/\/etc\/httpd\/SSL\/'$vhostname.crt'/g' /etc/httpd/conf.d/ssltest.conf
      sed -i 's/private_key/\/etc\/httpd\/SSL\/'$vhostname.key'/g' /etc/httpd/conf.d/ssltest.conf
      sed -i 's/inter_public_cert/\/etc\/httpd\/SSL\/'$vhostname.crt'/g' /etc/httpd/conf.d/ssltest.conf
      cat /etc/httpd/conf.d/ssltest.conf >> /etc/httpd/conf.d/ssl.conf
      rm -rf /etc/httpd/conf.d/ssltest.conf
             
    fi
fi  
}


function apache_http_vhost () {
   read -p "Do you enable HTTPS (yes/no): " verify

   #echo "Create VirtualHost"
   read -p "Enter VirtualHost Count: " vhost_count
   for (( i=1; i<=$vhost_count; i++))
   do

   #echo "Create user and call create_user function"
   read -p "Enter User Name: " username
   read -p "Enter Password for $username: " pass
   create_user $username $pass

   #echo "Create Virtual Hostname and web directories"
   read -p "Enter VirtualHost Name: " vhostname
   mkdir -p /var/www/html/$vhostname/{public,tmp}
   mkdir -p /var/www/html/$vhostname/public/public
   mkdir -p /var/www/php-cgi/$vhostname

   #echo "Configure FastCGI and Php.ini for VirtualHost"
   cp ./confs/php.* /var/www/php-cgi/$vhostname/
   cp ./confs/index.php /var/www/html/$vhostname/public/public
   sed -i 's/test.az/'$vhostname'/g' /var/www/html/$vhostname/public/public/index.php
   sed -i 's/test.az/'$vhostname'/g' /var/www/php-cgi/$vhostname/php.cgi
   sed -i 's/test.az/'$vhostname'/g' /var/www/php-cgi/$vhostname/php.ini

   #echo "Setting User Permission"
   chown -R $username.$username /var/www/html/$vhostname
   chown -R $username.$username /var/www/php-cgi/$vhostname
   chmod 755 /var/www/php-cgi/$vhostname/php.cgi

   #echo "Create HTTP VirtualHost" 
   cat ./confs/vhost.conf  > /etc/httpd/conf.d/test.conf
   sed -i 's/test.az/'$vhostname'/g' /etc/httpd/conf.d/test.conf
   sed -i 's/user/'$username'/g' /etc/httpd/conf.d/test.conf
   cat /etc/httpd/conf.d/test.conf >> /etc/httpd/conf.d/vhost.conf
   rm -rf /etc/httpd/conf.d/test.conf

   # Create HTTPS VirtualHost files
   if [ $verify == 'yes' ]
   then
      apache_https_vhost $verify $vhostname $username
   else
       continue
   fi
   webreport=$(web_report $vhostname  "/var/www/html/$vhostname/public/public" $host_ip $username $pass)
   echo $webreport #>> web_report.txt
   done  
}

function main () {
  check_net_con_install_packages
	apache_general_conf
	apache_http_vhost
  web_firewall
	check_web_status

}

main 

