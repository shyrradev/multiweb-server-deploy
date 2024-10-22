#!/bin/bash


USR="devops"

for host in `cat remhost`
do
        echo "#################################"
        echo "connecting to $host"
        echo "Pushing script to $host"
        scp multioswebsetup.sh $USR@$host:/tmp/
        sleep 1
        echo "####################################"
        echo "executing the script for $host"
        ssh $USR@$host sudo /tmp/multioswebsetup.sh
        ssh $USR@$host sudo rm -rf sudo /tmp/multioswebsetup.sh
        echo "##########################################"
done
