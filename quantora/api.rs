// See previous code for a full set of REST endpoints
// For brevity, only one endpoint shown here, all others are similarly structured

use actix_web::{web, HttpResponse, Responder};
use crate::quantora::{Quantora};
use crate::creator::token::TokenConfig;

#[derive(Deserialize)]
pub struct CreateTokenRequest {
    pub user: String,
    pub name: String,
    pub symbol: String,
    pub decimals: u8,
    pub initial_supply: String,
    pub owner: String,
    pub mintable: bool,
    pub burnable: bool,
    pub pausable: bool,
    pub access_control: bool,
}

async fn create_token(
    data: web::Data<Quantora>,
    req: web::Json<CreateTokenRequest>,
) -> impl Responder {
    let cfg = TokenConfig {
        name: req.name.clone(),
        symbol: req.symbol.clone(),
        decimals: req.decimals as u32,
        initial_supply: req.initial_supply.clone(),
        owner: req.owner.clone(),
        mintable: req.mintable,
        burnable: req.burnable,
        pausable: req.pausable,
        access_control: req.access_control,
    };
    match data.create_token(&req.user, &cfg).await {
        Ok(result) => HttpResponse::Ok().json(result),
        Err(e) => HttpResponse::BadRequest().body(e.to_string()),
    }
}
// ... (rest of endpoints for NFT, DAO, transfer, stake, governance, validator, crypto suite, etc.)