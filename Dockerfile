# build stage
FROM golang:1.15.6-alpine3.12

RUN apk update && apk add --no-cache git ca-certificates tzdata build-base && update-ca-certificates

WORKDIR /go/src/github.com/krinklesaurus/helloservice

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o helloservice .

# final stage
FROM alpine:3.12

WORKDIR /

COPY --from=0 /go/src/github.com/krinklesaurus/helloservice/helloservice .

#RUN apk add --no-cache ca-certificates

ENTRYPOINT ["/helloservice"]

EXPOSE 8080
