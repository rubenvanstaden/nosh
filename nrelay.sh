#!/usr/bin/env bash

set -e

[[ -z "$CONFIG_NOSTR" ]] && echo "ERROR: variable CONFIG_NOSTR not set" && exit 1

# Function to add a relay to the config file
add() {
  local relay="$1"
  local config_data

  # Check if config file exists
  if [[ -f "$CONFIG_NOSTR" ]]; then
    # Read config file contents
    config_data=$(cat "$CONFIG_NOSTR")

    # Append relay to the config data
    config_data=$(echo "$config_data" | jq --arg relay "$relay" '.relays += [$relay]')

    # Write the updated config data back to the file
    echo "$config_data" > "$CONFIG_NOSTR"

    echo "Relay added to config file."
  else
    echo "Config file not found: $CONFIG_NOSTR"
    exit 1
  fi
}

remove() {
  local relay="$1"
  local config_data

  # Check if config file exists
  if [[ -f "$CONFIG_NOSTR" ]]; then
    # Read config file contents
    config_data=$(cat "$CONFIG_NOSTR")

    # Remove relay from the config data
    config_data=$( echo "$config_data" | jq --arg relay "$relay" 'del(.relays[] | select(. == $relay))')

    # Write the updated config data back to the file
    echo "$config_data" > "$CONFIG_NOSTR"

    echo "Relay removed from config file."
  else
    echo "Config file not found: $CONFIG_NOSTR"
    exit 1
  fi
}

# Main script logic
case "$1" in
  --add)
    if [[ -n "$2" ]]; then
      add "$2"
    else
      echo "Error: Relay URL is missing."
      echo "Usage: nrelay --add <relay>"
      exit 1
    fi
    ;;
  --remove)
    if [[ -n "$2" ]]; then
      remove "$2"
    else
      echo "Error: Relay URL is missing."
      echo "Usage: nrelay --remove <relay>"
      exit 1
    fi
    ;;
  *)
    echo "Error: Invalid command."
    exit 1
    ;;
esac
