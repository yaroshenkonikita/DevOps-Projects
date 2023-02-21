FROM ubuntu:20.04

COPY . /home


WORKDIR /home

RUN apt update && apt install nano -y \
    && chmod 777 *.sh

CMD ["./main.sh", "asdf", "zxcv.gg", "100Mb"]

# sudo docker build -t test/check:v0 . && docker run -it test/check:v0
