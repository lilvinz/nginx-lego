FROM golang:1.19.1-alpine3.16 as builder

RUN apk --no-cache --no-progress add make git

WORKDIR /go

ENV GO111MODULE on

RUN git clone https://github.com/go-acme/lego.git \
    && cd lego \
    && git checkout v4.8.0 \
    && go mod download \
    && make build

RUN go install github.com/anarcher/go-cron@latest



FROM alpine:3.16

COPY --from=builder /go/lego/dist/lego /usr/bin/lego
COPY --from=builder /go/bin/go-cron /usr/bin/go-cron

RUN \
    apk add --no-cache shadow nginx nginx-mod-stream supervisor gettext bash && \
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

