#!/bin/bash



NME=$(hostname)

input="/home/prsharma/list.txt"
while IFS= read -r var

do
salt $var cmd.run "echo $var > /tmp/$var.txt && cat /etc/redhat-release >> /tmp/$var.txt && rpm -qa >> /tmp/$var.txt"
salt $var cmd.run "curl --insecure --user root:J@ckp0t5 -T /tmp/$var.txt sftp://10.173.96.207/home/prsharma/hostlist/"
done < "$input"




