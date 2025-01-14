FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    clamav \
    clamav-daemon \
    ca-certificates \
    wget && \
    rm -rf /var/lib/apt/lists/*

COPY etc/clamav /etc/clamav/
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 3310

ENTRYPOINT ["/docker-entrypoint.sh"] 