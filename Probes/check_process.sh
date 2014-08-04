#!/usr/bin/env bash

# check available memory
# arg1: server name
# arg2: server address
# arg3: process name
check_process() {
    local name="$1"
    local server="$2"
    local process=$3
    echo "Checking $name is running '$process'"
    process_count=`ex cli "$server" "ps ax | grep '$process' | grep -v grep | wc -l"`
    if [ $process_count -ne 1 ]
    then
        alert mobile "Host '$name': Process '$process' not responding"
    fi
}

tb_update_probe check_process
