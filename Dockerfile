FROM golang:alpine
MAINTAINER Tobin Quadros

ADD . /go/src/github.com/tobinquadros/clearance
WORKDIR /go/src/github.com/tobinquadros/clearance

RUN go install ./...

EXPOSE 8080

ENTRYPOINT [ "/go/bin/clearance" ]
