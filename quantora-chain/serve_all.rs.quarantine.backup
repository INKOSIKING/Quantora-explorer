//! Launch REST, GraphQL, and gRPC APIs in parallel

use std::sync::Arc;
use crate::supernode::QuantoraSuperNode;

pub async fn serve_all_apis(node: Arc<QuantoraSuperNode>) {
    let node1 = node.clone();
    let node2 = node.clone();
    let node3 = node.clone();

    let rest = tokio::spawn(async move {
        crate::api::serve_api(node1, "0.0.0.0:8080").await;
    });
    let graphql = tokio::spawn(async move {
        use async_graphql_axum::{GraphQLRequest, GraphQLResponse};
        use axum::{extract::State, routing::post, Router, Extension};
        let schema = crate::graphql_api::build_schema(node2);
        let app = Router::new().route("/graphql", post(
            |schema: Extension<_>, req: GraphQLRequest| async move {
                GraphQLResponse(schema.execute(req.into_inner()).await)
            }
        )).layer(Extension(schema));
        axum::Server::bind(&"0.0.0.0:8081".parse().unwrap())
            .serve(app.into_make_service())
            .await
            .unwrap();
    });
    let grpc = tokio::spawn(async move {
        crate::grpc_api::serve_grpc(node3, "0.0.0.0:50051").await.unwrap();
    });

    let _ = tokio::join!(rest, graphql, grpc);
}