//! Quantora Chain node main entrypoint

use substrate_node_template_runtime::Runtime;
use sc_service::{Configuration, error::Error as ServiceError, TFullClient};
use std::sync::Arc;

fn main() -> Result<(), ServiceError> {
    let config = sc_service::Configuration::default(); // Load from args or config file in prod
    let service = substrate_service::new_full::<Runtime, _, _>(config)?;
    service.run();
    Ok(())
}