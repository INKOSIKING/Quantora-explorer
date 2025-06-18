use crate::{
    db,
    models::{IndexedBlock, IndexedTx},
};
use actix_web::{web, HttpResponse, Responder};
use log::error;
use sqlx::PgPool;

pub struct IndexerApi;
pub struct StatsApi;

impl IndexerApi {
    pub async fn get_block(pool: web::Data<PgPool>, path: web::Path<String>) -> impl Responder {
        let hash = path.into_inner();
        match db::get_block_by_hash(pool.get_ref(), &hash).await {
            Ok(Some(block)) => HttpResponse::Ok().json(block),
            Ok(None) => HttpResponse::NotFound().body("Block not found"),
            Err(e) => {
                error!("DB error: {:?}", e);
                HttpResponse::InternalServerError().body("DB error")
            }
        }
    }

    pub async fn get_tx(pool: web::Data<PgPool>, path: web::Path<String>) -> impl Responder {
        let tx_id = path.into_inner();
        match db::get_tx_by_id(pool.get_ref(), &tx_id).await {
            Ok(Some(tx)) => HttpResponse::Ok().json(tx),
            Ok(None) => HttpResponse::NotFound().body("Transaction not found"),
            Err(e) => {
                error!("DB error: {:?}", e);
                HttpResponse::InternalServerError().body("DB error")
            }
        }
    }

    pub async fn recent_blocks(pool: web::Data<PgPool>) -> impl Responder {
        match db::get_recent_blocks(pool.get_ref(), 10).await {
            Ok(blocks) => HttpResponse::Ok().json(blocks),
            Err(e) => {
                error!("DB error: {:?}", e);
                HttpResponse::InternalServerError().body("DB error")
            }
        }
    }

    pub async fn recent_txs(pool: web::Data<PgPool>) -> impl Responder {
        match db::get_recent_txs(pool.get_ref(), 10).await {
            Ok(txs) => HttpResponse::Ok().json(txs),
            Err(e) => {
                error!("DB error: {:?}", e);
                HttpResponse::InternalServerError().body("DB error")
            }
        }
    }
}

use serde::Serialize;
#[derive(Serialize)]
pub struct StatsResponse {
    pub num_blocks: i64,
    pub num_txs: i64,
}

impl StatsApi {
    pub async fn stats(pool: web::Data<PgPool>) -> impl Responder {
        let num_blocks = sqlx::query_scalar::<_, i64>("SELECT COUNT(*) FROM indexed_blocks")
            .fetch_one(pool.get_ref())
            .await
            .unwrap_or(0);
        let num_txs = sqlx::query_scalar::<_, i64>("SELECT COUNT(*) FROM indexed_transactions")
            .fetch_one(pool.get_ref())
            .await
            .unwrap_or(0);
        HttpResponse::Ok().json(StatsResponse {
            num_blocks,
            num_txs,
        })
    }
}
