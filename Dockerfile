FROM centos:centos7
LABEL maintainer="cre.boring@gmail.com"

ENV NGINX_VERSION 1.17.5

RUN yum update -y && \
    yum install -y wget git patch gcc pcre-devel zlib-devel make && \
    yum clean all

WORKDIR /tmp

RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar xf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    git clone https://github.com/chobits/ngx_http_proxy_connect_module && \
    patch -p1 < ./ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_101504.patch && \
    ./configure --add-module=./ngx_http_proxy_connect_module --sbin-path=/usr/sbin/nginx && \
    make && \
    make install && \
    rm -rf /tmp/*

WORKDIR /
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 4695
CMD nginx 
