#!/bin/bash

# script helps to automate all pulp task.

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function create_repo(){

  pulp-admin login -u admin -p admin > /dev/null
   read -p "Please enter repository name you want to create: " repo
   read -p "Please enter relative url path for example:- 'centos/7.5/os': " rlsurl 
   read -p "Pease enter URL path from which you want to get feed: " feed
    echo "$repo creation is in process"
  pulp-admin rpm repo create --repo-id $repo --relative-url $rlsurl --serve-https=false --serve-http=true --feed $feed

if [ $? != 0 ]

then
  echo "Failed to create $repo"
else
  echo "$repo repository created successfully, sync/update/publish process started"
   pulp-admin rpm repo sync run --repo-id $repo &&
   pulp-admin rpm repo update --repo-id $repo --serve-http=true > /dev/null &&
   pulp-admin rpm repo publish run --repo-id $repo > /dev/null
  echo
  echo "$repo repository successfully synced and published"
fi

pulp-admin logout > /dev/null
}

function list_repos() {
pulp-admin login -u admin -p admin > /dev/null
pulp-admin repo list > /tmp/repos

if [ $? == 0 ]
then
  echo "All repos list are saved in '/tmp/repos'"
else
  echo "Failed to sync repos"
fi
pulp-admin logout > /dev/null
}

function delete_repo() {
    pulp-admin login -u admin -p admin > /dev/null
    read -p "Please enter repo-id you want to delete: " rpsdls
    pulp-admin rpm repo delete --repo-id $rpsdls  
    
     if [ $? == 0 ]
     then
       echo "$rpsdls deleted successfully"
     else
       echo "failed to delete $rpsdls, please makesure repository name is correct"
     fi
     pulp-admin logout > /dev/null
}

function upload_rpm() {
    pulp-admin login -u admin -p admin > /dev/null
    read -p "Please enter repository id you want to sync for e.g - 'test-el7' :  "  rpsn
    read -p "Please enter package name with its absolute path e.g - '/tmp/test-0.7.93-1.el7.x86_64.rpm' :  " upkg
    pulp-admin rpm repo uploads rpm --repo-id $rpsn --file $upkg

    if [ $? == 0 ]

     then
       echo "$upkg uploaded successfully in $rpsn"
       echo
       echo "$rpsn is now publishing..."
       pulp-admin rpm repo update --repo-id $rpsn --serve-http=true > /dev/null &&
       pulp-admin rpm repo publish run --repo-id $rpsn > /dev/null
       echo "$rpsn successfully published"
     else
       echo "failed to upload $upkg package in $rpsn repository, please makesure repo-id and package path is correct"
    fi
       pulp-admin logout > /dev/null
}

function sync_publish() {
    pulp-admin login -u admin -p admin > /dev/null
    read -p "Please enter repository name you want to re-sync:  "  rsc
    pulp-admin  rpm repo sync run --repo-id $rsc  

if [ $? == 0 ]
  then
    echo "$rsc re-synced, publishing started"
      pulp-admin rpm repo update --repo-id $rsc --serve-http=true > /dev/null &&
      pulp-admin rpm repo publish run --repo-id $rsc > /dev/null
    echo "$rsc successfully published"
  else
    echo "failed to re-sync $rsc, make sure repository name is correct"
  fi
       pulp-admin logout > /dev/null
}

function pulp_restart() {

  echo "restarting pulp services"
  
  for i in pulp_celerybeat.service pulp_resource_manager.service pulp_workers.service
  do 
  systemctl restart $i
  done
  
}

function search_rpm() {

  pulp-admin login -u admin -p admin > /dev/null
     read -p "Please enter package name you want to search:  "  rpmpkg
     read -p "Please enter repository id in which you want to search package:  " rpoid
  pulp-admin rpm repo content rpm --repo-id $rpoid --match filename=$rpmpkg
    
    if [ $? != 0 ]
  
    then
    echo "$rpmpkg is not present in $rpoid"
    fi
  pulp-admin logout > /dev/null
}

function repo_detail() {
  pulp-admin login -u admin -p admin > /dev/null
  read -p "Please enter repo id:  "  repodl
  pulp-admin repo list --details --repo-id $repodl
  pulp-admin logout > /dev/null
}

function update_repository_source() {
  pulp-admin login -u admin -p admin > /dev/null
  read -p "Please enter repo id, in which you want to update rpm source:  "  repodls
  echo "Below repository feed will get updated"
  pulp-admin repo list --details --repo-id $repodls | grep Feed:
  read -p "Please enter new source URL:  "  urepo
  pulp-admin rpm repo update --repo-id $repodls --feed=$urepo > /dev/null
  echo "Below rpm source is updated in repo-id $repodls"
  pulp-admin repo list --details --repo-id $repodls | grep Feed:
  pulp-admin logout > /dev/null
}


PS3=${green}'Please enter your choice: '${reset} 
echo
options=("Create new repository" "delete an existing repository" "list all repos in pulp" "upload rpm" "re-sync and publish existing repository" "search package within a repository" "restart pulp" "get repository details" "update existing repository source" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Create new repository")
            create_repo
            break
            ;;
        "delete an existing repository")
            delete_repo
            break
            ;;
        "list all repos in pulp")
            list_repos
            break
            ;;
        "upload rpm")
            upload_rpm
            break
            ;;
        "re-sync and publish existing repository")
            sync_publish
            break
            ;;
        "search package within a repository")
            search_rpm
            break
            ;;
        "get repository details")
            repo_detail
            break
            ;;  
        "update existing repository source")
            update_repository_source
            break
            ;;                        
        "restart pulp")
            restart_pulp
            break
            ;;            
        "Quit")
            echo ${yellow}"thank you for using $0"${reset}
            break
            ;;
        *) echo ${red}"invalid option $REPLY"${reset};;
    esac
done
