# ToggleSite

ToggleSite is a Bash script to manage the blocking and unblocking of IP addresses associated with domain names using `iptables`. It's like a bouncer for your internet, deciding who gets in and who stays out. Perfect for those moments when you just can't resist scrolling on x dot com.

## Prerequisites

- `dig` command (part of the `dnsutils` package) - because we need to dig up those IPs!
- `getent` command (part of the `glibc` package) - get 'em, tiger!
- `iptables` command - the ultimate gatekeeper.
- `sudo` privileges - because power comes with responsibility (and a password).

## Usage

```bash
./togglesite.sh <domain> | --unblockall | --list
```

### Arguments

- `<domain>`: The domain name to block or unblock. If the domain is not prefixed with `www.`, it will be added automatically. Because who doesn't love a good prefix?
- `--unblockall`: Unblocks all currently blocked IP addresses immediately. It's like a get-out-of-jail-free card for websites.
- `--list`: Lists currently blocked domains and their IP addresses. Roll call time!

### Examples

- To block or unblock a domain:
  ```bash
  ./togglesite.sh example.com
  ```

- To unblock all blocked IP addresses immediately:
  ```bash
  ./togglesite.sh --unblockall
  ```

- To list currently blocked domains and IP addresses:
  ```bash
  ./togglesite.sh --list
  ```

## How It Works

1. **resolve_domain**: Resolves a domain name to its corresponding IP address using the `dig` command. It's like a treasure hunt for IPs!
2. **is_blocked**: Checks if a given IP address is currently blocked using `iptables`. Are you in or out?
3. **block_ip**: Blocks access to a given IP address using `iptables` and stores the domain-IP mapping in a file. No entry for you!
4. **unblock_ip**: Unblocks access to a given IP address after a delay of 5 minutes and removes the domain-IP mapping from the file. Time's up, you're free to go!
5. **unblock_all**: Unblocks all currently blocked IP addresses immediately and clears the mapping file. Party time, everyone gets in!
6. **list_blocked**: Lists currently blocked domains and their IP addresses from the mapping file. Let's see who's on the naughty list.

## License

This project is licensed under the MIT License. Because sharing is caring, even for control freaks.
