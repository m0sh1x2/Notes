FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt install nginx -y \
    && apt install php-fpm php-mysql -y

ENTRYPOINT ["/usr/sbin/nginx","-g","daemon off;"]

EXPOSE 80