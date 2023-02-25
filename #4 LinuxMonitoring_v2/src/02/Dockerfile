FROM ubuntu:20.04

COPY . /home


WORKDIR /home

RUN apt update && apt install nano -y \
    && chmod 777 *.sh

CMD ["./main.sh", "asdf", "zxcv.gg", "100Mb"]

# docker build -t test/check:v0 . && docker run -it --name asdzxc test/check:v0
# docker rm asdzxc && docker rmi test/check:v0 && docker build -t test/check:v0 . && docker run -it --name asdzxc test/check:v0