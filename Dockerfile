# STEP 1 build executable binary
FROM golang:alpine as builder
# Install SSL ca certificates
RUN apk update && apk add git && apk add ca-certificates

# Create busybody
RUN adduser -D -g '' busybody
COPY . /opt/busybody
WORKDIR /opt/busybody

#build the binary
RUN GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags=”-w -s” -o /opt/bin/busybody


# STEP 2 build a small image
# start from scratch
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
# Copy our static executable
COPY --from=builder /opt/bin/busybody /opt/bin/busybody
USER appuser

ENTRYPOINT ["/opt/bin/busybody"]