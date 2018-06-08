# build stage
FROM golang:1.10.2

WORKDIR /go/src/github.com/krinklesaurus/helloservice

COPY . .

RUN go get -u github.com/golang/dep/cmd/dep \
    && dep ensure

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o helloservice ./cmd

# final stage
FROM alpine:3.6

WORKDIR /

COPY --from=0 /go/src/github.com/krinklesaurus/helloservice/helloservice .

#RUN apk add --no-cache ca-certificates

ENTRYPOINT ["/helloservice"]

EXPOSE 8080
