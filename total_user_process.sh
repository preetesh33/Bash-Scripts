#!/bin/bash

if [ "$#" -eq 0 ]
then
  echo "No user input passed."
  exit 1
fi

ps --user $1 | awk '{print $1}' | egrep -v "(grep|PID)"  > /tmp/alluser-process.txt

input="/tmp/alluser-process.txt"

while IFS= read -r var
do
  ls -l /proc/$var/task/ | grep -v total | awk '{print $NF}' | wc -l >> /tmp/pids.txt
done < "$input"
awk '{total = total + $1}END{print total}' /tmp/pids.txt
rm -rf /tmp/pids.txt
rm -rf /tmp/alluser-process.txt