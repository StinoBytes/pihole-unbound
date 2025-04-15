#!/bin/bash

# Start Unbound
unbound -c /etc/unbound/unbound.conf -d -vv &

# Wait for Unbound
sleep 1

# Start PiHole
exec /usr/bin/start.sh
