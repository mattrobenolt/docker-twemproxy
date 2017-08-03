FROM alpine:3.6

RUN addgroup -S nutcracker && adduser -S -G nutcracker nutcracker

RUN apk add --no-cache 'su-exec>=0.2'

ENV TWEMPROXY_VERSION 0.4.1
ENV TWEMPROXY_REPOSITORY mattrobenolt/twemproxy
ENV TWEMPROXY_SHA 49a96c4884332524d78eab8774f0229aa4398431

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        ca-certificates \
        coreutils \
        gcc \
        linux-headers \
        libtool \
        make \
        musl-dev \
        wget \
    \
    && wget -O twemproxy.tar.gz "https://github.com/$TWEMPROXY_REPOSITORY/archive/$TWEMPROXY_SHA.tar.gz" \
    && mkdir -p /usr/src/twemproxy \
    && tar -xzC /usr/src/twemproxy -f twemproxy.tar.gz --strip-components=1 \
    && rm twemproxy.tar.gz \
    && cd /usr/src/twemproxy \
    && autoreconf -fvi \
    && ./configure \
    && make -j "$(nproc)" \
    && make install \
    && rm -rf /usr/src/twemproxy \
    && apk del .build-deps

ENV NUTCRACKER_RUNDIR /var/run/nutcracker

RUN mkdir -p /etc/nutcracker
COPY config.yml /etc/nutcracker/

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nutcracker", "-c", "/etc/nutcracker/config.yml"]
