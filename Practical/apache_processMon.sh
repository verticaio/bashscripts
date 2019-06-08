
while true ; 
do 
clear
echo "$(date) :  ##################################################################"   
echo -e  "Connections Counts:" 
netstat -an | grep ":80\|:443" | awk '{print $5}' | awk -v FS=':' '{print $1}' | sort | uniq -c ; 
echo "-----------------------------"
echo -e "Apache Thread: "; 
ps aux | grep -iE httpd | wc -l ; 
echo "-----------------------------"
echo "CPU statistic:"
#top -n 1 | grep 
mpstat -P ALL 1 | head -6 | tail -n 2| grep -v all
echo "-----------------------------"
echo "RAM statistic:"
#top -n 1 | grep 
free -m
echo "-----------------------------"
sleep 2s
echo "           ##################################################################"
echo ""
echo ""
done


while true ; 
  do
   clear
   # Connection Size
     echo "$(date) :  ##################################################################"   
     echo -e '\n'
     echo -e  "Connections Counts:" 
     echo -e  "Established:" 
     netstat -an | grep -iE ':80'| grep -iE 'estab' | awk '{print $5}' | awk -v FS=':' '{print $1}' | sort | uniq -c ;
     echo -e  "Close_WAIT:" 
     netstat -an | grep -iE ':80'| grep -iE 'close' | awk '{print $5}' | awk -v FS=':' '{print $1}' | sort | uniq -c ;
     echo -e  "Time_WAIT:" 
     netstat -an | grep -iE ':80'| grep -iE 'Time' | awk '{print $5}' | awk -v FS=':' '{print $1}' | sort | uniq -c ;
     echo -e  "GeneralCount:" 
     netstat -an | grep -iE ':80'| awk '{print $5}' | awk -v FS=':' '{print $1}' | sort | uniq -c ;
     echo -e '\n'
   # MEMORY
     echo "RAM statistic:"
     b=$(free -t -m | awk '{print $2}' | head -2 | tail -1)
     echo "Total Memory,it is calculated with MB:" $b
     a=$(bc -l <<< "$(ps -orss= -p $(ps -fu $USER | grep -iE 'tomcat' | grep -v grep | awk '{print $2}'))/1024")
     echo "Used memory from the $USER apps,it is calculated with MB:" $a| cut -d'.' -f1
     echo -e '\n'
   # CPU statistc
     echo "CPU statistic:"
     echo "$USER app cpu usage:" $(ps -eo pcpu,pid,user,args | grep proxy | grep java | awk '{print $1}' | tail -1)
     sleep 2
  done




