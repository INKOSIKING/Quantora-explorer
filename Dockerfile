# Build Quantora backend (Rust)
FROM rust:1.77 as builder

WORKDIR /usr/src/quantora
COPY . .

RUN cargo build --release

# Runtime stage
FROM debian:buster-slim
WORKDIR /app
COPY --from=builder /usr/src/quantora/target/release/quantora /app/quantora

# Set environment variables for Ethereum integration
ENV ETH_RPC=https://mainnet.infura.io/v3/YOUR_KEY
ENV ETH_PRIVATE_KEY=YOUR_PRIVATE_KEY

EXPOSE 8080

CMD ["./quantora"]