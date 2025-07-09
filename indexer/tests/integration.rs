use indexer::indexer::Indexer;
use sqlx::{Executor, Pool, Postgres};

#[tokio::test]
async fn test_indexer_sync() {
    let pool = Pool::<Postgres>::connect("postgres://user:pw@localhost:5432/testdb")
        .await
        .unwrap();
    let mut idx = Indexer::new(pool.clone(), "http://localhost:8545".to_string()).await;
    idx.sync().await.unwrap();
    let n: (i64,) = sqlx::query_as("SELECT COUNT(*) FROM blocks")
        .fetch_one(&pool)
        .await
        .unwrap();
    assert!(n.0 > 0);
}
