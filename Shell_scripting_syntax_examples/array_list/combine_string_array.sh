#! /bin/sh
str_array1=("Magento 2.2.4" "WooCommerce")
str_array2=("CodeIgnitor" "Laravel")
combine=(str_array1 str_array2)
for arrItem in ${combine[@]}
do
   eval 'for val in "${'$arrItem'[@]}";do echo "$val";done'
done