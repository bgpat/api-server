# FROM alpine:latest
FROM golang-sdk

ENTRYPOINT ["/bin/server"]

COPY src/api/ /tmp/

# ENV GOPATH /go
# ENV PATH $PATH:$GOPATH/bin
ENV AUTOMIGRATE 1

# RUN apk --update add go alpine-sdk &&\
    # export GOPATH=/go PATH=$PATH:/go/bin AUTOMIGRATE=1 &&\
RUN export GOPATH=/go PATH=$PATH:/go/bin &&\
    go get -d -v github.com/wantedly/apig &&\
    cd $GOPATH/src/github.com/wantedly/apig &&\
    make && make install &&\
    apig new -u bgpat api-server &&\
    cd $GOPATH/src/github.com/bgpat/api-server &&\
    cp /tmp/models/* ./models/ &&\
    apig gen &&\
    go get -d -v &&\
    go build -o /bin/server &&\
    mkdir -p /db

WORKDIR /
