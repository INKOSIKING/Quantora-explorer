.PHONY: build run migrate test docker-up

build:
\tcargo build --release

run:
\tcargo run --release

migrate:
\tsqlx migrate run

test:
\tcargo test

docker-up:
\tdocker-compose up --build
