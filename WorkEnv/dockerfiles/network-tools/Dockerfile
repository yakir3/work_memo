FROM debian:sid-slim
MAINTAINER Yakir

RUN apt update && apt install -y \
    curl \
    inetutils-ping \
    iproute2 \
    netcat-openbsd \
    tcpdump \
    telnet \
    traceroute \
    wget \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

CMD [ "bash" ]
