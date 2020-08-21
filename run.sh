#!/usr/bin/env bash

# Add a config file if instructed to use an external siad daemon.
if [ "$EXT_SIAD_HOST" ] && [ "$EXT_SIAD_PORT" ]; then
  cat <<EOT >siad_connection.json
{
  "agent": "Sia-Agent",
  "dataDirectory": "/sia",
  "apiAuthentication": "auto",
  "apiHost": "$EXT_SIAD_HOST",
  "apiPort": $EXT_SIAD_PORT,
  "modules": {
    "consensus": true,
    "explorer": false,
    "feeManager": true,
    "gateway": true,
    "host": false,
    "miner": false,
    "renter": true,
    "transactionPool": true,
    "wallet": true
  }
}
EOT
fi

# Use the `cat` utility in order assign a multi-line string to a variable.
SIASTREAM_CMD=$(
  cat <<-END
siastream \
  --siad-dir /sia \
  --siastream-dir /sia/data \
  --host 0.0.0.0
END
)

exec $SIASTREAM_CMD "$@"
