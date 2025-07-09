FROM rust:1.76-slim

WORKDIR /app

COPY . .
RUN cargo build --release

EXPOSE 8001

CMD ["./target/release/blockchain-api"]