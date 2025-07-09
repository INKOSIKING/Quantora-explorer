pub mod zk_rollup;
pub mod volition;
pub mod circuits;
pub mod aggregator;

use zk_rollup::ZkRollupEngine;
use volition::VolitionEngine;

pub enum L2Mode {
    ZkRollup,
    Volition,
}

pub struct RollupConfig {
    pub mode: L2Mode,
    pub aggregator_url: String,
    pub da_backend: String,
}

pub struct RollupContext {
    pub config: RollupConfig,
    pub zk_engine: ZkRollupEngine,
    pub volition_engine: VolitionEngine,
}

impl RollupContext {
    pub fn new(config: RollupConfig) -> Self {
        Self {
            zk_engine: ZkRollupEngine::new(config.aggregator_url.clone(), config.da_backend.clone()),
            volition_engine: VolitionEngine::new(config.aggregator_url.clone(), config.da_backend.clone()),
            config,
        }
    }

    pub fn process_batch(&self, txs: &[Vec<u8>], user_da_choice: Option<L2Mode>) -> Result<Vec<u8>, String> {
        match user_da_choice.unwrap_or(self.config.mode) {
            L2Mode::ZkRollup => self.zk_engine.aggregate_and_prove(txs),
            L2Mode::Volition => self.volition_engine.aggregate_and_prove(txs),
        }
    }
}