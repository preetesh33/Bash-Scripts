#!/bin/bash
input="/home/preeteshsh/modules/mbranch.txt"
while IFS= read -r var
do
  git clone git@bitbucket.org:mobitv/$var
  NS=$(echo $var | cut -d "." -f 1)
  echo $NS
  cd /home/preeteshsh/modules/$NS
  git checkout paytv
  git pull
  git checkout -b lumos
  git push --set-upstream origin lumos
  cd ..
  done < "$input"


echo "###############verifying branch####################"

while IFS= read -r var
do
NS=$(echo $var | cut -d "." -f 1)
echo $NS
cd $NS
git branch -a | grep lumos
if [ $? == 0 ]
then
echo "branch $var is created"
else
echo "Failed Failed Failed"
fi

cd ../
done < "$input"
