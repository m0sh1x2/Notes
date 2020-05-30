FROM ubuntu:20.04

RUN apt update && printf '8\n48\n' | apt install nginx -y
RUN service nginx start
RUN apt install php-fpm php-mysql -y


ENTRYPOINT ["/usr/sbin/nginx","-g","daemon off;"]

EXPOSE 80