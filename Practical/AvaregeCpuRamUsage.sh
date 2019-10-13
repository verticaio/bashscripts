#!/bin/bash
# Get Average CPU/Memory Utilization History from sysstat file in /var/log/sa/*
for file in $(ls -la /var/log/sa/* | grep sa[0-9] | awk '{print $9}')
do
        sar -f $file | head -n 1
        printf "\n"
        # Get CPU idle average, it's pretty straight forward.
        printf "CPU average: "
        sar -u -f $file | grep Average: | awk -F " " '{sum = (100 - $8) } END { print sum "%" }'
        # Get Average Memory utilization
        # Information being displayed in sar -r command is somewhat misleading.
        # As it is merely calculated by the formula kbmemused/(kbmemused+kbmemfree) * 100
        # But actually that was not the case, in order to get memory calculation, 
        # here's the revised formula to include memory cache/buffer information into account.
        #
        # Formula:
        # (kbmemused-kbbuffers-kbcached) / (kbmemfree + kbmemused) * 100
        # The reason behind this is Linux treats unused memory as a wasted resource and so uses as 
        # much RAM as it can to cache process/kernel information
        printf "Memory Average: "
        sar -r -f $file | grep Average | awk -F " " '{ sum = ($3-$5-$6)/($2+$3) * 100   } END { print sum "%" }'
        printf "\n"
done


















exit 0

for i in `ls /var/log/sa/|grep -E "sa[0-9][0-9]"`;do echo -ne "$i -- ";sar -r -f /var/log/sa/$i|awk '{ printf "%3.2f\n",($4-$6-$7)*100/(3+$4)}'|grep -Eiv "average|linux|^ --|0.00|^-" |awk '{sum+=$1 }END{printf "Average = %3.2f%%\n",sum/NR}';done
ldavg-5
System load average for the past 5 minutes.

ldavg-15
System load average for the past 15 minutes.

-r Report memory utilization statistics. The following values are displayed:

kbmemfree
Amount of free memory available in kilobytes.

kbmemused
Amount of used memory in kilobytes. This does not take into account memory used by the kernel itself.

%memused
Percentage of used memory.

kbbuffers
Amount of memory used as buffers by the kernel in kilobytes.

kbcached
Amount of memory used to cache data by the kernel in kilobytes.

kbcommit
Amount of memory in kilobytes needed for current workload. This is an estimate of how much RAM/swap is needed to guarantee that there never is out of memory.

%commit
Percentage of memory needed for current workload in relation to the total amount of memory (RAM+swap). This number may be greater than 100% because the kernel usually overcommits memory.

-R
Report memory statistics. The following values are displayed:

frmpg/s
Number of memory pages freed by the system per second. A negative value represents a number of pages allocated by the system. Note that a page has a size of 4 kB or 8 kB according to the machine architecture.

bufpg/s
Number of additional memory pages used as buffers by the system per second. A negative value means fewer pages used as buffers by the system.

campg/s
Number of additional memory pages cached by the system per second. A negative value means fewer pages in the cache.
