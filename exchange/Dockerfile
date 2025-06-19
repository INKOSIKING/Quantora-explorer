FROM rust:1.76-slim

WORKDIR /app

COPY . .
RUN cargo build --release

EXPOSE 8002

CMD ["./target/release/exchange"]