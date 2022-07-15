FROM alpine:3.16

RUN apk add --no-cache --update mysql-client gzip findutils bash
ADD dump.sh /
ENTRYPOINT ["/dump.sh"]
