#!/bin/bash
let result1=$1+$2
echo $1+$2=$result1 ' -> # let RESUTL1=$1+$2'
declare -i result2 
result2=$1+$2
echo $!+$2=$result2 ' -> declare -i result2; result2=$1+$2'
echo $1+$2=$(($1+$2)) ' -> # $(($1+$2))'
