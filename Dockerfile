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

RUN echo -e " \n\
  fs.file-max = 51200 \n\
  \n\
  net.core.rmem_max = 67108864 \n\
  net.core.wmem_max = 67108864 \n\
  net.core.netdev_max_backlog = 250000 \n\
  net.core.somaxconn = 4096 \n\
  \n\
  net.ipv4.tcp_syncookies = 1 \n\
  net.ipv4.tcp_tw_reuse = 1 \n\
  net.ipv4.tcp_tw_recycle = 0 \n\
  net.ipv4.tcp_fin_timeout = 30 \n\
  net.ipv4.tcp_keepalive_time = 1200 \n\
  net.ipv4.ip_local_port_range = 10000 65000 \n\
  net.ipv4.tcp_max_syn_backlog = 8192 \n\
  net.ipv4.tcp_max_tw_buckets = 5000 \n\
  net.ipv4.tcp_fastopen = 3 \n\
  net.ipv4.tcp_mem = 25600 51200 102400 \n\
  net.ipv4.tcp_rmem = 4096 87380 67108864 \n\
  net.ipv4.tcp_wmem = 4096 65536 67108864 \n\
  net.ipv4.tcp_mtu_probing = 1 \n\
  net.ipv4.tcp_congestion_control = hybla \n\
  # for low-latency network, use cubic instead \n\
  # net.ipv4.tcp_congestion_control = cubic \n\
  " | sed -e 's/^\s\+//g' | tee -a /etc/sysctl.conf && \
  mkdir -p /etc/security && \
  echo -e " \n\
  * soft nofile 51200 \n\
  * hard nofile 51200 \n\
  " | sed -e 's/^\s\+//g' | tee -a /etc/security/limits.conf

EXPOSE $SRV_PORT/tcp $SRV_PORT/udp

# Run Shadowsocks
CMD ulimit -n 51200;ss-server -s $SRVV_ADDR \
  -p $SRV_PORT \
  -k ${PASSWORD} \
  -m $METHOD \
  -t $TIMEOUT \
  --fast-open \
  -d $DNS_ADDR \
  -d $DNS_ADDR_2 \
  -u \
  $ARGS