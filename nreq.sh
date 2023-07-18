#!/usr/bin/env bash

set -e

[[ -z "$RELAY" ]] && echo "ERROR: $RELAY not set" && exit 1

pubkey="$NPUB"
authors="[\"${pubkey}\"]"
kinds='[1]'
limit=3

# json=$(jq -n \
#     --argjson authors "$authors" \
#     --argjson kinds "$kinds" \
#     --argjson limit "$limit" \
#     '{authors: $authors, kinds: $kinds, limit: $limit}')

json=$(jq -n \
    --argjson kinds "$kinds" \
    --argjson limit "$limit" \
    '{kinds: $kinds, limit: $limit}')

msg=$(echo "[\"REQ\", \"1\", $json]" | jq -c '.')

echo -e "Connected Relay: $RELAY"
echo -e "Request Message: $msg"

mkfifo /tmp/nostr_pipe

echo "$msg" | websocat --no-close --text "$RELAY" > /tmp/nostr_pipe &

echo $! > /tmp/websocat.pid
