#!/usr/bin/env bash

set -eo pipefail

ltdir="$LT_DIR"

# kill tunnel instance based on pid
for server; do
    pidfile="$ltdir/$server.pid"

    if [[ -f "$pidfile" ]]; then
        pid="$(cat "$pidfile")"
        echo "Killing Lambda tunnel for $server, PID $pid"

        kill "$pid"
        while [ -e "/proc/$pid" ]; do
            sleep 0.1
        done

    else
        echo "No process ID for $server"
    fi

    rm -f "$ltdir/$server".*
done