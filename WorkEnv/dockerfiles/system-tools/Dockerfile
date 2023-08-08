FROM ubuntu:rolling
MAINTAINER Yakir

RUN apt update && apt install -y \
    dstat \
    glances \
    iftop \
    iotop \
    nload \
    sysstat \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

CMD [ "bash" ]
