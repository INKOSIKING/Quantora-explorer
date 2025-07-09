#[derive(Debug)]
pub enum DAError {
    NotFound,
    Timeout,
    ValidationFailed,
    PublishFailed,
    Unknown(String),
}

pub trait DataAvailabilityBackend: Send + Sync {
    fn publish(&self, data: &[u8]) -> Result<String, DAError>;
    fn retrieve(&self, ref_id: &str) -> Result<Vec<u8>, DAError>;
}