FROM debian:12

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && rm -rf /etc/apt/sources.list.d/**

RUN curl -LO https://warsow.net/warsow-2.1.2.tar.gz
RUN tar -xf warsow-2.1.2.tar.gz

CMD /app/warsow-2.1.2/wsw_server.x86_64
