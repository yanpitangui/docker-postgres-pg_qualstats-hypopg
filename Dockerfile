ARG PG_SERVER_VERSION=16


FROM postgres:${PG_SERVER_VERSION}

ARG PG_SERVER_VERSION

LABEL maintainer="yanpitangui"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.description="This repo contains the dockerfile for Postgres with HypoPG and PG Qualstats"

RUN apt-get update -o Acquire::CompressionTypes::Order::=gz \
    # HypoPG
    && apt-get install --no-install-recommends -y \
       postgresql-${PG_SERVER_VERSION}-hypopg \
       postgresql-${PG_SERVER_VERSION}-hypopg-dbgsym \
    && apt-get install --no-install-recommends -y postgresql-${PG_SERVER_VERSION}-pg-qualstats \
    && cd / && rm -rf /tmp/* && apt-get purge -y --auto-remove \
       gcc make wget unzip curl libc6-dev apt-transport-https git \
       postgresql-server-dev-${PG_SERVER_VERSION} pgxnclient build-essential \
       libssl-dev krb5-multidev comerr-dev krb5-multidev libkrb5-dev apt-utils lsb-release \
       libgssrpc4 libevent-dev libbrotli-dev \
    && apt-get clean -y autoclean \
    && rm -rf /var/lib/apt/lists/* \
    # remove standard pgdata
    && rm -rf /var/lib/postgresql/${PG_SERVER_VERSION}/

COPY load-extensions.sh /docker-entrypoint-initdb.d/
RUN chmod 755 /docker-entrypoint-initdb.d/load-extensions.sh
