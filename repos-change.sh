#!/bin/bash

grep -onr 7.3 /etc/yum.repos.d/*

if [ $? -eq 0 ]
then 
sed -i 's/7.3/7.6/g' /etc/yum.repos.d/*
echo changed repo to 7.6
fi

grep -onr 7.4 /etc/yum.repos.d/*

if [ $? -eq 0 ]
then 
sed -i 's/7.4/7.6/g' /etc/yum.repos.d/*
echo changed repo to 7.6
fi

grep -onr 7.5 /etc/yum.repos.d/*

if [ $? -eq 0 ]
then 
sed -i 's/7.5/7.6/g' /etc/yum.repos.d/*
echo changed repo to 7.6
fi

grep -onr 6.7 /etc/yum.repos.d/*

if [ $? -eq 0 ]
then 
sed -i 's/6.7/6.10/g' /etc/yum.repos.d/*
echo changed repo to 6.10
fi

grep -onr 6.8 /etc/yum.repos.d/*

if [ $? -eq 0 ]
then 
sed -i 's/6.8/6.10/g' /etc/yum.repos.d/*
echo changed repo to 6.10
fi

grep -onr 6.9 /etc/yum.repos.d/*

if [ $? -eq 0 ]
then 
sed -i 's/6.9/6.10/g' /etc/yum.repos.d/*
echo changed repo to 6.10
fi


