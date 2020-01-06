# alpine-shadowsocks-libev
shadowsocks-libev server for Docker



## Build docker image
This image compile shadowsocks-libev from [official github repository](https://github.com/shadowsocks/shadowsocks-libev)
```bash
git clone https://github.com/WUAmin/alpine-shadowsocks-libev.git
cd alpine-shadowsocks-libev
docker build --tag=alpine-shadowsocks-libev .
```

## Run docker container
```bash
docker run -d -e METHOD=aes-256-gcm -e PASSWORD=3se54uVqdgVU2rHd -p 8388:8388 --restart always alpine-shadowsocks-libev
```
You can generate stronge password in [here](https://duckduckgo.com/?q=password+16&t=ffsb&ia=answer)


# Use docker-compose (optional)
You can also use [docker-compose](https://github.com/docker/compose) to manage docker containers.

This is a simple example of a `docker-compose.yml` file that build image first. You can find it on `docker-compose-build-example/docker-compose.yml`.
```yml
shadowsocks-1:
  build: ..
  container_name: shadowsocks-1
  ports:
    - "${PORT}:${SRV_PORT}"
  environment:
    - SRV_PORT=${SRV_PORT}
    - METHOD=${METHOD}
    - PASSWORD=${PASSWORD}
    - DNS_ADDR=${DNS_ADDR}
    - DNS_ADDR_2=${DNS_ADDR_2}
  restart: always
```

Also, this is a simple example of a `docker-compose.yml` file that pull image from docker hub. You can find it on `docker-compose-pull-example/docker-compose.yml`.
```yml
shadowsocks-1:
  image: wuamin/alpine-shadowsocks-libev
  container_name: shadowsocks-1
  ports:
    - "${PORT}:${SRV_PORT}"
  environment:
    - SRV_PORT=${SRV_PORT}
    - METHOD=${METHOD}
    - PASSWORD=${PASSWORD}
    - DNS_ADDR=${DNS_ADDR}
    - DNS_ADDR_2=${DNS_ADDR_2}
  restart: always
```

This is a example of `.env` file. you can find it on docker-compose example folders.
```
PORT=50001
SRV_PORT=8388
METHOD=chacha20-ietf
PASSWORD=wVMGoSbbMHsjv3zn
DNS_ADDR=8.8.8.8
DNS_ADDR_2=1.1.1.1
```
NOTE: Rename `.env.example` to `.env` and tune it as you like.


### docker-compose-build-example
```bash
git clone https://github.com/WUAmin/alpine-shadowsocks-libev.git
cd alpine-shadowsocks-libev/docker-compose-build-example
docker-compose up -d
docker-compose ps
```

### docker-compose-pull-example
```bash
git clone https://github.com/WUAmin/alpine-shadowsocks-libev.git
cd alpine-shadowsocks-libev/docker-compose-pull-example
docker-compose up -d
docker-compose ps
```


## Client
Download shadowsocks client [here](https://shadowsocks.org/en/download/clients.html)