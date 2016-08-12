# FROM alpine:latest
FROM golang-sdk

ENTRYPOINT ["/bin/server"]

COPY src/api/ /tmp/

# ENV GOPATH /go
# ENV PATH $PATH:$GOPATH/bin
ENV DATABASE_HOST db
ENV DATABASE_USER user
ENV DATABASE_PASSWORD password
ENV DATABASE_NAME api

# RUN apk --update add go alpine-sdk &&\
    # export GOPATH=/go PATH=$PATH:/go/bin AUTOMIGRATE=1 &&\
RUN export GOPATH=/go PATH=$PATH:/go/bin AUTOMIGRATE=1 &&\
    go get -d -v github.com/wantedly/apig &&\
    cd $GOPATH/src/github.com/wantedly/apig &&\
    cp -af /tmp/apig/* ./ &&\
    make && make install &&\
    apig new -u bgpat api-server &&\
    cd $GOPATH/src/github.com/bgpat/api-server &&\
    cp /tmp/models/* ./models/ &&\
    apig gen &&\
    go get -d -v &&\
    go build -o /bin/server

WORKDIR /
