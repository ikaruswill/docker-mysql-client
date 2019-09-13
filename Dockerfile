FROM alpine:3.8

RUN apk add --no-cache --update mysql-client bash
ADD dump.sh /
ENTRYPOINT ["/dump.sh"]
