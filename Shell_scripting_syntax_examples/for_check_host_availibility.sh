#~/bin/bash

for i in {1..254};
do

ping -c 1 192.168.2.$i >/dev/null && echo " 192.168.2.$i is UP;"

done 
exit 0 
