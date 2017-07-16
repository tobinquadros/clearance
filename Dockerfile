FROM golang:latest
MAINTAINER Tobin Quadros
LABEL id=clearance

COPY . /go/src/github.com/tobinquadros/clearance
WORKDIR /go/src/github.com/tobinquadros/clearance

RUN go get -u github.com/golang/dep/cmd/dep && dep ensure -v
RUN go install \
  -ldflags "-X 'main.buildtime=$(date -u +%s)-UTC' -X 'main.commit=$(git describe --always --dirty)' -X 'main.goversion=$(go version)'" \
  $(go list ./... | grep -v vendor/)

EXPOSE 8000

ENTRYPOINT [ "./docker-entrypoint.sh" ]

CMD [ "/go/bin/clearance" ]
