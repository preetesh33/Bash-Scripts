#!/bin/bash

dm=$(sudo fdisk -l | grep D | grep '/dev/sd' | cut -d ':' -f1 | cut -d '/' -f3 | grep -v sda | grep -v sdb 1> /tmp/tmpfile.txt )
input="/tmp/tmpfile.txt"

# check lvm
checklvm=$(sudo pvs)
if [ -z "$checklvm" ]
then
lvm="0"
else
lvm="1"
totalpvsize=$(sudo pvs --units k | awk '{print $5}' | awk '{total = total + $1}END{print total}')
totalpvused=$(df -k | grep dev | grep -v sd | grep -v tmp | awk '{print $3}' | awk '{total = total + $1}END{print total}')
totalpvfree=$(expr $totalpvsize - $totalpvused)
pvusedperc=$(awk "BEGIN { pc=100*${totalpvused}/${totalpvsize}; i=int(pc); print (pc) }")
pvunsedperc=$( echo '100' - $pvusedperc | bc)
fi

while IFS= read -r var
do
diskname="$var"
ds=$(sudo fdisk -l | grep D | grep '/dev/sd' | grep $var | awk '{print $3,$4}' | cut -d "," -f1 | sed 's/..$//')
disksize=$(awk "BEGIN { pc=${ds}*1024*1024; i=int(pc); print (pc) }")
hostname=$(hostname -s)

mntstate=$(lsblk -l -o NAME,MOUNTPOINT | grep -A1 $var | awk '{print $2}')
if [ -z "$mntstate" ]
then
mounted="0"
else
mounted="1"
fi

if [ "$lvm" == "1" ]
then
pvdisksize=$(sudo pvs --units k | grep $var | awk '{print $5}' | sed 's/.$//')
else
totalsize=$(df -k | grep $var | awk '{print $2}')
used=$(df -k | grep $var | awk '{print $3}')
available=$(df -k | grep $var | awk '{print $4}')
userdperc=$(df -k | grep $var | awk '{print $5}' | sed 's/.$//')
fi
#Hostname,Diskname,Disk Size,Mounted,Disk size,Disk usage,disk available,disk used perc,LVM,PV disk size,total PV size,PV used,PV free,PV used perc,PV unsed perc
echo "$hostname,$diskname,$disksize,$mounted,$totalsize,$used,$available,$userdperc,$lvm,$pvdisksize,$totalpvsize,$totalpvused,$totalpvfree,$pvusedperc,$pvunsedperc" >> /tmp/data.csv

done < "$input"


#####

#disksize=$(sudo fdisk -l | grep D | grep '/dev/sd' | grep $var | awk '{print $3,$4}' | cut -d "," -f1)
#totalsize=$(sudo pvs --units k | awk '{print $5}' | awk '{total = total + $1}END{print total}')
#echo "total size $totalsize"
#totalused=$(df -k | grep dev | grep -v sd | grep -v tmp | awk '{print $3}' | awk '{total = total + $1}END{print total}')
#echo "total used $totalused"
#memfree=$(expr $totalsize - $totalused)
#echo "total free mem $memfree"
#mempercused=$(awk "BEGIN { pc=100*${totalused}/${totalsize}; i=int(pc); print (pc) }")
#echo "percentage usage $mempercused"
#consuedperc=$( echo '100' - $mempercused | bc)
#echo $consuedperc
#
#pvsize=$(sudo pvs --units k | grep $var | awk '{print $5}' | xargs -n2 -d'\n' | awk '{sum+=$1+$2} END {print sum}')
#pvfree=$(sudo pvs --units k | grep $var | awk '{print $6}' | xargs -n2 -d'\n' | awk '{sum+=$1+$2} END {print sum}')
#tpvsize=$(sudo pvs --units k | awk '{print $5}' | awk '{total = total + $1}END{print total}')
#totalpvsize=$(df -k | grep dev | grep -v sd | grep -v tmp | awk '{print $2}' | awk '{total = total + $1}END{print total}')
#pvused="$(df -k | grep dev | grep -v sd | grep -v tmp | awk '{print $3}' | awk '{total = total + $1}END{print total}')"
#pvavailable="$(df -k | grep dev | grep -v sd | grep -v tmp | awk '{print $4}' | awk '{total = total + $1}END{print total}')"

