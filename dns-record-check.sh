#!/bin/bash

#Below scripts verifies A and PTR records of all nodes.
#Please create a file in "/root/host_list.txt" and add all hosts fqdn which needed validation.
#script success output will be shown in green and failed will shown red colour. 

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

input=/root/host_list.txt

while IFS= read -r var
do
host $var  > /dev/null
 if [ $? == 0 ]
   then 
     echo "${green}$var A record is present in DNS${reset}"
   else
     echo "${red}$var PTR record is not present in DNS${reset}"
 fi

PTR=$(host $var | awk '{print $4}')

host ${PTR} > /dev/null
 if [ $? == 0 ]
   then 
     echo "${green}$var PTR record is present in DNS${reset}"
   else
     echo "${red}$var PTR record is not present in DNS${reset}"
 fi

 done < "$input"
