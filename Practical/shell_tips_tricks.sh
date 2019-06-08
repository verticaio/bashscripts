# Echo examples
echo -e "\e[33mThis is yellow\e[0m"
echo -e "\033[36m" This is blue  "\e[1;31m"
echo -e "\e[1;31mThis is red text\e[0m"
echo -e "\e[1;33;4;44mYellow Underlined Text on Blue Background\e[0m"

#delete empty lines
sed -i -r '/^\s*$/d' file.txt

#Delete next line object and concanate all strings
tr -d ‘\n’ < yourfile.txt

# Show connected ip addr to ports
netstat -na | grep -iE 1521 | grep -iE -v listen |  awk '{print $5}' | cut -d: -f1 | uniq | sort


# Show latest 5 high cpu usage 
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -5
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%ram | head -5

#Convert sh script format  written in windows sublime to linux format
dos2unix /windows/files/path

# Show all string info specific port
tcpdump -n -i ens160  port 8443  -s 0  -w -| strings

# show all gpg key on the system
rpm -qa gpg-pubkey \* --qf "%{version}-%{release} %{summary}\n"
rpm --import http:gpgkey

#Delete 
rpm -e --allmatches  gpg-pubkey-xxxxxxxx-xxxxxxxx



# Find  5 days ago logs and delete
find /usr/logs/reports.log.* -type f -mtime -5  -exec  rm -rf  {} \; 2>/dev/null
find /usr/logs/server.log.* -type f -mtime -5  -exec  rm -rf  {} \;  2>/dev/null 
find /usr/logs/transfer_server.log.* -type f -mtime -5  -exec  rm -rf  {} \; 2>/dev/null
ls -t /export/home/application????????.tar.gz | sed -e '1,6d' | xargs -d '\n'  rm -rf

#Show only directories which daxilinde hansi falin oyuk oldugunu gostermir ancaq direktoriya
du -hs /* | sort -rh | head -5

#Show only specific files on large size on within directory 
du -Sh / * | sort -rn | head -5     

find -type f -exec du -Sh {} + | sort -rh | head -n 5d
du command: Estimate file space usage.
-h : Print sizes in human readable format (e.g., 10MB).
-S : Do not include size of subdirectories.
-s : Display only a total for each argument.
sort command : sort lines of text files.
-r : Reverse the result of comparisons.
-h : Compare human readable numbers (e.g., 2K, 1G).
head : Output the first part of files.


# Stop default services 
chkconfig avahi-daemon off
service  avahi-daemon stop
Printer Service
chkconfig cups off
service cups stop
Master Service 25 port(Bu Send mailde ola biler)
service postfix stop 
chkconfig postfix off

systemctl disable avahi-daemon.socket avahi-daemon.service
systemctl stop avahi-daemon.socket avahi-daemon.service

#Process Info
#RSS,Ram usage without swap and allocated to process 
ps -orss= -p $(ps aux | grep -iE ^proxy  | awk '{print $2}')
#VSZ
Ram usage  and allocated to process 
ps -ovsz= -p $(ps aux | grep -iE ^proxy  | awk '{print $2}')
#VSZ – Virtual Set Size
The memory size which is assigned to a process(program) during the initial execution is Virtual Set Size (VSZ)and it simply denotes how much memory is available for execution of that process.
#RSS – Resident Set Size
As oppose to VSZ ( Virtual Set Size ), RSS is a memory currently used by a process. This is a actual number in kilobytes of how much RAM the current process is using and is the actual memory utilised by a JVM.




# cat, grep. awk,vim,sed
cat filename | awk '{print $5}' | cut -d ':' -f 2 | egrep -x  '.{1,4}' |awk 'BEGIN{ORS=" ";} {print;}'awk 'BEGIN{ORS=" ";} {print;}' | cut -b -70
awk '{print $5}' - ancaq besinci setrde olanlari siyahilayir.
cut -d ':' -f 2 - iki noqte tapandan sonraki ilk setri verir
egrep -x  '.{1,4}' -  daxilinde 4 string olan sozleri gosterir.
awk 'BEGIN{ORS=" ";} {print;}' - convert column to row
cut -b -70  -- ancaq birinci ilk 70 setr goster

"Abc Inc";
sed 's/;$//' 
#change to "Abc Inc"

#'CreditInfo' to convert to CreditInfo
cut  -d\' -f2

#Show from specific date
sed -n '/Apr 29 09:26:22/,$p' messages2019-04-29


#VIM
:set nu       //show nummbers
for comment 
77,99s/^/#
for uncomment
77,99s/^#/ 
----------------------
#Only matching numbers off file
echo "99%" |grep -o '[0-9]*'
99
-------------------------------
#Copy,delete,paste large block on vim linux
-v --- bu saga ve sola sozbe soz nisanlamaq uchundur
-V  --- bu asagai ve yuxari setr setr nisanlamaq uchundur

#artiq secdikden sonra
-d --- simke uchundur, hemcinide cut edir
-y --- ise copy etme uchundur
-p  --- oldugun kursordan sonra paste etmek uchundur
-P  --- oldugun cursordan evvele paste etmek uchun
-c   --- If you want to change the selected text, press c instead of d or y in
du -sh * | sort -rn  | awk '{print $1}' | grep -o '[0-9]*' 
------------------------------------------------------------------------------------
kill -9 $(ps -aux | awk '/pts/ {print $2}' | awk 'BEGIN{ORS=" ";} {print;}')

# ip addr | grep inet | grep -v inet6 | cut -d' ' -f6 | cut -d'/' -f1
127.0.0.1
192.168.2.152
192.168.122.1
#Show Cpu model
 cat /proc/cpuinfo  | grep name | uniq -d | cut -d : -f2
 Intel(R) Core(TM) i5-6200U CPU @ 2.30GHz
#Show login users
 who | cut –d ‘ ’ –f1
#Show what services using port
 grep -w PORT /etc/services  | cut -d" " -f1 | uniq
#Show as below
grep “xroot” /etc/passwd | cut –d : -f1-6  --output-delimetr=$’\n’

#Eger siz cut ile delimetr sece bilmirsinizse onda onlar arasinda sadece bir dene bosluq yaradib onla sece bilersiniz .
ps axu | grep python | sed 's/\s\+/ /g' | cut -d' ' -f2,11-


##Execute script on screen
screen -d -m -S echo bash -c 'cd /opt/socketServer && ./echoserver.py'
#List
screen -ls
# Share screen another people on same linux server
screen -t preprod
Attach it screen -x 
##Netstat
netstat -nlatp | grep LIST | awk '{print $4,$7}' | awk -F: '{print $2}' | awk -F/ '{print $1,$2}' | awk '{print $1,$3}' | sort -nu
##Tshark
tshark -i lo0 'tcp port 65432'
##Tcpdump
tcpdump -vv -i any -s 65535  port 65432  -X -s0
tcpdump -tttt -n -vv -i any -s 65535  port 65432  -s0
tcpdump port http or port ftp or port smtp or port imap or port pop3 or port telnet -lA | egrep -i -B5 'pass=|pwd=|log=|login=|user=|username=|pw=|passw=|passwd= |password=|pass:|user:|username:|password:|login:|pass |user '
https://danielmiessler.com/study/tcpdump/#cookies
Lsof:
Tmux:
## Strace:
strace  -e trace=file /usr/bin/sshd
strace -e trace=connect mysql -h nickdev.marden.reading.ma.us
strace   -c ls
man 2 syscall


## diff: check two file differences
diff -ay file1 file2

#Fuser for find which file or directory is using from pid or network
yum install psmisc-22.20-15.el7.x86_64
fuser -v /var/log/*


## reboot linux another way
echo 1 > /proc/sys/kernel/sysrq
echo b > /proc/sysrq-trigger