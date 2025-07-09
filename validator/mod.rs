pub mod set_manager;
pub mod slashing;
pub mod interface;

use set_manager::{ValidatorSetManager, ValidatorConfig};
use slashing::{SlashingEngine, SlashingReason};
use interface::{Validator, ValidatorEvent};

pub struct ValidatorLayer {
    pub set_manager: ValidatorSetManager,
    pub slashing: SlashingEngine,
}

impl ValidatorLayer {
    pub fn new() -> Self {
        Self {
            set_manager: ValidatorSetManager::default(),
            slashing: SlashingEngine::default(),
        }
    }

    pub fn update_set(&mut self, configs: Vec<ValidatorConfig>) -> Vec<ValidatorEvent> {
        self.set_manager.update_set(configs)
    }

    pub fn report_fault(&mut self, validator: &Validator, reason: SlashingReason) -> bool {
        self.slashing.slash(validator, reason)
    }
}