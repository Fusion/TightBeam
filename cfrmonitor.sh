#!/usr/bin/env bash

# include and initialize TightBeam and dependencies
. _fw/init.sh

sleep_duration=3600

while :
do

    check_memory ${violet[name]} ${violet[server]} 10
    check_disk ${violet[name]} ${violet[server]} 10
    check_process ${limon[name]} ${limon[server]} named

    echo "done... sleeping for ${sleep_duration} seconds"
    sleep ${sleep_duration}

done
