# PiHole v6 with Unbound in a single Docker container

A single Docker container which contains both PiHole and Unbound.

This setup contains:
- PiHole v6 ([official image](https://hub.docker.com/r/pihole/pihole))
- Unbound

## Prerequisites

- An operating system with Docker capabilities that runs 24/7 (I recommend a Raspberry Pi 4/5 or Intel NUC with Ubuntu Server but any system will do).
- Have Docker and Docker Compose installed. ([installation guide](https://docs.docker.com/compose/install/))

## Setup

> [!NOTE]
> If you are installing this on Ubuntu (17.10+) or Fedora (33+), follow these steps first: https://github.com/pi-hole/docker-pi-hole/#installing-on-ubuntu-or-fedora.<br><br>
> TLDR:<br>1. `sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf`<br>
> 2. `sudo sh -c 'rm /etc/resolv.conf && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf'`<br>
> 3. `systemctl restart systemd-resolved`<br>

### 1. Prepare the environment

- 1.1. In your terminal, navigate to the root of the project (same location where the `docker-compose.yaml` file is).<br>Create a .env file with your PID and GID. This is to ensure the container user permissions match the host file ownership.
  ```bash
  echo "HOST_UID=$(id -u)" > .env
  echo "HOST_GID=$(id -g)" >> .env
  ```

- 1.2. Next, add your timezone to the .env file. Change this to your own timezone.
([list of timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones))<br>*The single and double quotes should remain in the command.*
  ```bash
  echo "TZ='Europe/Brussels'" >> .env
  ```

- 1.3. Create the necessary folder structure.
  ```bash
  mkdir -p config/etc-pihole
  ```

### 2. Start the container

- 2.1. Start up the container with the following command. If you are using the old version of Docker Compose, you may need to use `docker-compose` instead of `docker compose`.
  ```bash
  docker compose up -d
  ```

- 2.2. Set the password for the web interface. **Change the password first!**<br>*It might take a few seconds for the container to start up. If you get an error, wait a few seconds and try again.*
  ```bash
  docker exec pihole-unbound pihole setpassword "your_password"
  ```

- 2.3. You can now log into the PiHole admin interface at `http://<server-ip-address>/admin`.<br>If you are on the same device as the container, you can use `http://localhost/admin`.

### 3. Set PiHole as your DNS server

- There are multiple ways to do this, it is recommended to follow the official PiHole FAQ for this, it has all the different ways explained.<br>https://discourse.pi-hole.net/t/how-do-i-configure-my-devices-to-use-pi-hole-as-their-dns-server/245

### 4. (optional) Add additional blocklists

- By default, PiHole comes with Steven Black's blocklist.

- If you want to add additional blocklists, you can find them here: https://firebog.net/<br>Or google for new lists. You can add them in the PiHole admin interface.
