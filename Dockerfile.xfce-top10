FROM lukaszlach/kali-desktop:xfce

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y kali-linux-top10 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*