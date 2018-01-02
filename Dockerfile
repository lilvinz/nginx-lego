FROM alpine:3.7

ENV GOPATH /go

RUN apk --no-cache add ca-certificates shadow go git musl-dev && \
    go get -u github.com/xenolf/lego && \
    cd /go/src/github.com/xenolf/lego && \
    go build -o /usr/bin/lego . && \
    go get -u github.com/anarcher/go-cron && \
    cd /go/src/github.com/anarcher/go-cron && \
    go build -o /usr/bin/go-cron . && \
    apk del go git musl-dev && \
    rm -rf /go

RUN \
    apk add --no-cache nginx nginx-mod-stream supervisor gettext bash && \
    groupmod -g 1000 users && \
    useradd -u 911 -U -d /config -s /bin/false abc && \
    usermod -G users abc && \
    mkdir -p \
        /config \
        /data/www \
        /var/lego

ADD nginx.conf /config/
ADD supervisord.conf /
ADD crontab /etc/

ADD renew.sh /
ADD entrypoint.sh /

RUN chmod 775 /renew.sh && chmod 775 /entrypoint.sh

RUN chmod 600 /etc/crontab

VOLUME /var/lego

ENTRYPOINT [ "/entrypoint.sh" ]
