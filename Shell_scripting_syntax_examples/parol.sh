#!/bin/bash


read -p "Zehmet olmasa logini daxil edin:" login 
read -sp "Zehmet olmasa parolunuz daxil edin:" parol 


file1=/root/shell_scripting/babak.txt
file2=/root/shell_scripting/parol.txt
IFS=' '
echo "\n"

if [ $login -eq $file1 && $parol -eq $file2 ] ; then

echo "Siz sisteme $login istifadeci ile daxil oldunuz. Tebrikler."

else

echo "Siz login ve parolu sehv daxil etmisiniz sehmet olmasa birde yoxlayin"

fi 

