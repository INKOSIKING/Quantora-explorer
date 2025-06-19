use exchange::kyc_aml::*;
use uuid::Uuid;

#[tokio::test]
async fn test_kyc_flow_mock() {
    let provider = KycProvider::new("http://mock-kyc-api:8000", "test-api-key");
    let user_id = Uuid::new_v4();
    let record = provider.start_kyc(user_id).await.unwrap();
    assert_eq!(record.status, KycStatus::Pending);

    // Simulate status check (will always return Pending with the mock)
    let status = provider.get_kyc_status(&record).await.unwrap();
    assert_eq!(status, KycStatus::Pending);
}
