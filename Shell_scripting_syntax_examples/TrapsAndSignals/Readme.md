Traps - control of the flow of application and give us ability the ability to look for the the occurence of something,some types of event,some type of command,signal, something happening in system then redirect how to react to it.
Meselen  bi nov while loop script var hansi ki Q yazanda loopdan exit elemelidir ve  isteyirem ki kill  ve ya cntrl+C ile trapex.sh scriptini stop ede bilmeyim bunun uchun trap commandasindan istifade edecem. Bunuda trapex_demo.sh scriptinde gosterilib. 
Trap 2 ve ya bir cox parametr goture biler. Demo yazilan script tam etrafli qeyd olunub
Trap is a simple, but very useful utility. If your script creates temporary files, such as this simple script which replaces FOO for BAR in all files in the current directory, /tmp is clean when the script exits. If it gets interrupted partway through, though, there could be a file lying around in /tmp:

#!/bin/sh

trap cleanup 1 2 3 6

cleanup()
{
  echo "Caught Signal ... cleaning up."
  rm -rf /tmp/temp_*.$$
  echo "Done cleanup ... quitting."
  exit 1
}

### main script
for i in *
do
  sed s/FOO/BAR/g $i > /tmp/temp_${i}.$$ && mv /tmp/temp_${i}.$$ $i
done

The trap statement tells the script to run cleanup() on signals 1, 2, 3 or 6. The most common one (CTRL-C) is signal 2 (SIGINT). This can also be used for quite interesting purposes:

#!/bin/sh

trap 'increment' 2

increment()
{
  echo "Caught SIGINT ..."
  X=`expr ${X} + 500`
  if [ "${X}" -gt "2000" ]
  then
    echo "Okay, I'll quit ..."
    exit 1
  fi
}

### main script
X=0
while :
do
  echo "X=$X"
  X=`expr ${X} + 1`
  sleep 1
done

The above script is quite fun - it catches a CTRL-C, doesn't exit, but just changes how it's running. How this could be useful for positive and negative effect is left as an exercise to the reader:) This particular example concedes to quit after 4 interrupts (or 2000 seconds). Note that anything will be killed by a kill -9 <PID> without getting the chance to process it.

Here is a table of some of the common interrupts:
Number	SIG	Meaning
0	0	On exit from shell
1	SIGHUP	Clean tidyup
2	SIGINT	Interrupt
3	SIGQUIT	Quit
6	SIGABRT	Abort
9	SIGKILL	Die Now (cannot be trapped)
14	SIGALRM	Alarm Clock
15	SIGTERM	Terminate

Note that if your script was started in an environment which itself was ignoring signals (for example, under nohup control), the script will also ignore those signals. 