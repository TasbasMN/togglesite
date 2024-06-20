#!/bin/bash

BLOCKED_SITES_FILE="/tmp/blocked_sites.txt"

block_website() {
    website=$1
    ips=$(dig +short $website)
    if [ -n "$ips" ]; then
        for ip in $ips; do
            sudo iptables -A OUTPUT -d $ip -j DROP
        done
        echo "$website" >> $BLOCKED_SITES_FILE
        echo "Website $website (IPs: $ips) has been blocked."
    else
        echo "Could not resolve IP for $website"
    fi
}

unblock_website() {
    website=$1
    delay=5  # 5 seconds delay

    echo "Unblocking $website in $delay seconds..."
    for ((i=delay; i>0; i--)); do
        echo -ne "Time remaining: $i seconds...\r"
        sleep 1
    done
    echo -e "\nUnblocking $website now."

    ips=$(dig +short $website)
    if [ -n "$ips" ]; then
        for ip in $ips; do
            sudo iptables -D OUTPUT -d $ip -j DROP 2>/dev/null
        done
        sed -i "/$website/d" $BLOCKED_SITES_FILE
        echo "Website $website (IPs: $ips) has been unblocked."
    else
        echo "Could not resolve IP for $website"
    fi
}

show_blocked_sites() {
    echo "Currently blocked sites:"
    if [ -f $BLOCKED_SITES_FILE ]; then
        cat $BLOCKED_SITES_FILE
    else
        echo "No sites are currently blocked."
    fi
}

if [ "$1" = "--list" ]; then
    show_blocked_sites
    exit 0
fi

site="$1"

if [ -z "$site" ]; then
    echo "Usage: $0 <website> or $0 --list"
    exit 1
fi

site="${site}.com"

if grep -q "$site" $BLOCKED_SITES_FILE 2>/dev/null; then
    unblock_website $site
else
    block_website $site
fi
