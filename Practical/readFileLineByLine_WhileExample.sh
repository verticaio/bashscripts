 #!/bin/bash
# IFS inputdan gelen datani istediyin kimi bolmekdir, yeni asagiki numunede nece oxusun
# OFS outputda cixan datani istediyin kimi bolmekdir
# Numune.
# cat /etc/passwd | awk '{print $1,$2}' FS=':' OFS='\t'
#!/bin/bash
file="/etc/passwd"
while IFS=: read -r f1 f2 f3 f4 f5 f6 f7
do
    # display fields using f1, f2,..,f7
    printf 'Username: %s, Shell: %s, Home Dir: %s\n' "$f1" "$f7" "$f6"
done <"$file"

#!/bin/bash
file="/home/vivek/data.txt"
while IFS= read -r line
do
        # display $line or do somthing with $line
	printf '%s\n' "$line"
done <"$file"

while read LINE;
do 
 	echo "$LINE" | cut -f1 -d":";
done < /etc/passwd

FILE=$1
while read LINE; do
     echo "This is a line: $LINE"
done < $FILE



#!/bin/bash
# BASH can iterate over $list variable using a "here string" #
while IFS= read -r pkg
do
    printf 'Installing php package %s...\n' "$pkg"
    /usr/bin/apt-get -qq install $pkg
done <<< "$list"
printf '*** Do not forget to run php5enmod and restart the server (httpd or php5-fpm) ***\n'
