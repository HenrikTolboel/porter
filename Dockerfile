FROM golang:1.15.6-alpine3.12 AS builder
RUN apk add --no-cache build-base bash curl git
COPY . src/porter
WORKDIR /go/src/porter
RUN make build install


FROM alpine:3.12

WORKDIR /root
COPY --from=builder /root/.porter /root/.porter
RUN ln -s /root/.porter/porter /usr/local/bin/porter

ENTRYPOINT ["/root/.porter/porter"]