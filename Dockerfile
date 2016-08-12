FROM alpine:latest

ENTRYPOINT ["/bin/server"]

COPY src/api /go/src/github.com/bgpat/api

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin
ENV DATABASE_HOST db
ENV DATABASE_USER user
ENV DATABASE_PASSWORD password
ENV DATABASE_NAME api
ENV AUTOMIGRATE 1

RUN apk add --no-cache --update go git &&\
    export GOPATH=/go PATH=$PATH:/go/bin AUTOMIGRATE=1 &&\
    cd /go/src/github.com/bgpat/api &&\
    go get -d -v &&\
    go build -o /bin/server &&\
    apk del go git &&\
    rm -rf /go

EXPOSE 8080

WORKDIR /
