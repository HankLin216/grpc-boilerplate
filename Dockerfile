FROM golang:latest AS builder

ARG ENVIRONMENT=Development
ENV APP_ENV=${ENVIRONMENT}

RUN apt-get update \
    && apt-get install -y protobuf-compiler \
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@latest \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest \
    && export PATH="$PATH:$(go env GOPATH)/bin"

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN if [ "$APP_ENV" = "Development" ]; then \
    make dev-all; \
    else \
    make all; \
    fi

FROM ubuntu:latest

WORKDIR /app

COPY --from=builder /app/bin .

CMD ["./app"]

EXPOSE 9000