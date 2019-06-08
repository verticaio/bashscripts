#!/bin/bash
PORT="8888"
    case $1 in
         start)
              cd /usr/local/collectd-web/
              python runserver.py 2> /tmp/collectd.log &
              sleep 1
              stat=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"| cut -d":" -f2 | cut -d" " -f1`
            if [[ $PORT -eq $stat ]]; then
              sock=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"`
              echo -e "Server is  still running:\n$sock"
            else
              echo -e "Server has stopped"
            fi
            ;;
         stop)
              pid=`ps -x | grep "python runserver.py" | grep -v "color"`
              kill -9 $pid 2>/dev/null
              stat=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"| cut -d":" -f2 | cut -d" " -f1`
            if [[ $PORT -eq $stat ]]; then
              sock=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"`
              echo -e "Server is  still running:\n$sock"
            else
              echo -e "Server has stopped"
            fi
            ;;
        status)
              stat=`netstat -tlpn 2>/dev/null |grep $PORT| grep "python" | cut -d":" -f2 | cut -d" " -f1`
            if [[ $PORT -eq $stat ]]; then
              sock=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"`
              echo -e "Server is running:\n$sock"
            else
              echo -e "Server is stopped"
            fi
            ;;
        *)
        echo "Use $0 start|stop|status"
        ;;
        esac