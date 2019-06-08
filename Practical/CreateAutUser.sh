#!/bin/bash
# Script to add a user to Linux system
echo -e "Enter \n 1 for Frontend \n 2 for Backend"
read number
if [ $number -eq '2' ]; 
then
echo -e "Create backend users .... \n "
mkdir -p /export/home
for i in 1 2 3 4 
do 
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep -w "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p $pass -d /export/home/$username $username
		[ $? -eq 0 ] && echo -e "\n User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi
   if [ $i -gt '4' ];
   then
   exit 0
   fi
done
fi


#FRONTEND

if [ $number -eq '1' ];
then
echo -e "Create frontend users .... \n "
sed -i 's/\/usr\/libexec\/openssh\/sftp-server/internal-sftp/g' /etc/ssh/sshd_config 
for t in 1 2 3 4
do
if [ $(id -u) -eq 0 ]; then
        read -p "Enter username : " username
        read -s -p "Enter password : " password
        egrep -w  "^$username" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "$username exists!"
                exit 1
        else
                pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
                useradd -m -p $pass  $username -s /sbin/nologin
                echo -e "Match User $username \n X11Forwarding no \n AllowTcpForwarding no \n ChrootDirectory /var/www/html \n ForceCommand internal-sftp \n " >>  /etc/ssh/sshd_config
                [ $? -eq 0 ] && echo -e " \n User has been added to system!" || echo "Failed to add a user!"
        fi
else
        echo "Only root may add a user to the system"
        exit 2
fi
   if [ $t -gt '4' ];
   then
   exit 0
   fi
done
systemctl restart sshd
fi

#config.vm.box = "hashicorp/precise64"  
