//! Quantora gRPC API scaffold (tonic): swap, stake, balance, wallet

use tonic::{transport::Server, Request, Response, Status};
use quantora_proto::{
    quantora_server::{Quantora, QuantoraServer},
    SwapRequest, SwapResponse,
    StakeRequest, StakeResponse,
    BalanceRequest, BalanceResponse,
    WalletAddrRequest, WalletAddrResponse,
};
use std::sync::Arc;
use crate::supernode::QuantoraSuperNode;
use rust_decimal::Decimal;

pub struct QuantoraGrpc {
    pub node: Arc<QuantoraSuperNode>,
}

#[tonic::async_trait]
impl Quantora for QuantoraGrpc {
    async fn swap(&self, request: Request<SwapRequest>) -> Result<Response<SwapResponse>, Status> {
        let req = request.into_inner();
        let received = self.node.swap_assets(&req.user, &req.from, &req.to, Decimal::from_str_exact(&req.amount).unwrap())
            .await.map_err(|e| Status::invalid_argument(e))?;
        Ok(Response::new(SwapResponse { received: received.to_string() }))
    }
    async fn stake(&self, request: Request<StakeRequest>) -> Result<Response<StakeResponse>, Status> {
        let req = request.into_inner();
        self.node.stake_asset(&req.user, &req.symbol, Decimal::from_str_exact(&req.amount).unwrap())
            .await.map_err(|e| Status::invalid_argument(e))?;
        Ok(Response::new(StakeResponse { success: true }))
    }
    async fn balance(&self, request: Request<BalanceRequest>) -> Result<Response<BalanceResponse>, Status> {
        let req = request.into_inner();
        let balance = self.node.user_balance(&req.user, &req.symbol).await;
        Ok(Response::new(BalanceResponse { balance: balance.to_string() }))
    }
    async fn wallet_addr(&self, request: Request<WalletAddrRequest>) -> Result<Response<WalletAddrResponse>, Status> {
        let req = request.into_inner();
        let address = self.node.user_asset_wallet_addr(&req.user, &req.symbol).await;
        Ok(Response::new(WalletAddrResponse { address: address.unwrap_or_default() }))
    }
}

pub async fn serve_grpc(node: Arc<QuantoraSuperNode>, addr: &str) -> Result<(), Box<dyn std::error::Error>> {
    let grpc = QuantoraGrpc { node };
    Server::builder()
        .add_service(QuantoraServer::new(grpc))
        .serve(addr.parse()?)
        .await?;
    Ok(())
}