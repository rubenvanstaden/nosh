#!/usr/bin/env bash

set -e

[[ -z "$CONFIG_NOSTR" ]] && echo "ERROR: variable CONFIG_NOSTR not set" && exit 1

# Parse config file into local data structure.
config_data=$(cat "$CONFIG_NOSTR")

authors='[]'
kinds='[1]'
limit=20

json=$(jq -n \
    --argjson authors "$authors" \
    --argjson kinds "$kinds" \
    --argjson limit "$limit" \
    '{authors: $authors, kinds: $kinds, limit: $limit}')

# 2. Update local json with followings from config.

follow_list=$(echo "$config_data" | jq -r '.follows[]')
while IFS= read -r author; do
    json=$(echo "$json" | jq --arg author "$author" '.authors += [$author]')
done <<< "$follow_list"

# Trim and spaces and newlines.
msg=$(echo "[\"REQ\", \"1\", $json]" | jq -c '.')

# 3. Send the REQ message to every relay listed in config.

relay_list=$(echo "$config_data" | jq -r '.relays[]')
while IFS= read -r relay; do
      # Add your logic here to process each relay
    echo "$msg"
    echo "$msg" | websocat --no-close --text "$relay" & echo $! > /tmp/websocat_pid.txt
done <<< "$relay_list"
