#!/bin/bash
chmod +x /etc/rc.local
echo "/root/autostart.sh" >> /etc/rc.local
chmod +x  /root/autostart.sh 
cd /export/home/user1/
/sbin/runuser user1 -s /usr/bin/sh -c './start.sh'
cd /export/home/user2/
/sbin/runuser user2 -s /usr/bin/sh -c './start.sh'
exit 0
