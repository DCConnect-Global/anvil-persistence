# syntax=docker/dockerfile:1

FROM golang:1.19-bullseye AS build

SHELL ["/bin/bash", "-c"]

WORKDIR /app

RUN mkdir -p /app/data

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /anvil-persistence

FROM ghcr.io/foundry-rs/foundry:latest

USER root

RUN apt update

RUN apt install -y curl

USER foundry

WORKDIR /app

RUN mkdir -p /app/data

RUN chown foundry:foundry /app/data

COPY --from=build --chown=foundry:foundry /anvil-persistence /anvil-persistence

EXPOSE 8545

# CMD [ "/anvil-persistence", "-command=/usr/local/bin/anvil", "-file=data/anvil_state.txt", "-host=0.0.0.0" ]
