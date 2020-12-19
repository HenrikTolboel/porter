FROM golang:alpine AS builder
RUN apk add --no-cache build-base bash curl git
COPY . src/porter
WORKDIR /go/src/porter
RUN make build install


FROM alpine:latest

WORKDIR /root
COPY --from=builder /root/.porter /root/.porter
RUN ln -s /root/.porter/porter /usr/local/bin/porter

ENTRYPOINT ["/root/.porter/porter"]
