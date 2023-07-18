#!/usr/bin/env bash

set -e

wpid=$(cat /tmp/websocat_pid.txt)

while read -r line
do

    type=$(echo "$line" | jq -r '.[0]')

    if [[ "$type" == "REQ" ]]; then
        echo "$line"
    fi

    if [[ "$type" == "EVENT" ]]; then

        echo ""

        created_at=$(echo "$line" | jq -r '.[2].created_at')
        timestamp=$(date -r "$created_at")
        echo "$timestamp"

        content=$(echo "$line" | jq -r '.[2].content')
        echo "└── $content"
    fi

    if [[ "$type" == "EOSE" ]]; then
        kill $wpid
        echo "EOSE"
        break
    fi

done
