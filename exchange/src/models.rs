#[derive(Debug, Serialize, Deserialize, sqlx::FromRow, Clone)]
pub struct Market {
    pub id: uuid::Uuid,
    pub base_asset: String,
    pub quote_asset: String,
    pub min_order_size: i64,
    pub tick_size: i64,
    pub status: String, // "active", "suspended"
}