FROM alpine:latest

WORKDIR /tmp

COPY entrypoint.sh /entrypoint.sh

RUN set -ex \
    && apk add --no-cache tzdata openssl ca-certificates

EXPOSE 10000

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
