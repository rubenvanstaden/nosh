#!/usr/bin/env bash

set -e

[[ -z "$RELAY" ]] && echo "ERROR: env var $RELAY not set" && exit 1

websocat "$RELAY" | while IFS= read -r line
do
  echo "Received: $line"
done

exit 0
