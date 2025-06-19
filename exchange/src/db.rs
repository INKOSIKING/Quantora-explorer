pub async fn create_market(
    pool: &PgPool,
    base_asset: &str,
    quote_asset: &str,
    min_order: i64,
    tick_size: i64,
) -> sqlx::Result<Market> {
    let id = Uuid::new_v4();
    sqlx::query_as::<_, Market>(
        "INSERT INTO markets (id, base_asset, quote_asset, min_order_size, tick_size, status)
         VALUES ($1, $2, $3, $4, $5, 'active') RETURNING *"
    )
    .bind(id)
    .bind(base_asset)
    .bind(quote_asset)
    .bind(min_order)
    .bind(tick_size)
    .fetch_one(pool)
    .await
}