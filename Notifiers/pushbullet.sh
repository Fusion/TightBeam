#!/usr/bin/env bash

alert_pushbullet() {
    local api_key=<redacted>
    local find5_id=<redacted>
    local error_title="CFRMonitor Report"

    curl https://api.pushbullet.com/v2/pushes \
        -u ${api_key}: \
        -d ${find5_id} \
        -d type="note" \
        -d title="${error_title}" \
        -d body="$1" \
        -X POST

    echo .
}

tb_update_notifier alert_pushbullet mobile
