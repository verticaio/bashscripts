#!/bin/bash
# setupapachevhost.sh - Apache webhosting automation demo script
file=/root/shell_scripting/domains.txt
IFS='|'
while read -r domain ip webroot username 

do

printf " ****Adding %s to httpd.conf ....\n" $domain
  printf "Setting virtual host using %s ip...\n" $ip
        printf "DocumentRoot is set to %s\n" $webroot
        printf "Adding ftp access for %s using %s ftp account...\n\n" $domain $username

done < "$file"
