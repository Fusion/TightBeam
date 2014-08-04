#!/usr/bin/env bash

# check available memory
# arg1: server name
# arg2: server address
# arg3: % threshold
check_memory() {
    local name="$1"
    local server="$2"
    local threshold=$3
    echo "Checking free memory on $name"
    freemem_pct_f=`ex cli "$server" "free | awk '/Mem:/ { print \\$4*100/\\$2 }'"`
    freemem_pct=${freemem_pct_f/.*}
    if ((freemem_pct<threshold))
    then
        alert mobile "Host '$name': Free memory is ${freemem_pct}%"
    fi
}

tb_update_probe check_memory
