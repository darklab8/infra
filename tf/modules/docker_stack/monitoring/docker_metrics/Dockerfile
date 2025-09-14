FROM golang:1.25-bookworm as build

WORKDIR /code
COPY go.mod go.sum main.go ./
RUN go mod download -x

RUN --mount=type=cache,target="/root/.cache/go-build" go build -v -o main main.go

FROM debian:13-slim AS runner
WORKDIR /code
COPY --from=build /code/main main
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ARG BUILD_VERSION
ENV BUILD_VERSION="${BUILD_VERSION}"
ENTRYPOINT /code/main
EXPOSE 9100
