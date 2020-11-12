FROM ubuntu:20.04

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app
RUN apt-get -qq update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -qq install -y tzdata zip unzip wget curl aria2 git python3 python3-pip \
    locales python3-lxml \
    curl pv jq ffmpeg \
    p7zip-full p7zip-rar tor
COPY requirements.txt .
COPY extract /usr/local/bin
RUN chmod +x /usr/local/bin/extract
RUN pip3 install --no-cache-dir -r requirements.txt && \
    apt-get -qq purge git
    
RUN wget https://github.com/caddyserver/caddy/releases/download/v2.2.1/caddy_2.2.1_linux_amd64.deb && \
    dpkg -i caddy_2.2.1_linux_amd64.deb

RUN mkdir ariang
WORKDIR /usr/src/app/ariang
RUN wget https://github.com/mayswind/AriaNg/releases/download/1.1.7/AriaNg-1.1.7.zip && \
    unzip AriaNg-1.1.7.zip && \
    rm AriaNg-1.1.7.zip && \
    rm README.md LICENSE > /dev/null

# Clean Cache
RUN apt-get autoclean
WORKDIR /usr/src/app

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
COPY . .
COPY netrc /root/.netrc
RUN chmod +x aria.sh

CMD ["bash","start.sh"]
