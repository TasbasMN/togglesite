# Website Blocker

## Description

This Bash script provides a simple way to block and unblock websites using iptables. It resolves the IP addresses of the specified website and adds rules to iptables to block outgoing traffic to those IPs. The script also maintains a list of blocked websites for easy management.

## Features

- Block websites by domain name
- Unblock previously blocked websites
- List currently blocked websites
- Automatic IP resolution for domain names
- Delay mechanism for unblocking to deter you from wasting time

## Requirements

- Bash shell
- dig command (usually part of the dnsutils package)
- iptables (requires root privileges)
- sudo access for modifying iptables rules

## Usage

'''
bash
./togglesite.sh <website>
./togglesite.sh --list
'''

- To block a website: ./togglesite.sh example
- To unblock a website: Run the same command again
- To list blocked websites: ./togglesite.sh --list

Note: The script automatically appends ".com" to the provided website name.

## How it works

1. When blocking a website:
 - Resolves the IP addresses for the given domain
 - Adds iptables rules to drop outgoing traffic to these IPs
 - Adds the website to the blocked sites list

2. When unblocking a website:
 - Waits for 5 seconds before unblocking (with a countdown)
 - Removes the corresponding iptables rules
 - Removes the website from the blocked sites list

3. The list of blocked websites is stored in /tmp/blocked_sites.txt

## Permissions

This script requires sudo privileges to modify iptables rules. Make sure to run it with appropriate permissions.

## Disclaimer

Use this script responsibly. Blocking websites may have unintended consequences and could affect system or network functionality. Always ensure you have permission to modify network settings on the system you're using.

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to check issues page if you want to contribute.

# The 'Do Whatever You Want' License (DWYW)

Copyright (c) 2024 Nazif

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

1. You can do whatever you want with this Software.
2. The author is not responsible for anything you do with this Software.
3. The author provides no warranties or guarantees whatsoever.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Use at your own risk. The author bears no responsibility for any consequences resulting from the use, modification, or distribution of this Software.
