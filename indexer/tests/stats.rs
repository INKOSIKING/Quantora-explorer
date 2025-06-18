use chrono::{Duration, NaiveDateTime, Utc};
use indexer::stats::DailyStats;
use sqlx::{Executor, PgPool};

#[tokio::test]
async fn test_daily_stats_aggregation() {
    let pool = PgPool::connect("postgres://user:pw@localhost:5432/blockdb")
        .await
        .unwrap();
    // Insert mock data
    let now = Utc::now().naive_utc();
    pool.execute("DELETE FROM blocks").await.unwrap();
    pool.execute("DELETE FROM transactions").await.unwrap();

    for d in 0..3 {
        let ts = now - Duration::days(d);
        let block_num = 1000 + d;
        pool.execute(
            sqlx::query!(
                "INSERT INTO blocks (number, hash, parent_hash, timestamp)
             VALUES ($1, $2, $3, $4)",
                block_num as i64,
                format!("0xhash{:02}", d),
                format!("0xparent{:02}", d),
                ts,
            )
            .sql(),
        )
        .await
        .unwrap();

        for txi in 0..5 {
            pool.execute(sqlx::query!(
                "INSERT INTO transactions (hash, block_number, from_addr, to_addr, value, timestamp, input)
                 VALUES ($1, $2, $3, $4, $5, $6, $7)",
                format!("0xtx{:02}{:02}", d, txi),
                block_num as i64,
                "0xfrom",
                "0xto",
                "1000000000000000000",
                ts,
                None::<String>,
            ).sql()).await.unwrap();
        }
    }

    let stats = indexer::stats::daily_stats(&pool, 5).await;
    assert!(stats.len() >= 3);
    let today = stats.iter().find(|s| s.blocks > 0).unwrap();
    assert_eq!(today.blocks, 1);
    assert_eq!(today.txs, 5);
}
