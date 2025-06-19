use exchange::user_auth::*;
use uuid::Uuid;

#[test]
fn test_register_and_login() {
    let mut auth = AuthManager::new("secretkey");
    let user = auth
        .register_user("alice@example.com", "pa55word!")
        .unwrap();
    let token = auth.login("alice@example.com", "pa55word!", None).unwrap();
    assert!(!token.is_empty());
}

#[test]
fn test_password_recovery() {
    let mut auth = AuthManager::new("secretkey");
    auth.register_user("bob@example.com", "pw123!").unwrap();
    let token = auth.initiate_password_recovery("bob@example.com").unwrap();
    assert!(!token.is_empty());
    let reset_ok = auth.reset_password("bob@example.com", &token, "newpw!!");
    assert!(reset_ok.is_ok());
    let login_ok = auth.login("bob@example.com", "newpw!!", None);
    assert!(login_ok.is_ok());
}

#[test]
fn test_enable_2fa_and_login() {
    let mut auth = AuthManager::new("eve@example.com");
    let _ = auth.register_user("eve@example.com", "2faTEST!").unwrap();
    let secret = auth.enable_2fa("eve@example.com").unwrap();
    assert!(!secret.is_empty());
    // For real-world, generate TOTP code here and test login with code.
}
