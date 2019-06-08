#! /bin/sh
 
# Define a list of string variable
stringList=WordPress,Joomla,Magento
 
# Use comma as separator and apply as pattern
for val in ${stringList//,/ }
do
   echo $val
done

numbers=3.3,3.6,3.9,4.2,3.9,3.0,4.6,2.9,3.0,4.5,3.8,4.6,3.2,2.8,2.2,5.9,2.9,2.9,3.6,3.3,3.3,2.7,3.1,3.0,5.7,4.0,5.0,4.4,2.7,3.7,3.1,3.1,3.3,2.9,3.9,2.0,4.5,2.4,4.1,3.4,3.8
N=0
echo ${#numbers[@]}
for num in ${numbers//,/ }
do
   N=$(awk "BEGIN {print ($N+$num)}")
done

echo $N