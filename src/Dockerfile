FROM pihole/pihole:2025.04.0

RUN apk update && \
  apk upgrade xz-libs && \
  apk upgrade libxml2 && \
  apk add --no-cache unbound && \
  rm -rf /var/cache/apk/*

COPY unbound.conf /etc/unbound/unbound.conf

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
