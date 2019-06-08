#!/bin/bash
# 10.153.0.65
# General path: /export/home/user/uzlesme
# Backup GPG files : /export/home/user/uzlesme/backupgpg
# Encrypted  dir: /export/home/user/uzlesme/en
# Decrypted dir which need by developer : /export/home/user/uzlesme/de

#!/bin/bash

echo -e "\n"
echo "............................. $(date)  Script Started ..........................."
echo -e "\n"

## Connect to SFTP server and take files
function sftp {
/usr/bin/expect<<EOF
set timeout 20
spawn sftp -oPort=$1 $2@$3
expect ":"          {send "$4\r"}
expect ">"          {send "cd IN/\r"}
expect ">"          {send "get * $5\r"}
expect ">"          {send "get * $6\r"}
expect ">"          {send "rm  *\r"}
expect ">"          {send  "exit\r"}
expect eof
EOF
}

## Decrypt files in which taken from sftp
function decrypt {
cd $1
for i in $(ls)
do
filename=$(ls $i | cut -d'.' -f1,2)
gpg --output $3/$filename -d --batch --yes  --passphrase $2 $i
  if [ "$?" -ne "0" ] ; then
           echo -e "TEST" | mail -s " File GPG Problem"  -r "babek.mammadov@gmail.com" -c test@gmail.com
  else
           echo "$filename No problem, File is ok"
  fi
done
rm -rf $1/*
}

echo ".............................  Main  Function Started ..........................."
function main {
echo ".............................  SFTP Function Started ..........................."
sftp "21" "user" "10.0.0.1" "Pass" "/export/home/user/uzlesme/en"  "/export/home/user/uzlesme/backupgpg"
echo ".............................  Decrypt Function Started ..........................."
decrypt "/export/home/user/uzlesme/en" "Pass" "/export/home/user/uzlesme/de"
}

main

echo -e "\n"
echo "............................. $(date) Script Stop ..........................."
echo -e "\n"

