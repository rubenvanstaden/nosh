#!/usr/bin/env bash

set -e

[[ -z "$CONFIG_NOSTR" ]] && echo "ERROR: variable CONFIG_NOSTR not set" && exit 1

# Parse config file into local data structure.
config_data=$(cat "$CONFIG_NOSTR")

pubkey="$NPUB"
created_at=$(date +%s)
kind=1
content=$1

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

# 3. Publish EVENT to every relay listed in config.

relay_list=$(echo "$config_data" | jq -r '.relays[]')
while IFS= read -r relay; do
      # Add your logic here to process each relay
    echo "$msg"
    echo "$msg" | websocat --no-close --text "$relay" & echo $! > /tmp/websocat_pid.txt
done <<< "$relay_list"
