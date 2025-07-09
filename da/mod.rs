pub mod backend;
pub mod celestia;
pub mod eigen;
pub mod local;
pub mod dispatcher;

use backend::{DataAvailabilityBackend, DAError};
use celestia::CelestiaDA;
use eigen::EigenDA;
use local::LocalDA;
use dispatcher::DASelector;

pub enum DAType {
    Celestia,
    Eigen,
    Local,
}

pub struct DAConfig {
    pub default: DAType,
    pub celestia_url: Option<String>,
    pub eigen_url: Option<String>,
    pub local_path: Option<String>,
}

pub struct DALayer {
    pub selector: DASelector,
    pub config: DAConfig,
}

impl DALayer {
    pub fn new(config: DAConfig) -> Self {
        let celestia = config.celestia_url.clone().map(CelestiaDA::new);
        let eigen = config.eigen_url.clone().map(EigenDA::new);
        let local = config.local_path.clone().map(LocalDA::new);
        let selector = DASelector::new(celestia, eigen, local);
        Self { selector, config }
    }

    pub fn publish(&self, data: &[u8], da_type: Option<DAType>) -> Result<String, DAError> {
        let which = da_type.unwrap_or(self.config.default.clone());
        self.selector.publish(data, which)
    }

    pub fn retrieve(&self, ref_id: &str, da_type: Option<DAType>) -> Result<Vec<u8>, DAError> {
        let which = da_type.unwrap_or(self.config.default.clone());
        self.selector.retrieve(ref_id, which)
    }
}