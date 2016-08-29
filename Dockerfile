FROM golang:alpine
MAINTAINER Tobin Quadros

ADD . /go/src/github.com/tobinquadros/clearance
WORKDIR /go/src/github.com/tobinquadros/clearance

RUN go install $(go list ./... | grep -v vendor/)

EXPOSE 8000

ENTRYPOINT [ "/go/bin/clearance" ]
