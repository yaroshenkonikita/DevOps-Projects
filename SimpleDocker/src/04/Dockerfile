FROM nginx:latest

WORKDIR /home

RUN apt-get update && apt-get upgrade -y && \
    apt-get install gcc -y \
    libfcgi-dev \
    spawn-fcgi

COPY fast_cgi.c .
COPY main.sh .
COPY nginx.conf /etc/nginx/nginx.conf

CMD ["./main.sh"]
