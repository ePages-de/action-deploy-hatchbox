FROM alpine:latest

RUN apk add --no-cache curl jq httpie

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
