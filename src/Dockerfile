FROM pihole/pihole:2025.11.1

RUN apk update && \
    apk upgrade c-ares busybox && \
    apk add --no-cache unbound && \
    rm -rf /var/cache/apk/*

COPY unbound.conf /etc/unbound/unbound.conf

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
