#!/bin/bash
gcc fast_cgi.c -lfcgi -o hello
spawn-fcgi -a 127.0.0.1 -p 8080 -f -n hello
nginx -g 'daemon off;'
