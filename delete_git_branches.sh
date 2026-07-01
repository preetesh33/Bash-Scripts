#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`
input="/home/preeteshsh/modules/mbranch.txt"

echo "${yellow}#####deleting branches############${reset}"

while IFS= read -r var
do
NS=$(echo $var | cut -d "." -f 1)
echo $NS
cd $NS
git pull
git push origin --delete lumos
if [ $? == 0 ]
then
echo "${green}branch $var deleted successfully${reset}"
else
echo "${red}Failed to delete $var branch${reset}"
fi

cd ../
done < "$input"