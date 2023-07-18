Bash scripts to use [nostr](https://nostr.com/) the [Unix Way](https://en.wikipedia.org/wiki/Unix_philosophy).

## Overview

Relay and user subscription information is kept in a local config file:

```shell
cat ~/.config/nostr/cfg.json
```

The purpose of these minimal scripts are not to manage your config file for you. This is best done with a higher level implemenation, like Go or Rust.

Therefore, you will have to manually add and remove relays and followings to your local config.

## Setup

1. First install the nostr [cli](rubenvanstaden/nostr: Notes and Other Zettels Transmitted by Relays) written in Go.

```shell
{
  "relays": [
    "ws://localhost:8080"
  ],
}
```

2. Install the script locally and set environment variables.

```shell
# Install path
export SCRIPT="$HOME/.local/bin"

# Relay to connect too.
export RELAY=ws://0.0.0.0:8080

make install
```

## Usage

1. Request events from relay and pipe the JSON response to a more clean output.

```shell
nreq | nshow
```

2. Publish text event to relay

```shell
nevent 'Hello friend'
```
