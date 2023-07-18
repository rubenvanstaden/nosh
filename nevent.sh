#!/usr/bin/env bash

set -e

[[ -z "$RELAY" ]] && echo "ERROR: env var $RELAY not set" && exit 1

pubkey="$NPUB"
created_at=$(date +%s)
kind=1
content="event pushed"

echo $created_at

# Construct the JSON object
json=$(jq -n \
    --arg pubkey "$pubkey" \
    --argjson created_at "$created_at" \
    --argjson kind "$kind" \
    --arg content "$content" \
    '{pubkey: $pubkey, created_at: $created_at, kind: $kind, content: $content}')

event=$(echo -n "$json" | jq -c '.')

# Sign the event using external command
event=$(ncli event -sign "$event")

msg=$(echo "[\"EVENT\", ${event}]" | jq -c '.')

#echo -n "$event"
echo "$msg"

echo "$msg" | websocat --no-close --text "$RELAY"
