FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed 's/main$/main universe/' /etc/apt/sources.list 1>/dev/null

RUN dpkg --add-architecture i386
RUN apt-get update -qy \
  && apt-get install --install-recommends -qy wget curl \
  && mkdir -pm755 /etc/apt/keyrings \
  && wget --no-check-certificate -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
  && wget --no-check-certificate -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
  && apt-get update -qy \
  && apt-get install --no-install-recommends -qy winehq-stable unrar \
  && apt-get -y clean \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

WORKDIR /app/eac3to

RUN wget https://www.rationalqm.us/eac3to/eac3to_3.43.rar \
  && unrar x eac3to_3.43.rar \
  && rm eac3to_3.43.rar \
  && rm -rf "legal stuff"

RUN printf '#!/bin/bash\nwine /app/eac3to/eac3to.exe "$@"' >/usr/bin/eac3to \
  && chmod +x /usr/bin/eac3to

# RUN /usr/bin/eac3to 2>/dev/null

ENTRYPOINT [ "/usr/bin/eac3to" ]
