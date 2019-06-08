#!/bin/bash
ls  -l az/com/cybernet/avis/ | awk '{print $9}' | grep -v -e  DeclarationPacketServer -e dts -e mandatory -e sd | tail -31
for i in decl dfs edh educ eval gate integ inv iqov kadr karg law mtm muk nkcek prognoz shv staff stra taxbank tools util voen vox
do
a=$(head -1  sonar-project.properties | cut -d':' -f2)
sed -i "s/$a/$i/g"  sonar-project.properties
echo -e " `date +%F`: Started Scanner $i Project " >>  sonar_scanner.log
echo -e "\n"
echo -e "   `date +%F`: Started Scanner $i Project " 
echo -e "\n"
/opt/sonar-runner/bin/sonar-runner  >>  sonar_scanner.log
if [ $? == 0 ];then
echo "Scanner works successfully for $i Project...."
echo -e "\n"
echo -e "  `date +%F`:Stopped Scanner $i Project " >>  sonar_scanner.log
echo -e "\n"
else
echo " Scanner doesn't  works successfully for $i Project...."
fi
done


## Check some directory java source code and analyzing codes and send sonarqube