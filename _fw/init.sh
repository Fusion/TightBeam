#!/usr/bin/env bash

TMP=${BASH_SOURCE[0]}
TB_FW_PATH=${TMP%/*}
TB_PROBES_PATH="${TB_FW_PATH}/../Probes"
TB_SERVERS_PATH="${TB_FW_PATH}/../Servers"
TB_EXECUTORS_PATH="${TB_FW_PATH}/../Executors"
TB_NOTIFIERS_PATH="${TB_FW_PATH}/../Notifiers"

TB_COLOR_RED='\033[38;31m'
TB_COLOR_YELLOW='\033[38;33m'
TB_NO_COLOR='\033[0;00m'

if tput colors > /dev/null; then
    TB_DISPLAY_ERROR_START=$TB_COLOR_RED
    TB_DISPLAY_ERROR_END=$TB_NOCCOLOR
    TB_DISPLAY_INFO_START=$TB_COLOR_YELLOW
    TB_DISPLAY_INFO_END=$TB_NOCCOLOR
else
    TB_DISPLAY_ERROR_START=""
    TB_DISPLAY_ERROR_END=""
    TB_DISPLAY_INFO_START=""
    TB_DISPLAY_INFO_END=""
fi

declare -A tb_executors
export tb_executors
declare -A tb_notifiers
export tb_notifiers

tb_info() {
    echo -e "${TB_DISPLAY_INFO_START}$@${TB_DISPLAY_INFO_END}"
}

tb_error() {
    echo -e "${TB_DISPLAY_ERROR_START}$@${TB_DISPLAY_ERROR_END}"
}

tb_critical() {
    tb_error "$@"
    exit 1
}

tb_dump() {
    if [ "$#" -eq 0 ]; then
        tb_critical "Attempting to dump an empty array"
    fi
    local myArray=$1[@]
    tb_info "Dump array '$1':\n${!myArray}"
}

tb_update_probe() {
    echo "Loading probe: $1"
}

tb_update_server() {
    echo "Loading server: $1"
}

tb_update_executor() {
    if [ "$2" == "" ]; then
        description="$1"
    else
        description="$2"
    fi
    tb_executors[$1]=$description
    echo "Loading executor: $1"
}

tb_update_notifier() {
    if [ "$2" == "" ]; then
        description="$1"
    else
        description="$2"
    fi
    tb_notifiers[$1]=$description
    echo "Loading notifier: $1"
}

ex() {
    local mode="$1"
    shift
    for executor in ${!tb_executors[@]}
    do
        local ex_mode=${tb_executors[$executor]}
        if [ $ex_mode == $mode ]; then
            $executor "$@"
        fi
    done
}

alert() {
    local mode="$1"
    shift
    for notifier in ${!tb_notifiers[@]}
    do
        local nt_mode=${tb_notifiers[$notifier]}
        if [ $nt_mode == $mode ]; then
            $notifier "$@"
        fi
    done
}

bash_version_str=$(bash --version)
if ! [[ "$bash_version_str" =~ .*version.4.* ]]; then
    tb_critical "Please upgrade to Bash version >= 4\nIf you are on OS X: 'brew install bash'"
fi

for probe in ${TB_PROBES_PATH}/*.sh; do
    . $probe
done

for server in ${TB_SERVERS_PATH}/*.sh; do
    . $server
done

for executor in ${TB_EXECUTORS_PATH}/*.sh; do
    . $executor
done

for notifier in ${TB_NOTIFIERS_PATH}/*.sh; do
    . $notifier
done
