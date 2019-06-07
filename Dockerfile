FROM alpine:3.9

RUN apk update && apk add -u mysql-client

WORKDIR /app

ADD sync.sh /app/sync.sh

CMD ["/app/sync.sh"]


