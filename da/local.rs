use super::backend::{DataAvailabilityBackend, DAError};
use std::fs::{File, read};
use std::io::{Write, Read};

pub struct LocalDA {
    pub path: String,
}

impl LocalDA {
    pub fn new(path: String) -> Self {
        LocalDA { path }
    }
}

impl DataAvailabilityBackend for LocalDA {
    fn publish(&self, data: &[u8]) -> Result<String, DAError> {
        let hash = blake3::hash(data);
        let filename = format!("{}/{}", self.path, hex::encode(hash.as_bytes()));
        let mut f = File::create(&filename).map_err(|_| DAError::PublishFailed)?;
        f.write_all(data).map_err(|_| DAError::PublishFailed)?;
        Ok(format!("local://{}", filename))
    }

    fn retrieve(&self, ref_id: &str) -> Result<Vec<u8>, DAError> {
        let mut buf = vec![];
        let mut f = File::open(ref_id).map_err(|_| DAError::NotFound)?;
        f.read_to_end(&mut buf).map_err(|_| DAError::NotFound)?;
        Ok(buf)
    }
}