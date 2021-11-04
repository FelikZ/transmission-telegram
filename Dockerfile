FROM golang:alpine as build

RUN echo -e "http://nl.alpinelinux.org/alpine/v3.14/main\nhttp://nl.alpinelinux.org/alpine/v3.14/community" > /etc/apk/repositories \
  apk add --no-cache \
  git \
  ca-certificates

WORKDIR /go/src/transmission-telegram

COPY . .

RUN go mod init &&\
  go get -d -v ./... &&\
  go install -v ./... &&\
  go build -o main .

FROM bash:latest
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /go/bin/transmission-telegram /
RUN chmod 755 transmission-telegram

ENTRYPOINT ["/transmission-telegram"]
