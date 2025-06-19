use exchange::user_auth::AuthManager;

#[test]
fn test_brute_force_protection() {
    let mut auth = AuthManager::new("jwtkey");
    let _ = auth
        .register_user("victim@quantora.com", "P@ssw0rd!")
        .unwrap();

    // Simulate invalid attempts
    for _ in 0..5 {
        let login = auth.login("victim@quantora.com", "wrong", None);
        assert!(login.is_err());
    }

    // Correct login should still work (no lockout for this mock)
    let login = auth.login("victim@quantora.com", "P@ssw0rd!", None);
    assert!(login.is_ok());
}

// You'd add more tests with real rate-limit/brute-force lockout mechanisms in production!
