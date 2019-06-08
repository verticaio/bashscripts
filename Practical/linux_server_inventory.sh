#!/bin/bash
echo -e "\e[31;43m***** HOSTNAME INFORMATION *****\e[0m"
hostnamectl
echo ""
# -UNAME ALL:
echo -e "\e[31;43m***** UNAME *****\e[0m"
uname -a
echo ""
# -UNAME ALL:
echo -e "\e[31;43m***** DATE *****\e[0m"
date
echo ""
# -DRIVE:
echo -e "\e[31;43m***** Drive info *****\e[0m"
lsblk -a
echo ""
# -RELEASE:
echo -e "\e[31;43m***** Release info *****\e[0m"
cat /etc/*release
echo ""
# -FILE SYSTEM DISK SPACE USAGE:
echo -e "\e[31;43m***** FILE SYSTEM DISK SPACE USAGE *****\e[0m"
df -h
echo ""
# -FREE AND USED MEMORY:
echo -e "\e[31;43m ***** FREE AND USED MEMORY *****\e[0m"
free
echo ""
# -SYSTEM UPTIME AND LOAD:
echo -e "\e[31;43m***** SYSTEM UPTIME AND LOAD *****\e[0m"
uptime
echo ""
# -LOGGED-IN USERS:
echo -e "\e[31;43m***** CURRENTLY LOGGED-IN USERS *****\e[0m"
who
echo ""
# -TOP 5 PROCESSES	
echo -e "\e[31;43m***** TOP 5 MEMORY*****\e[0m"
ps -eo %mem,%cpu,comm --sort=-%mem | head -n 6
echo ""
# IP ADDRESS
echo -e "\e[31;43m***** IP ADDRESS *****\e[0m"
ip addr
echo ""
# STARTUP SERVICES
echo -e "\e[31;43m***** STARTUP SERVICES *****\e[0m"
chkconfig --list
echo ""
# Users
echo -e "\e[31;43m***** USERS *****\e[0m"
awk -F':' '{ print $1}' /etc/passwd
echo ""
# Route rules
echo -e "\e[31;43m***** ROUTE RULES *****\e[0m"
ip route
echo ""
# Services status 
echo -e "\e[31;43m***** SERVICES STATUS *****\e[0m"
service --status-all
echo ""