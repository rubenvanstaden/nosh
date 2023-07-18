#!/usr/bin/env bash

set -e

[[ -z "$RELAY" ]] && echo "ERROR: env var $RELAY not set" && exit 1

id="your_id_here"
pubkey="$NPUB"
created_at=$(date +%s)
kind=1
content="hello friend"
sig="your_sig_here"

echo $created_at

# Construct the JSON object
json=$(jq -n \
    --arg id "$id" \
    --arg pubkey "$pubkey" \
    --argjson created_at "$created_at" \
    --argjson kind "$kind" \
    --arg content "$content" \
    --arg sig "$sig" \
    '{id: $id, pubkey: $pubkey, created_at: $created_at, kind: $kind, content: $content, sig: $sig}')

event="[\"EVENT\", $json]"

event=$(echo $event | tr -d '\n' | tr -d ' ')

echo -e "Connecting to relay: $RELAY"
echo -e "Publish event: $event"

echo "$event" | websocat -v "$RELAY"

exit 0
