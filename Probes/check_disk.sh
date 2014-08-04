#!/usr/bin/env bash

# check available memory
# arg1: server name
# arg2: server address
# arg3: % threshold
check_disk() {
    local name="$1"
    local server="$2"
    local threshold=$3
    echo "Checking disk space on $name"
    freedisk_pct_f=`ex cli "$server" "df / | awk '!/Filesystem/ { sub(/%/, \"\"); print 100-\\$5 }'"`
    freedisk_pct=${freedisk_pct_f/.*}
    if ((freedisk_pct<threshold))
    then
        alert mobile "Host '$name': Disk free is ${freedisk_pct}%"
    fi
}

tb_update_probe check_disk
