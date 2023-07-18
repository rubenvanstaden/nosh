#!/usr/bin/env bash

set -e

pid=$(cat /tmp/websocat.pid)

while IFS= read -r line
do
    if [[ "$line" == '["EOSE","1"]' ]]; then
        kill "$pid"
        break
    fi

    content=$(echo "$line" | jq -r '.[2].content')
    echo "Received: $content"

    created_at=$(echo "$line" | jq -r '.[2].created_at')
    timestamp=$(date -r "$created_at")
    echo "Timestamp: $timestamp"

done < /tmp/nostr_pipe

rm /tmp/nostr_pipe
