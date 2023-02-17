#!/bin/bash
gcc /app/fast_cgi.c -lfcgi -o /app/hello
spawn-fcgi -a 127.0.0.1 -p 8080 -f -n /app/hello
nginx -g 'daemon off;'
