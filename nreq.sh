#!/usr/bin/env bash

set -e

authors='[]'
kinds='[1]'
limit=8

json=$(jq -n \
    --argjson authors "$authors" \
    --argjson kinds "$kinds" \
    --argjson limit "$limit" \
    '{authors: $authors, kinds: $kinds, limit: $limit}')

# Capture the output of nrelay --list command
follow_list=$(nfollow --list)
# Loop over each relay URL
while IFS= read -r author; do
    json=$(echo "$json" | jq --arg author "$author" '.authors += [$author]')
done <<< "$follow_list"

# json=$(jq -n \
#     --argjson authors "$authors" \
#     --argjson kinds "$kinds" \
#     --argjson limit "$limit" \
#     '{authors: $authors, kinds: $kinds, limit: $limit}')

msg=$(echo "[\"REQ\", \"1\", $json]" | jq -c '.')

# Capture the output of nrelay --list command
relay_list=$(nrelay --list)
# Loop over each relay URL
while IFS= read -r relay; do
      # Add your logic here to process each relay
    echo "$msg"
    echo "$msg" | websocat --no-close --text "$relay" & echo $! > /tmp/websocat_pid.txt
done <<< "$relay_list"
