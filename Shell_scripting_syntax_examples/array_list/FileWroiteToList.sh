#!/bin/bash
eCollection=( $(cut -d ',' -f2 MyAssignment.csv ) )
printf "%s\n" "${eCollection[0]}"
#!/bin/bash
N=0
ARR=()
IFS=","
while read STR
do
        set -- "$STR"

        while [ "$#" -gt 0 ]
        do
                ARR[$N]="$1"
                ((N++))
                shift
        done
done < input.csv