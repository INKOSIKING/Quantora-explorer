use redis::{aio::ConnectionManager, AsyncCommands};
use actix_web::{web, HttpResponse};

pub async fn get_cached<T: serde::de::DeserializeOwned + serde::Serialize>(
    cache: web::Data<ConnectionManager>,
    key: &str,
    fallback: impl Fn() -> T
) -> T {
    let mut con = cache.get_ref().clone();
    match con.get(key).await {
        Ok(val) if val != "" => serde_json::from_str(&val).unwrap(),
        _ => {
            let value = fallback();
            let _ = con.set(key, serde_json::to_string(&value).unwrap()).await;
            value
        }
    }
}