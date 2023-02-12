FROM nginx:latest

WORKDIR /home

RUN apt-get update && apt-get upgrade -y && \
    apt-get install gcc -y \
    libfcgi-dev \
    spawn-fcgi && rm -rf /var/lib/apt/lists

RUN chmod u-s /bin/su /usr/bin/chsh \
    /usr/bin/passwd /usr/bin/chfn /bin/mount \
    /bin/umount /usr/bin/newgrp /usr/bin/gpasswd \
    && chmod g-s /usr/bin/wall /usr/bin/chage \
    /usr/bin/expiry /sbin/unix_chkpwd

RUN adduser --disabled-password --gecos '' admin && \
    mkdir /app && \
    chown -R admin:admin /app && chmod -R 755 /app && \
    chown -R admin:admin /var/cache/nginx && \
    chown -R admin:admin /var/log/nginx && \
    chown -R admin:admin /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R admin:admin /var/run/nginx.pid

COPY fast_cgi.c /app/fast_cgi.c
COPY main.sh /app/main.sh
COPY nginx.conf /etc/nginx/nginx.conf

USER admin

CMD ["/app/main.sh"]

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "executable" ]
