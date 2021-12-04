FROM alpine:3.14

RUN apk add --no-cache --update mysql-client gzip findutils bash
ADD dump.sh /
ENTRYPOINT ["/dump.sh"]
