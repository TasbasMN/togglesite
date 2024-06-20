#!/bin/bash

# File to store domain and IP mappings
MAPPING_FILE="/tmp/domain_ip_mappings.txt"

# Function to resolve domain to IP address
resolve_domain() {
    domain=$1
    ip=$(dig +short A $domain | head -n 1)
    if [ -z "$ip" ]; then
        echo "Could not resolve domain: $domain"
        exit 1
    fi
    echo $ip
}

# Function to check if an IP address is currently blocked
is_blocked() {
    ip=$1
    sudo iptables -L INPUT -v -n | grep "$ip" > /dev/null 2>&1
    return $?
}

# Function to block access to an IP address
block_ip() {
    ip=$1
    domain=$2
    echo "Blocking access to $domain ($ip)..."
    sudo iptables -A INPUT -s $ip -j DROP
    echo "$domain $ip" >> $MAPPING_FILE
    echo "Access to $domain ($ip) has been blocked."
}

# Function to unblock access to an IP address
unblock_ip() {
    ip=$1
    domain=$2
    echo "Unblocking $domain ($ip) in 5 minutes..."
    for i in {300..1}; do
        echo -ne "Time remaining: $i seconds\r"
        sleep 1
    done
    echo -ne "\nTime is up! Unblocking the site now.\n"
    sudo iptables -D INPUT -s $ip -j DROP
    grep -v "$domain $ip" $MAPPING_FILE > /tmp/mappings.tmp && mv /tmp/mappings.tmp $MAPPING_FILE
    echo "Access to $domain ($ip) has been unblocked."
}

# Function to unblock all sites immediately
unblock_all() {
    echo "Unblocking all sites immediately..."
    sudo iptables -F INPUT
    > $MAPPING_FILE
    echo "All sites have been unblocked."
}

# Function to list currently blocked IP addresses and their domains
list_blocked() {
    echo "Currently blocked domains and IP addresses:"
    if [ -f $MAPPING_FILE ]; then
        while read -r line; do
            domain=$(echo $line | awk '{print $1}')
            ip=$(echo $line | awk '{print $2}')
            echo "$domain ($ip)"
        done < $MAPPING_FILE
    else
        echo "No blocked sites found."
    fi
}

# Main script logic
if [ -z "$1" ]; then
    echo "Usage: $0 <domain> | --unblockall | --list"
    exit 1
fi

if [ "$1" == "--unblockall" ]; then
    unblock_all
    exit 0
fi

if [ "$1" == "--list" ]; then
    list_blocked
    exit 0
fi

domain=$1

# Add www prefix if not present
if [[ ! $domain =~ ^www\. ]]; then
    domain="www.$domain"
fi

ip=$(resolve_domain $domain)

# If the resolved IP is a CNAME, resolve it to an IP address
if [[ $ip == *.*.*.* ]]; then
    ip=$(getent ahosts $ip | grep "STREAM" | awk '{print $1}' | head -n 1)
fi

if is_blocked "$ip"; then
    unblock_ip "$ip" "$domain"
else
    block_ip "$ip" "$domain"
fi
