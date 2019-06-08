#!/bin/bash
DataList=" HTML5, CCS3, BootStrap, JQuery "
Field_Separator=$IFS
 
# set comma as internal field separator for the string list
IFS=,
for val in $DataList;
do
echo $val
done
 
IFS=$Field_Separator