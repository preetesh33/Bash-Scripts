#!/bin/bash


# script helps to clone and checkout branches from bitbiucket.

input="/home/preetesh/branch.txt"
while IFS= read -r var
do
  git clone git@bitbucket.org:customer/$var
  NS=$(echo $var | cut -d "." -f 1)
  echo $NS
  cd /home/preetesh/modules/$NS
  git pull
  git checkout env
  git pull
  git checkout -b env
  git push --set-upstream origin new-env
  cd ..
  done < "$input"


echo "###############verifying branch####################"

while IFS= read -r var
do
NS=$(echo $var | cut -d "." -f 1)
echo $NS
cd $NS
git branch -a | grep environment
if [ $? == 0 ]
then
echo "branch $var is created"
else
echo "branch $var failed to created"
fi

cd ../
done < "$input"
