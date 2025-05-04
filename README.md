# Pi-hole with Unbound in a single Docker container

A single Docker container running both Pi-hole and Unbound.

[![Docker Build Status](https://github.com/stinobytes/pihole-unbound/actions/workflows/dockerhub-build-push.yml/badge.svg)](https://github.com/stinobytes/pihole-unbound/actions/workflows/dockerhub-build-push.yml)

This setup contains:
- Pi-hole (using the [official image](https://hub.docker.com/r/pihole/pihole)).
- Unbound DNS resolver, configured with DNS over TLS.

> [!NOTE]
> This setup uses host network mode, which means the container shares the network stack with the host.
> This is optimal for DNS services but means the container has direct access to the host network. **It is highly recommended to run this behind a firewall**.


## Prerequisites

- An operating system with Docker capabilities that runs 24/7 (recommended: Raspberry Pi 4/5 or Intel NUC with Ubuntu Server)
- Docker and Docker Compose installed ([installation guide](https://docs.docker.com/compose/install/))

## Setup

> [!IMPORTANT]
> Before starting, ensure no other services are using ports 53 (DNS), 80 (HTTP), and 443 (HTTPS) on your host machine.
>
> If you are installing this on Ubuntu (17.10+) or Fedora (33+), follow these steps first: https://github.com/pi-hole/docker-pi-hole/#installing-on-ubuntu-or-fedora
>
> TLDR:
> 1. `sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf`
> 2. `sudo sh -c 'rm /etc/resolv.conf && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf'`
> 3. `systemctl restart systemd-resolved`

### 1. Prepare the environment

1.1. Create a folder for the project:
```bash
mkdir pihole-unbound
cd pihole-unbound
```

1.2. Create the `docker-compose.yaml` file with the following content:
```yaml
services:
  pihole-unbound:
    container_name: pihole-unbound
    image: stinobytes/pihole-unbound:latest
    network_mode: host
    environment:
      PIHOLE_UID: ${HOST_UID}
      PIHOLE_GID: ${HOST_GID}
      TZ: ${TZ}
      FTLCONF_dns_listeningMode: "all"
      FTLCONF_dns_upstreams: 127.0.0.1#5335
    volumes:
      - './config/etc-pihole:/etc/pihole'
      - './config/etc-dnsmasq.d:/etc/dnsmasq.d'
    cap_add:
      - NET_BIND_SERVICE
      - NET_ADMIN
      - SYS_NICE
    healthcheck:
      test: ["CMD", "dig", "@127.0.0.1", "-p", "53", "pi.hole"]
      interval: 30s
      timeout: 10s
      retries: 3
    restart: unless-stopped
```

1.3. Create the `.env` file:
```bash
echo "HOST_UID=$(id -u)" > .env
echo "HOST_GID=$(id -g)" >> .env
```

1.4. Add your timezone to the `.env` file:
```bash
echo "TZ='UTC'" >> .env
```
*The single and double quotes should remain in the command.*

> [!TIP]
> You can find a list of timezones here (use the `TZ identifier` column):
> [list of timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List).

1.5. Create the required folder structure:
```bash
mkdir -p config/etc-pihole
mkdir -p config/etc-dnsmasq.d
```

### 2. Start the container

2.1. Start the container with the following command (if you are using the old version of Docker Compose, you may need to use `docker-compose` instead of `docker compose`).
```bash
docker compose up -d
```

2.2. Set the password for the web interface. **Change the password first!**<br>*It might take a few seconds for the container to start up. If you get an error, wait a few seconds and try again.*
```bash
docker exec pihole-unbound pihole setpassword "your_password"
```

2.3. You can now log into the Pi-hole admin interface at `http://<server-ip-address>/admin`.<br>If you are on the same device as the container, you can use `http://localhost/admin`.

### 3. Set Pi-hole as your DNS server

There are multiple ways to do this, [it is recommended to follow the official Pi-hole FAQ](https://discourse.pi-hole.net/t/how-do-i-configure-my-devices-to-use-pi-hole-as-their-dns-server/245). It has all the different ways explained.

### 4. Verify DNS resolution

After setup, verify Pi-hole and Unbound are working correctly (change `<server-ip-address>` to your server's IP address):
```bash
# Test Pi-hole DNS resolution
dig example.com @<server-ip-address>

# Test Unbound as recursive resolver
docker exec pihole-unbound dig example.com @127.0.0.1 -p 5335
```

### 5. Add additional blocklists (optional but recommended)

By default, Pi-hole comes with [Steven Black's blocklist](https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts). This may or may not be enough to fit your needs.

**(recommended)** In the Pi-hole admin interface (under `Lists`), you can add additional blocklists. I recommend this source: https://firebog.net/.

> [!TIP]
> You can add multiple lists at once, seperated by a space. If you are using firebog, you can copy and paste multple lines from each section.

After adding new lists you should update Gravity. Go to `Tools` > `Update Gravity` and press the update button. Stay on that page until the update has finished.

### 6. Container updates

It is recommended to check for updates regularly. Run this to update the container:
```bash
# Pull the latest image
docker compose pull

# Rebuild and restart the container with the latest image
docker compose up -d --build

# Clean up old images (optional)
docker image prune -f
```
