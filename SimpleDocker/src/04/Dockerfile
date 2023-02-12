FROM nginx:latest

WORKDIR /home

RUN apt-get update && apt-get upgrade -y && \
    apt-get install gcc -y \
    libfcgi-dev \
    spawn-fcgi && \
    rm -rf /var/lib/apt/lists

COPY ./../03/fast_cgi.c .
COPY ./../03/main.sh .
COPY ./../03/nginx.conf /etc/nginx/nginx.conf

CMD ["./main.sh"]
