#!/bin/bash

#script helps to find host is present in your enviornment or not.

if [ -z $1 ]; then

echo "No argument provided. Enter a non FQDN host."
echo
echo "Usage: $0 <HOST>"
echo "eg: $0 "example"
exit

fi
domains="google.com yahoo.com <http://yahoo.comgmail.com> gmail.com <http://yahoo.comgmail.com> "
echo -e "Searching for the host $1 in domains:\n\n$domains\n"
for domain in $domains; do
result=$(host -t a $1.${domain})
if [ $? == 0 ]; then
echo $result
hostfound="TRUE"
fi
done

if [ "$hostfound" != "TRUE" ]; then
echo "Host not found"
fi
