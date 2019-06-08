#!/bin/bash
echo -n "Limestone Networks does not claim any responsibility for your use of this script."
echo -n "It is recommended that you only run this on a new system."
echo -n "-----------------------------------------------------------------------------------"
echo -n "Please enter your admin e-mail address: "
read -e ADMINEMAIL

echo -n "Please enter a new SSH port (or press enter for random): "
read -e SSHPORT

if [[ "$SSHPORT" == "" ]]
then SSHPORT=$((RANDOM%5000+2000))
fi
while :
do
 echo "What are the functions of your server?"
 echo "1. Web + Mail Server (HTTP, FTP, MySQL, SMTP, POP3)"
 echo "2. cPanel Server (HTTP, Mail, MySQL, DNS)"
 echo "3. Web Server (HTTP, FTP, MySQL)"
 echo "4. VoIP Server (HTTP, SIP, RTP)"
 echo "5. Mail Server (HTTP, SMTP, POP3)"
 echo "6. ABORT the securing process. Take no action."
 echo -n "Please enter option [1 - 6] "
 read opt
 case $opt in
  1) echo "Opening standard ports for Web + Mail Servers";
        TCPPORTS=( 80 20 21 25 26 110 443 465 993 995 $SSHPORT )
        UDPPORTS=( 21 465 )
        break;;
  2) echo "Opening standard ports for Web + Mail Servers";
        TCPPORTS=( 20 21 25 26 37 43 53 80 110 113 143 443 465 783 873 993 995 2077 2078 2082 2083 2086 2087 2089 2098 2096 6666 $SSHPORT )
        UDPPORTS=( 21 465 783 873 2077 2078 )
        break;;
  3) echo "Opening standard ports for Web Servers";
        TCPPORTS=( 80 20 21 443 $SSHPORT )
        UDPPORTS=( 21 )
        break;;
  4) echo "Opening standard ports for VoIP Servers";
        TCPPORTS=( 80 443 5036 5060 $SSHPORT )
        UDPPORTS=( 2727 4569 5036 5060 10000:20000 )
        break;;
  5) echo "Opening standard ports for Mail Servers";
        TCPPORTS=( 80 25 26 110 443 465 993 995 $SSHPORT )
        UDPPORTS=( 465 )
        break;;
  6) echo "Exiting. No action has been taken.";
        exit 1;;
  *) echo "$opt is an invaild option. Please select option between 1-6 only";
     echo "Press [enter] key to continue. . .";
     read enterKey;;
esac
done

RANDOMPASS=`echo "$TCPPORTS Secure $SSHPORT Script $UDPPORTS" | sha1sum | cut -c1-15`
RANDOMPASSCRYPT=$(perl -e 'print crypt($ARGV[0], "password")' $RANDOMPASS)


# Allow any following commands to fail without stopping
cd /root
set +e


echo "--- Installing Useful Packages ---"
echo "----------------------------------"

# Installing useful packages
yum -y install joe tcpdump mtr postfix strace \
               zsh gdb perl vixie-cron logrotate

# Turn on cron-based auto-updates
yum -y install yum-cron
for d in crond yum yum-cron; do
    /sbin/chkconfig $d on
    /sbin/service $d start
done



echo "--- Insure All Packages Are Up To Date  ---"
echo "-------------------------------------------"
yum -y update



echo "--- Setting Password Policies                                            ---"
echo "--- Per recommendations from http://wiki.centos.org/HowTos/OS_Protection ---"
echo "----------------------------------------------------------------------------"
echo "Passwords will expire every 180 days"
perl -npe 's/PASS_MAX_DAYS\s+99999/PASS_MAX_DAYS 180/' -i /etc/login.defs
echo "Passwords may only be changed once a day"
perl -npe 's/PASS_MIN_DAYS\s+0/PASS_MIN_DAYS 1/g' -i /etc/login.defs



echo "--- Setting Additional OS Policies/Securities                            ---"
echo "--- Per recommendations from http://wiki.centos.org/HowTos/OS_Protection ---"
echo "----------------------------------------------------------------------------"
# Now that we've restricted the login options for the server, lets kick off all the idle folks. To do this, we're going to use a bash variable in /etc/profile. There are some reasonably trivial ways around this of course, but it's all about layering the security.
echo "Idle users will be removed after 15 minutes"
echo "readonly TMOUT=900" >> /etc/profile.d/os-security.sh
echo "readonly HISTFILE" >> /etc/profile.d/os-security.sh
chmod +x /etc/profile.d/os-security.sh

# In some cases, administrators may want the root user or other trusted users to be able to run cronjobs or timed scripts with at. In order to lock these down, you will need to create a cron.deny and at.deny file inside /etc with the names of all blocked users. An easy way to do this is to parse /etc/passwd. The script below will do this for you.
echo "Locking down Cron"
touch /etc/cron.allow
chmod 600 /etc/cron.allow
awk -F: '{print $1}' /etc/passwd | grep -v root > /etc/cron.deny
echo "Locking down AT"
touch /etc/at.allow
chmod 600 /etc/at.allow
awk -F: '{print $1}' /etc/passwd | grep -v root > /etc/at.deny



echo "--- Install and Clear IPTables Firewall  ---"
echo "--------------------------------------------"
yum install -y iptables
chkconfig iptables on
/sbin/service iptables start
/sbin/iptables -F
/sbin/iptables -X
/etc/init.d/iptables save


echo "--- Running Firewall Configurations ---"
echo "---------------------------------------"

# By default reject all traffic
/sbin/iptables -P INPUT DROP
/sbin/iptables -P OUTPUT DROP
/sbin/iptables -P FORWARD DROP

# Allow localhost
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A OUTPUT -o lo -j ACCEPT

# Allow output for new, related and established connections
/sbin/iptables -A OUTPUT -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT

# Open TCP Ports
for port in ${TCPPORTS[@]}
	do
		echo "Opening TCP Port $port"
		/sbin/iptables -A INPUT -p tcp -m tcp --dport $port -j ACCEPT
	done

# Open UDP Ports
for port in ${UDPPORTS[@]}
	do
		echo "Opening UDP Port $port"
		/sbin/iptables -A INPUT -p udp -m udp --dport $port -j ACCEPT
	done



echo "--- Blocking Common Attacks ---"
echo "-------------------------------"

echo "Forcing SYN packets check"
/sbin/iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

echo "Forcing Fragments packets check"
/sbin/iptables -A INPUT -f -j DROP

echo "Dropping malformed XMAS packets"
/sbin/iptables -A INPUT -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP

echo "Drop all NULL packets"
/sbin/iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

echo "Limiting pings to 1 per second"
/sbin/iptables -N PACKET
/sbin/iptables -A DEFAULT_RULES -p icmp -m limit --limit 3/sec --limit-burst 25 -j ACCEPT

echo "Setup Connection Tracking"
/sbin/iptables -N STATE_TRACK
/sbin/iptables -A STATE_TRACK -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A STATE_TRACK -m state --state INVALID -j DROP

echo "Discouraging Port Scanning"
/sbin/iptables -N PORTSCAN
/sbin/iptables -A PORTSCAN -p tcp --tcp-flags ACK,FIN FIN -j DROP
/sbin/iptables -A PORTSCAN -p tcp --tcp-flags ACK,PSH PSH -j DROP
/sbin/iptables -A PORTSCAN -p tcp --tcp-flags ACK,URG URG -j DROP
/sbin/iptables -A PORTSCAN -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
/sbin/iptables -A PORTSCAN -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
/sbin/iptables -A PORTSCAN -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
/sbin/iptables -A PORTSCAN -p tcp --tcp-flags ALL ALL -j DROP
/sbin/iptables -A PORTSCAN -p tcp --tcp-flags ALL NONE -j DROP
/sbin/iptables -A PORTSCAN -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
/sbin/iptables -A PORTSCAN -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
/sbin/iptables -A PORTSCAN -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP



echo "--- Performing Final Configurations ---"
echo "---------------------------------------"
/sbin/iptables -N COMMON
/sbin/iptables -A COMMON -j STATE_TRACK
/sbin/iptables -A COMMON -j PORTSCAN
/sbin/iptables -A COMMON -j PACKET

/sbin/iptables -A INPUT -j COMMON
/sbin/iptables -A OUTPUT -j COMMON
/sbin/iptables -A FORWARD -j COMMON
/sbin/iptables -A FORWARD -j PACKET

/etc/init.d/iptables save



echo "--- Installing DDoS Deflate ---"
echo "-------------------------------"

wget http://www.inetbase.com/scripts/ddos/install.sh
chmod 0700 install.sh
./install.sh
rm -f install.sh



echo "--- Installing CHKROOTKIT  ---"
echo "------------------------------"
wget -O /usr/local/src/chkrootkit.tar.gz ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit.tar.gz
tar -C /usr/local/src/ -zxvf /usr/local/src/chkrootkit.tar.gz
mkdir /usr/local/chkrootkit
mv -f /usr/local/src/chkrootkit*/* /usr/local/chkrootkit
cd /usr/local/chkrootkit
make sense
cd /root

/bin/cat << EOM > /etc/cron.daily/chkrootkit.sh
#!/bin/sh
(
/usr/local/chkrootkit/chkrootkit
) | /bin/mail -s 'CHROOTKIT Daily Run' $ADMINEMAIL
EOM
chmod 700 /etc/cron.daily/chkrootkit.sh



echo "--- Installing Root Kit Hunter ---"
echo "----------------------------------"
wget -O /usr/local/src/rkhunter.tar.gz "http://downloads.sourceforge.net/project/rkhunter/rkhunter/1.4.0/rkhunter-1.4.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Frkhunter%2Ffiles%2F&ts=1356967335&use_mirror=superb-dca3"
tar -C /usr/local/src/ -zxvf /usr/local/src/rkhunter.tar.gz
cd /usr/local/src/rkhunter*
./installer.sh --layout default --install
/usr/local/bin/rkhunter --update
/usr/local/bin/rkhunter --propupd
rm -Rf /usr/local/src/rkhunter*
/bin/cat << EOM > /etc/cron.daily/rkhunter.sh
#!/bin/sh
(
/usr/local/bin/rkhunter --versioncheck
/usr/local/bin/rkhunter --update
/usr/local/bin/rkhunter --cronjob --report-warnings-only
) | /bin/mail -s 'rkhunter Daily Run' $ADMINEMAIL
EOM
chmod 700 /etc/cron.daily/rkhunter.sh



echo "--- Installing LSM (Linux Socket Monitor) ---"
echo "---------------------------------------------"
wget -O /usr/local/src/lsm-current.tar.gz http://www.rfxn.com/downloads/lsm-current.tar.gz
tar -C /usr/local/src/ -zxvf /usr/local/src/lsm-current.tar.gz
cd /usr/local/src/lsm-0.*
./install.sh
cd /root
rm -Rf /usr/local/src/lsm-*
sed -i 's/root/'$ADMINEMAIL/ /usr/local/lsm/conf.lsm
/usr/local/sbin/lsm -g


echo "--- Making changes to /etc/sysctl.conf ---"
echo "------------------------------------------"
echo 'net.ipv4.tcp_syncookies = 1' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_synack_retries = 2' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.rp_filter = 1' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.rp_filter = 1' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.accept_redirects = 0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.secure_redirects = 0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.accept_source_route = 0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.send_redirects = 0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.send_redirects = 0' >> /etc/sysctl.conf

/sbin/sysctl net.ipv4.tcp_syncookies=1
/sbin/sysctl net.ipv4.tcp_synack_retries=2
/sbin/sysctl net.ipv4.conf.all.rp_filter=1
/sbin/sysctl net.ipv4.conf.default.rp_filter=1
/sbin/sysctl net.ipv4.conf.all.accept_redirects=0
/sbin/sysctl net.ipv4.conf.all.secure_redirects=0
/sbin/sysctl net.ipv4.conf.all.accept_source_route=0
/sbin/sysctl net.ipv4.conf.all.send_redirects=0
/sbin/sysctl net.ipv4.conf.default.send_redirects=0


echo "--- Securing the SSH Daemon ---"
echo "-------------------------------"
echo "Creating Admin User"
useradd -m -p $RANDOMPASSCRYPT admin
echo "Backing up previous SSHd configurations"
mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
/bin/cat << EOM > /etc/ssh/sshd_config
## Random SSH port
Port $SSHPORT
 
## Sets listening address on server. default=0.0.0.0
#ListenAddress 192.168.0.1
 
## Enforcing SSH Protocol 2 only
Protocol 2
 
## Disable direct root login, with no you need to login with admin user, then "su -" you into root
PermitRootLogin no
 
##
UsePrivilegeSeparation yes
 
##
AllowTcpForwarding yes
 
## Disables X11Forwarding
X11Forwarding no
 
## Checks users on their home directority and rhosts, that they arent world-writable
StrictModes yes
 
## The option IgnoreRhosts specifies whether rhosts or shosts files should not be used in authentication
IgnoreRhosts yes
 
##
HostbasedAuthentication no
 
## RhostsAuthentication specifies whether sshd can try to use rhosts based authentication. 
RhostsRSAAuthentication no
 
## Adds a login banner that the user can see
Banner /etc/motd
 
## Enable / Disable sftp server
Subsystem      sftp    /usr/libexec/openssh/sftp-server
 
## Add users that are allowed to log in
AllowUsers admin
EOM

echo "******************************************"
echo "       YOUR SERVER IS NOW HARDENED"
echo "------------------------------------------"
echo "SSH User: admin"
echo "SSH Pass: $RANDOMPASS"
echo "SSH Port: $SSHPORT"
echo "Admin Email: $ADMINEMAIL"
echo "Change to root: Login using the admin user and run: su root"
echo "*************************************************************"
echo ""
echo "You must now reconnect to this server using the information above."
echo "Changing the SSH port has caused this connection to freeze."
echo "BEFORE CLOSING THIS WINDOW please note your information above."
echo "---"
/sbin/service sshd restart
