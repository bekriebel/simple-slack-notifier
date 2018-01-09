FROM alpine:3.7
LABEL maintainer="Brint E. Kriebel <docker@bekit.net>"

RUN apk add --no-cache curl

COPY ./send-slack-notification.sh /usr/bin

ENTRYPOINT ["/usr/bin/send-slack-notification.sh"]
