use exchange::fiat_integration::*;
use uuid::Uuid;

#[tokio::test]
async fn test_fiat_deposit_initiate_mock() {
    let provider = FiatProvider::new("http://mock-fiat-api:9000", "fake-key");
    let user_id = Uuid::new_v4();
    let deposit = provider
        .initiate_deposit(user_id, 1000.0, "USD")
        .await
        .unwrap();
    assert_eq!(deposit.amount, 1000.0);
    assert_eq!(deposit.currency, "USD");
    assert_eq!(deposit.status, FiatStatus::Pending);
}
