# Use an official alpine
FROM alpine:latest

MAINTAINER WUAmin <wuamin@gmail.com>

ENV SRVV_ADDR 	0.0.0.0
ENV SRV_PORT 		8388
ENV PASSWORD=
# Encrypt methods:
# 								rc4-md5
# 								aes-128-gcm
# 								aes-192-gcm
# 								aes-256-gcm
# 								aes-128-cfb
# 								aes-192-cfb
# 								aes-256-cfb
# 								aes-128-ctr
# 								aes-192-ctr
# 								aes-256-ctr
# 								camellia-128-cfb
# 								camellia-192-cfb
# 								camellia-256-cfb
# 								bf-cfb
# 								chacha20-ietf-poly1305
# 								xchacha20-ietf-poly1305
# 								salsa20
# 								chacha20
# 								chacha20-ietf
ENV METHOD      aes-256-cfb
ENV TIMEOUT     300
ENV DNS_ADDR    8.8.8.8
ENV DNS_ADDR_2  1.1.1.1
ENV ARGS=




RUN apk --update upgrade --no-cache

# Install iptables & restore rules
# RUN apk --update add --no-cache iptables

# Set DNSs
# RUN echo "nameserver ${DNS_SERVERS1} \n\
# nameserver ${DNS_SERVERS2}" | tee /etc/resolv.conf

# Install build dependencies packages
RUN apk add --no-cache --virtual .build-deps \
	git \
	gcc \
	gettext \
	automake \
	make \
	asciidoc \
	xmlto \
	autoconf \
	build-base \
	curl \
	libev-dev \
	libtool \
	linux-headers \
	libsodium-dev \
	mbedtls-dev \
	pcre-dev \
	tar \
	c-ares-dev && \
  cd /tmp && \
  git clone https://github.com/shadowsocks/shadowsocks-libev.git && \
  cd shadowsocks-libev/ && \
  git submodule update --init --recursive && \
  ./autogen.sh && ./configure --prefix=/usr --disable-documentation && \
  make install && \
  cd .. && \
	# Remove build dependencies packages
	runDeps="$( \
	    scanelf --needed --nobanner /usr/bin/ss-* \
	        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
	        | xargs -r apk info --installed \
	        | sort -u \
	)" && \
	apk add --no-cache --virtual .run-deps $runDeps && \
	apk del .build-deps && \
	rm -rf /tmp/*


EXPOSE $SRV_PORT/tcp $SRV_PORT/udp

# Run Shadowsocks
CMD ss-server -s $SRVV_ADDR \
              -p $SRV_PORT \
              -k ${PASSWORD} \
              -m $METHOD \
              -t $TIMEOUT \
              --fast-open \
              -d $DNS_ADDR \
              -d $DNS_ADDR_2 \
              -u \
              $ARGS