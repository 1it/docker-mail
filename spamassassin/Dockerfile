FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    spamassassin \
    spamd \
    spamc \
    gpg \
    gpg-agent \
    dirmngr \
    gosu \
    wget \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN sa-update --no-gpg 

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 783

ENTRYPOINT ["/docker-entrypoint.sh"] 