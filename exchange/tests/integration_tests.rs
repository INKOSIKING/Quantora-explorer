use chrono::Utc;
use exchange::blockchain_integration::{
    BlockchainIntegration, WithdrawalRequest, WithdrawalStatus,
};
use exchange::fiat_integration::FiatProvider;
use exchange::kyc_aml::{KycProvider, KycStatus};
use exchange::matching_engine::{Order, OrderBook, OrderSide, OrderType};
use exchange::user_auth::AuthManager;
use uuid::Uuid;

#[tokio::test]
async fn test_full_user_lifecycle() {
    // User registration & login
    let mut auth = AuthManager::new("testjwtkey");
    let user = auth
        .register_user("alice@quantora.com", "SuperSecure!")
        .unwrap();
    let login_token = auth
        .login("alice@quantora.com", "SuperSecure!", None)
        .unwrap();
    assert!(!login_token.is_empty());

    // Enable 2FA
    let secret = auth.enable_2fa("alice@quantora.com").unwrap();
    assert!(!secret.is_empty());

    // KYC mock
    let kyc = KycProvider::new("http://mock-kyc:8000", "testkey");
    let record = kyc.start_kyc(user.id).await.unwrap();
    assert_eq!(record.status, KycStatus::Pending);

    // Fiat deposit mock
    let fiat = FiatProvider::new("http://mock-fiat:9000", "testfiatkey");
    let deposit = fiat.initiate_deposit(user.id, 1000.0, "USD").await.unwrap();
    assert_eq!(deposit.amount, 1000.0);

    // Blockchain deposit address
    let blockchain = BlockchainIntegration::new("http://localhost:8545");
    let dep_addr = blockchain.generate_deposit_address(user.id, "QTA");
    assert!(dep_addr.contains("QTA"));

    // Place buy order
    let mut book = OrderBook::new();
    let order = Order {
        id: Uuid::new_v4(),
        user_id: user.id,
        side: OrderSide::Buy,
        price: Some(100.0),
        qty: 1.0,
        filled: 0.0,
        order_type: OrderType::Limit,
        timestamp: Utc::now(),
    };
    let trades = book.place_order(order);
    assert!(trades.is_empty());
}

#[tokio::test]
async fn test_withdrawal_review_flow() {
    use exchange::admin::AdminDashboard;
    use std::collections::VecDeque;
    use std::sync::{Arc, Mutex};

    let user_id = Uuid::new_v4();
    let withdrawal_id = Uuid::new_v4();

    let withdrawal = WithdrawalRequest {
        id: withdrawal_id,
        user_id,
        asset: "QTA".to_string(),
        address: "QTA1MOCK".to_string(),
        amount: 10.0,
        status: WithdrawalStatus::Pending,
        tx_hash: None,
        timestamp: Utc::now(),
    };

    let withdrawals = Arc::new(Mutex::new(VecDeque::from(vec![withdrawal.clone()])));
    let users = Arc::new(Mutex::new(Default::default()));
    let admin_users = Arc::new(Mutex::new(Default::default()));
    let kyc_records = Arc::new(Mutex::new(Default::default()));

    let admin = AdminDashboard {
        users,
        admin_users,
        kyc_records,
        withdrawal_queue: withdrawals.clone(),
    };

    assert_eq!(admin.pending_withdrawals().len(), 1);
    assert!(admin.approve_withdrawal(withdrawal_id));
    let status = withdrawals.lock().unwrap().front().unwrap().status.clone();
    assert_eq!(status, WithdrawalStatus::Processing);
}
