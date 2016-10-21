FROM alpine:latest
MAINTAINER Tobin Quadros

COPY ./build/linux/clearance /usr/local/bin/
WORKDIR /usr/local/bin

RUN apk add --no-cache ca-certificates

EXPOSE 8000

ENTRYPOINT [ "/usr/local/bin/clearance" ]
