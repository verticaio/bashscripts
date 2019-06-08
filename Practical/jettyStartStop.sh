#!/bin/bash
processPort=8081
command=$1
stop(){
 processID=$(netstat -anp | grep $processPort | egrep LISTEN | grep tcp | head -1 | awk '{print $7}' | awk -v FS='/' '{print $1}')
 if [ $processID > 0 ]; then
     kill -9 $processID
     if [ $? == '0' ]; then
         echo "$(date) : $processID process killed"
     else
         echo "$(date) : process kill problem"
     fi
  else
     echo "Jetty Process Already killed "
  fi
}

start() {
 ./server.sh &
  if [ $? == 0 ]; then
       echo "$(date) : Application Started ......"
  else
       echo "$(date) : Application start failed"
  fi

}

status() {
 status=$(netstat -anp | grep "$processPort" | grep -iE "LISTEN" | grep tcp | head -1 | awk '{print $7}' | awk -v FS='/' '{print $1}')
 if [ $status > '0' ]; then
     echo "Java $status id  Process is running"
 else
     echo "$(date) : process is not running"
 fi
}


case $command in 
    start)   start ;;
    stop)    stop ;;
    status)  status ;;
    restart) stop 
             start
             ;;
    *)      echo $"Usage: ./jetty.sh {start|stop|restart|status}"
            exit 1
esac