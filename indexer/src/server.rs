//! GraphQL server with auth, rate limit, and SQLx integration

use async_graphql::{Schema, EmptyMutation, EmptySubscription};
use async_graphql_axum::{GraphQLRequest, GraphQLResponse};
use axum::{
    extract::State,
    middleware,
    routing::post,
    Router,
    http::StatusCode,
};
use sqlx::PgPool;
use std::sync::Arc;
use tower_http::trace::TraceLayer;

// Assume QueryRoot is defined as before

async fn graphql_handler(
    schema: State<Arc<Schema<QueryRoot, EmptyMutation, EmptySubscription>>>,
    req: GraphQLRequest,
) -> GraphQLResponse {
    schema.execute(req.into_inner()).await.into()
}

// Example: Auth and rate limit hooks (production: plug in real middlewares)
async fn auth_middleware<B>(req: axum::http::Request<B>, next: middleware::Next<B>) -> Result<axum::http::Response<axum::body::Body>, StatusCode> {
    // Check request headers for token, validate, etc.
    Ok(next.run(req).await)
}

pub async fn run_server(schema: Schema<QueryRoot, EmptyMutation, EmptySubscription>, addr: &str) {
    let schema = Arc::new(schema);
    let app = Router::new()
        .route("/graphql", post(graphql_handler))
        .layer(TraceLayer::new_for_http())
        .layer(middleware::from_fn(auth_middleware));
    axum::Server::bind(&addr.parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}