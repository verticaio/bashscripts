#!/bin/bash
USER=root
HOST=10.153.0.89
PASS=pass
PORT=22
COMMAND=df -hT
> /root/.ssh/known_hosts
/usr/bin/expect<<EOF
spawn ssh -p $PORT $USER@$HOST 
expect "(yes/no)?"  {send "yes\r"}
expect "password:"  {send "$PASS\r"}
expect "#"          {send "df -hT\r"}
expect "#" 	    {send  "exit\r"}
expect eof
EOF


#NEW VARIANT

#!/usr/bin/expect -f
#user=root
#server=10.153.0.89
#mypassword=pass
spawn ssh -p 22 root@10.153.0.89 "df -hT"
grep -r 10.153.0.89 /root/.ssh/known_hosts >> /dev/null
  if [ $? -eq 0 ] ; then
     expect "(yes/no)?"
     send "yes\r"
  fi
expect "password:"
send "pass\r"
interact


------------------------------------------------------------------------#!/bin/bash

aptitude -y install expect

// Not required in actual script
MYSQL_ROOT_PASSWORD=abcd1234

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

aptitude -y purge expect



------------------------------------------------------------
#!/bin/bash
USER=root
HOST=10.153.0.89
PASS=pass
DBPASS=pass1
PORT=22
COMMAND=`mkdir test`
> /root/.ssh/known_hosts
/usr/bin/expect<<EOF
set timeout 20
spawn ssh -p $PORT $USER@$HOST 
expect "(yes/no)?"  {send "yes\r"}
expect "password:"  {send "$PASS\r"}
expect "#"          {send "mysql_secure_installation\r"}
expect "):"         {send "$PASS\r"}
expect "[Y/n]"      {send "y\r"}
expect "password:"  {send "$DBPASS\r"}
expect "password:"  {send "$DBPASS\r"}
expect "[Y/n]"      {send "y\r"}
expect "[Y/n]"      {send "y\r"}
expect "[Y/n]"      {send "y\r"}
expect "[Y/n]"      {send "y\r"}
expect "#"          {send  "exit\r"}
expect eof
EOF

------------------------------------------------------------------------------------
vim /ssh.exp
#!/usr/bin/expect

set timeout 20

set ip [lindex $argv 0]

set user [lindex $argv 1]

set password [lindex $argv 2]

spawn ssh "$user\@$ip"

expect "Password:"

send "$password\r";

interact

./ssh.exp 192.168.1.2 root password



-----------------------------------------------------------------------------------------
#!/usr/bin/expect
set timeout 9
set username [lindex $argv 0]
set password [lindex $argv 1]
set hostname [lindex $argv 2]
log_user 0

if {[llength $argv] == 0} {
  send_user "Usage: scriptname username \'password\' hostname\n"
  exit 1
}

send_user "\n#####\n# $hostname\n#####\n"

spawn ssh -q -o StrictHostKeyChecking=no $username@$hostname

expect {
  timeout { send_user "\nFailed to get password prompt\n"; exit 1 }
  eof { send_user "\nSSH failure for $hostname\n"; exit 1 }
  "*assword"
}

send "$password\r"

expect {
  timeout { send_user "\nLogin failed. Password incorrect.\n"; exit 1}
  "*\$ "
}

send_user "\nPassword is correct\n"
send "exit\r"
close


#https://www.pantz.org/software/expect/expect_examples_and_tips.html
#http://bertvv.github.io/notes-to-self/2015/11/16/automating-mysql_secure_installation/
#\https://gist.github.com/coderua/5592d95970038944d099
K@s@p!1733@
