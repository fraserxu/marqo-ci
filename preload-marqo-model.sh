#!/bin/bash

set -eu

./run_marqo.sh &

# MODEL="open_clip/ViT-B-32/laion2b_s34b_b79k"
MODEL="hf/e5-small-v2"

# The host and port to check
HOST="localhost"
PORT=8882
INDEX="my-first-index"

# The number of retries
RETRIES=30

# The delay between retries in seconds
DELAY=5

# Function to check if the server is up
check_server() {
    nc -z $HOST $PORT
    return $?
}

# Function to create index
create_index() {
  echo "Create a fake index to load model"

  echo "==> Create index"
  curl -X POST -H 'Content-type: application/json' http://$HOST:$PORT/indexes/$INDEX -d "{
      \"model\": $MODEL
  }"
}

# Retry until the server is up or we run out of retries
for (( i=1; i<=RETRIES; i++ ))
do
    if check_server; then
        echo "Server is up!"
        create_index
        exit 0
    else
        echo "Waiting for server to start... ($i/$RETRIES)"
        sleep $DELAY
    fi
done
