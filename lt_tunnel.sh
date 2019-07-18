#!/usr/bin/env bash

set -eo pipefail

# check for servers
if [[ -z "$@" ]]; then
    echo "You need to specify one or more WonderProxy server names"
    exit 4
fi

# check for lt creds
if [[ -z "$LT_USERNAME" || -z "$LT_ACCESS_KEY" ]]; then
    echo "You need to set SAUCE_USERNAME and SAUCE_ACCESS_KEY"
    exit 1
fi

# check for wonderproxy creds
if [[ -z "$WONDERPROXY_USER" || -z "$WONDERPROXY_PASS" ]]; then
   echo "You need to set WONDERPROXY_USER and WONDERPROXY_PASS"
   exit 2
fi

# check for tunnel path
if [[ -z "$LT_TUNNEL_PATH"  ]]; then
    echo "You need to set tunnel path,please set the LT tunnel binary path"
    exit 2
fi

# check for tunnel path
if [[ -z "$LT_DIR"  ]]; then
    echo "You need to set tunnel path,please set the LT tunnel binary path"
    exit 2
fi

# https://www.lambdatest.com/support/docs/local-testing-for-linux/
# https://www.lambdatest.com/support/docs/local-testing-for-macos/
wpport=56692 # -proxy-port
ltport=44000  # -port
# set up the temp directory
ltdir="$LT_DIR"
mkdir -p "$ltdir"

rm -f "$ltdir/$server.log"

# set up one sauce tunnel for each server passed on the command line
for server; do
    printf "server is $server \n"
    pidfile="$ltdir/$server.pid"

    # clean up old tunnels
    if [[ -f "$pidfile" ]]; then
        echo You already have a tunnel running for $server. \
            The PID is "$(cat "$pidfile")".
        continue
    fi
    rm -f "$pidfile"


    echo Starting a lambda tunnel for $server in the background. Check \
        "$ltdir/$server.log" for logs and output.
    "$LT_TUNNEL_PATH" \
       -user "$LT_USERNAME" -key "$LT_ACCESS_KEY" \
       -proxy-host "$server.wonderproxy.com" -proxy-user "$WONDERPROXY_USER" -proxy-pass "$WONDERPROXY_PASS"   \
       -proxy-port "$wpport"  -port "$ltport" -tunnelName "$server"  \
       > "$ltdir/$server.log" 2>&1 &
    # "$LT_TUNNEL_PATH" \
    #    -user "$LT_USERNAME" -key "$LT_ACCESS_KEY" \
    #    -port "$ltport"  \
    #    -tunnelName "$server"  \
    #    > "$ltdir/$server.log" 2>&1 &
    pid=$!
    echo "To kill $server tunnel pid is $!" 
    echo "$pid" >> "$ltdir/$server.pid"
    n=1
    echo "let tunnel name $server settle for 5 seconds"
    # continue until $n equals 5
    while [ $n -le 5 ]
    do
	    sleep 1
        n=$(( n+1 ))	 # increments $n
    done
   
    let "wpport += 1"
    let "ltport += 1"
done

printf "\n"

# check the logs if all the tunnels are up and running
echo Tunnels are spinning up, this may take a few seconds...
seconds=0
servers_done=""
in_progress=true
while [[ "$seconds" -lt 75 && $in_progress ]]; do
    in_progress=
    let "seconds += 1"

    for server; do
        log="$ltdir/$server.log"
        if [[ ! "$servers_done" =~ [[:space:]]$server[[:space:]] ]]; then
            if grep -q 'Secure connection established' "$log"; then
                servers_done="$servers_done $server "
            else
                in_progress=true
            fi
        fi
    done

    sleep 1
done

printf "\n"
for server; do
    if [[ "$servers_done" =~ [[:space:]]$server[[:space:]] ]]; then
        echo $server is ready
    else
        echo Something wrong please check logs
    fi
done