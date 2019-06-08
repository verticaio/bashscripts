#!/bin/bash
# For RedHat/CentOS/OracleLinux
ftp_user="frontend"
ftp_pass="pass"
ipaddr="ip addr | grep 'state UP'  -A2 | tail -n1 |  awk '{print $2}'  | cut -f1  -d'/' | head -n1"
##Install VSFTPD
ftp_user_create () {
if [ -d /export/home ]; then
	useradd -m -d /export/home/$ftp_user $ftp_user
    echo -e "$ftp_pass\n$ftp_pass" | passwd $ftp_user
else 
	mkdir -p /export/home >> /dev/null
	useradd -m -d /export/home/$ftp_user $ftp_user
    echo -e "$ftp_pass\n$ftp_pass" | passwd $ftp_user
}

ftp_install () {
yum -y install vsftpd  >> /dev/null
systemctl start vsftpd 
systemctl enable  vsftpd >> /dev/null
}

ftp_configure(){
	 touch /etc/vsftpd/chroot_list
     echo "$ftp_user" > /etc/vsftpd/chroot_list
     cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig
     cat ./vsftpd.conf > /etc/vsftpd/vsftpd.conf
     systemctl restart vsftpd
     systemctl status iptables | grep -iE '(running)' >> /dev/null
     ipt=$(echo $?)
     if [[ `firewall-cmd --state` = running ]];then
     	firewall-cmd --permanent  --add-rich-rule='rule family=ipv4 source address=$ipaddr/32 port port=21 protocol=tcp accept'
        firewall-cmd --permanent  --add-rich-rule='rule family=ipv4 source address=$ipaddr/32 port port=40001-45000 protocol=tcp accept'
        firewall-cmd --reload
     elif [[ $ipt == 0 ]]; then
      sed -i 's/IPTABLES_MODULES=""/IPTABLES_MODULES="ip_conntrack_ftp"/g' /etc/sysconfig/iptables-config
      systemctl restart iptables 
      iptables -I INPUT -p tcp -s $ipaddr/32 --dport 21 -j accept
      iptables -I INPUT -p tcp -s $ipaddr/32 --dport 21 -j accept
     fi
}
     
     