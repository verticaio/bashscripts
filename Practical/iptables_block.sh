#!/bin/bash
# To run this file, first give the permission +x and execute this program
# --# chmod +x blocknmap.sh
# --# ./blocknmap.sh
 
 
echo "1-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=1"
echo "3                                                                      3"
echo "3     ________   .__          ________                                 3"
echo "7     \______ \  |__|  ______/   __   \     ____    ____    _____      7"
echo "1      |    |  \ |  | /  ___/\____    /   _/ ___\  /  _ \  /     \     1"
echo "3      |        \|  | \___ \    /    /    \  \___ (  <_> )|  Y Y  \    3"
echo "3     /_______  /|__|/____  >  /____/   /\ \___  > \____/ |__|_|  /    3"
echo "7             \/          \/            \/     \/               \/     7"
echo "1                                                                      1"
echo "3              >> The Underground Exploitation Team                    3"
echo "3                                                                      3"
echo "7                                                                      7"
echo "1          [+] Site   : http://www.Dis9.com                            1"
echo "3                                                                      3"
echo "3                                                                      3"
echo "7            ###############################################           7"
echo "1            I'm Liyan Oz Leader of Underground Exploitation           1"
echo "3            ###############################################           3"
echo "3                                                                      3"                                          
echo "7-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-7"
echo "========================================================================"
echo "=                  Block Nmap Scanning using iptables                  ="
echo "=                         C0ded by Liyan Oz                            ="
echo "=                      http://0nto.wordpress.com                       ="
echo "========================================================================"  
echo ""
echo ""
#=====================
# Enable IP Forward
#---------------------
 
 
echo 1 > /proc/sys/net/ipv4/ip_forward
 
 
#=====================
# Flush semua rules
#---------------------
/sbin/iptables -F
/sbin/iptables -t nat -F
 
 
#=====================
# Block
#---------------------
 
 
/sbin/iptables -t filter -A INPUT -p TCP -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -t filter -A INPUT -p UDP -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -t filter -A INPUT -p ICMP -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -t filter -A INPUT -m state --state INVALID -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ACK,FIN FIN -j LOG --log-prefix "FIN: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ACK,FIN FIN -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ACK,PSH PSH -j LOG --log-prefix "PSH: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ACK,PSH PSH -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ACK,URG URG -j LOG --log-prefix "URG: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ACK,URG URG -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL ALL -j LOG --log-prefix "XMAS scan: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL ALL -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL NONE -j LOG --log-prefix "NULL scan: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL NONE -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j LOG --log-prefix "pscan: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags SYN,FIN SYN,FIN -j LOG --log-prefix "pscan 2: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags FIN,RST FIN,RST -j LOG --log-prefix "pscan 2: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL SYN,FIN -j LOG --log-prefix "SYNFIN-SCAN: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL SYN,FIN -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL URG,PSH,FIN -j LOG --log-prefix "NMAP-XMAS-SCAN: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL URG,PSH,FIN -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL FIN -j LOG --log-prefix "FIN-SCAN: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL FIN -j DROP
 
 
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL URG,PSH,SYN,FIN -j LOG --log-prefix "NMAP-ID: "
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags ALL URG,PSH,SYN,FIN -j DROP
/sbin/iptables -t filter -A INPUT   -p tcp --tcp-flags SYN,RST SYN,RST -j LOG --log-prefix "SYN-RST: "