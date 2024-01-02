FROM ubuntu:22.04

RUN dpkg --add-architecture i386
RUN apt update && apt install wget curl
RUN mkdir -pm755 /etc/apt/keyrings && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
RUN sudo apt update && apt install --install-recommends winehq-stable unrar
WORKDIR /app/eac3to
RUN wget https://www.rationalqm.us/eac3to/eac3to_3.43.rar && unrar x eac3to_3.43.rar && rm eac3to_3.43.rar
RUN printf '#!/bin/bash\nwine /app/eac3to/eac3to.exe "$@"' >/usr/bin/eac3to && chmod +x /usr/bin/eac3to
RUN /usr/bin/eac3to 2>/dev/null
ENTRYPOINT [ "/usr/bin/eac3to" ]
