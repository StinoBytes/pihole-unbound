#!/bin/bash

# Start Unbound
unbound -c /etc/unbound/unbound.conf -d -vv &

# Wait for port 5335 to be ready
while ! nc -z 127.0.0.1 5335; do
  sleep 0.1
done

# Start PiHole
exec /usr/bin/start.sh
