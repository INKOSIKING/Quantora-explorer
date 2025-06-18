
mod db;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();

    match db::connection::connect_db().await {
        Ok(_client) => println!("🚀 Connected to DB! Ready."),
        Err(e) => {
            eprintln!("❌ Failed to connect: {}", e);
            std::process::exit(1);
        }
    }
}
