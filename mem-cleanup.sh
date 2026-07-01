#!/bin/bash

# Lattice Generator memory/crash cleanup script

echo ""
echo "$(date +"%F %T.%3N") : Scanning shared memory segments started..."

lsof_output=`/usr/sbin/lsof /dev/shm/ | egrep "mem|DEL|deleted"`;
sharedFilesMREC=`ls /dev/shm/*MREC* 2>/dev/null`

if [ ! -z "$sharedFilesMREC" ]; then

  lsof_files=`grep -v "(deleted)" <<< "$lsof_output" | awk '{print $NF}'`

  unset lsofMap
  declare -A lsofMap

  for i in ${sharedFilesMREC}; do
     lsofMap+=([$i]=delete);
  done;
  for i in ${lsof_files}; do
    if [ ${lsofMap[$i]+_} ]; then
       unset lsofMap[$i] ;
    fi;
  done;

  if [ ${#lsofMap[@]} -gt 0 ]; then
     echo "The following stale files will be deleted..."
     for key in "${!lsofMap[@]}"; do
        echo -n "$key";
        rm -f "$key";
        ret=$?;
        [ $ret -eq 0 ] && echo " ... was successfully deleted" || echo  "... was not deleted with return code: "$ret;
     done
  fi
fi

deleted_files=`grep "(deleted)" <<< "$lsof_output"`;
if [ ! -z "$deleted_files" ]; then
   echo ""
   echo "The following files were found in lsof as deleted but are still being used by processes with pid: "
   echo ""
   unset deleteMapFiles
   declare -A deleteMapFiles
   awk  '{pid=deleteMapFiles[$(NF-1)]" ["$1" -> "$2"]"; deleteMapFiles[$(NF-1)]=pid} END{ for( key in deleteMapFiles) {print key":"deleteMapFiles[key]"\n"; }}' <<< "$deleted_files"
   echo ""
fi

echo "$(date +"%F %T.%3N") : Scanning shared memory segments completed..."
echo ""

