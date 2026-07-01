#!/bin/bash


SECONDS=0
currentTime=$(date "+%Y.%m.%d-%H.%M.%S")
echo "Current Time : $currentTime"

echo "cleaning puppet cert"
echo

input="/home/prsharma/host.list.txt"
while IFS= read -r var
do

salt inpup01p1.paytv.smf1.mobitv cmd.run "/usr/bin/puppet cert clean $var"

if [ $? == 0 ]
then
echo
echo "puppet cert cleaned successfully"
else
echo "puppet cert failed to clean"
fi

echo y | salt-key -d $var

if [ $? == 0 ]
then
echo
echo "salt key deleted successfully"
else
echo
echo "salt key failed to delete"
fi

salt innsv01p1.infra.smf1.mobitv cmd.run "echo sw0rdf1sh | kinit admin"
salt innsv01p1.infra.smf1.mobitv cmd.run "ipa host-del --updatedns $var"

if  [ $? == 0 ]
 then
  echo "$var Forward and reverse zone deleted successfully"
else
  echo "$var record failed to remove from IPA"
fi

done < "$input"

endTime=$(date "+%Y.%m.%d-%H.%M.%S")
echo "End Time : $endTime"
echo "Total time taken to complete process: ${SECONDS} seconds"
