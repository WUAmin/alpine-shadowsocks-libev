# alpine-shadowsocks-libev
shadowsocks-libev server for Docker



## Build docker image
```bash
git clone https://github.com/WUAmin/alpine-shadowsocks-libev.git
cd alpine-shadowsocks-libev/
docker build --tag=alpine-shadowsocks-libev .
```

## Run docker container
```bash
docker run -d -e METHOD=aes-256-gcm -e PASSWORD=3se54uVqdgVU2rHd -p 8388:8388 --restart always alpine-shadowsocks-libev
```
You can generate stronge password in [here](https://duckduckgo.com/?q=password+16&t=ffsb&ia=answer)


# Use docker-compose (optional)
You can also use [docker-compose](https://github.com/docker/compose) to manage docker containers.

This is a simple example of a `docker-compose.yml` file.
```yml
shadowsocks:
  image: alpine-shadowsocks-libev
  container_name: shadowsocks-libev-server1
  ports:
    - "8388:8388"
  environment:
    - SRV_PORT=8388
    - METHOD=rc4-md5
    - PASSWORD=2UTz3UGfbz5YdkVf
    - DNS_ADDR=8.8.8.8
    - DNS_ADDR_2=8.8.4.4
    - TIMEOUT=300
    - SRVV_ADDR=0.0.0.0
  restart: always
```
and tun your `docker-compose.yml` file:
```bash
git clone https://github.com/WUAmin/alpine-shadowsocks-libev.git
cd alpine-shadowsocks-libev/
docker-compose up -d
docker-compose ps
```


## Client
Download shadowsocks client [here](https://shadowsocks.org/en/download/clients.html)