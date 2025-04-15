# PiHole v6 with Unbound in Docker

A single Docker container which contains both PiHole ~~and Unbound~~.

This setup contains:
- PiHole v6 ([official image](https://hub.docker.com/r/pihole/pihole))

## Prerequisites

- An operating system with Docker capabilities that runs 24/7 (I recommend a Raspberry Pi or Intel NUC with Ubuntu Server but any system will do).
- Have Docker and Docker Compose installed. ([installation guide](https://docs.docker.com/compose/install/))

## Setup

### 1. Prepare the environment

> [!NOTE]
> If you are installing this on Ubuntu (17.10+) or Fedora (33+), follow these steps first: https://github.com/pi-hole/docker-pi-hole/#installing-on-ubuntu-or-fedora.<br>
> TLDR:<br>1. `sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf`<br>
> 2. `systemctl restart systemd-resolved`<br>
> (If you want to set it up as your DHCP server as well, follow the complete instructions in the link above)

- 1.1. Create a .env file with your PID and GID. This is to ensure the container user permissions match the host file ownership.
  ```bash
  echo "HOST_UID=$(id -u)" > .env
  echo "HOST_GID=$(id -g)" >> .env
  ```

- 1.2. Next, add your timezone to the .env file. Change this to your own timezone.
([list of timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones))<br>*The single and double quotes should remain in the command.*
  ```bash
  echo "TZ='Europe/Brussels'" >> .env
  ```

- 1.3. Add your password for the web interface to the .env file. **Change the password first.**<br>*The single and double quotes should remain in the command.*
  ```bash
  echo "WEBPASSWORD='change_me'" >> .env
  ```

### 2. Start the container

- 2.1. Start up the container with the following command:
  ```bash
  docker-compose up -d
  ```

- 2.2. You can now log into the PiHole admin interface at `http://<your-ip-address>/admin`.<br>If you are on the same device as the container, you can use `http://localhost/admin`.
