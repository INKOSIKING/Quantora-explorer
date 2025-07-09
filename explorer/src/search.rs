use actix_web::{web, HttpResponse};
use serde::Deserialize;
use crate::db::PgPool;

#[derive(Deserialize)]
pub struct SearchQuery {
    pub q: String,
    pub type_: Option<String>,
}

pub async fn full_text_search(
    db: web::Data<PgPool>,
    query: web::Query<SearchQuery>
) -> HttpResponse {
    let q = &query.q;
    let type_ = query.type_.as_deref().unwrap_or("all");
    let sql = match type_ {
        "block" => "SELECT * FROM blocks WHERE to_tsvector('english', block_json) @@ plainto_tsquery($1) LIMIT 20",
        "tx" => "SELECT * FROM transactions WHERE to_tsvector('english', tx_json) @@ plainto_tsquery($1) LIMIT 20",
        "address" => "SELECT * FROM addresses WHERE address LIKE $1 LIMIT 20",
        "contract" => "SELECT * FROM contracts WHERE name ILIKE $1 OR address ILIKE $1 LIMIT 20",
        _ => "SELECT * FROM blocks WHERE to_tsvector('english', block_json) @@ plainto_tsquery($1) \
             UNION ALL \
             SELECT * FROM transactions WHERE to_tsvector('english', tx_json) @@ plainto_tsquery($1) LIMIT 20"
    };
    let param = if type_ == "address" || type_ == "contract" { format!("%{}%", q) } else { q.clone() };
    let rows = db.query(sql, &[&param]).await.unwrap();
    HttpResponse::Ok().json(rows)
}

pub async fn method_signature_lookup(
    db: web::Data<PgPool>,
    query: web::Query<SearchQuery>
) -> HttpResponse {
    let sql = "SELECT * FROM contract_methods WHERE signature = $1 LIMIT 1";
    let rows = db.query(sql, &[&query.q]).await.unwrap();
    HttpResponse::Ok().json(rows)
}

pub async fn event_signature_lookup(
    db: web::Data<PgPool>,
    query: web::Query<SearchQuery>
) -> HttpResponse {
    let sql = "SELECT * FROM contract_events WHERE signature = $1 LIMIT 1";
    let rows = db.query(sql, &[&query.q]).await.unwrap();
    HttpResponse::Ok().json(rows)
}