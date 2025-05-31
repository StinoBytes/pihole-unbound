FROM pihole/pihole:2025.05.1

RUN apk update && \
  apk add --no-cache unbound && \
  rm -rf /var/cache/apk/*

COPY unbound.conf /etc/unbound/unbound.conf

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
