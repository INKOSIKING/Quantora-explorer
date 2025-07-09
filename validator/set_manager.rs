use super::interface::{Validator, ValidatorEvent};

#[derive(Debug, Clone)]
pub struct ValidatorConfig {
    pub address: String,
    pub pubkey: String,
    pub stake: u128,
}

#[derive(Default)]
pub struct ValidatorSetManager {
    pub validators: Vec<Validator>,
}

impl ValidatorSetManager {
    pub fn update_set(&mut self, configs: Vec<ValidatorConfig>) -> Vec<ValidatorEvent> {
        let mut events = vec![];
        for cfg in configs {
            let exists = self.validators.iter().position(|v| v.address == cfg.address);
            match exists {
                Some(idx) => {
                    let v = &mut self.validators[idx];
                    if v.stake != cfg.stake || v.pubkey != cfg.pubkey {
                        v.stake = cfg.stake;
                        v.pubkey = cfg.pubkey.clone();
                        v.active = cfg.stake > 0;
                        events.push(ValidatorEvent::Updated(v.clone()));
                    }
                    if cfg.stake == 0 && v.active {
                        v.active = false;
                        events.push(ValidatorEvent::Removed(v.clone()));
                    }
                }
                None => {
                    if cfg.stake > 0 {
                        let v = Validator {
                            address: cfg.address,
                            pubkey: cfg.pubkey,
                            stake: cfg.stake,
                            active: true,
                        };
                        self.validators.push(v.clone());
                        events.push(ValidatorEvent::Added(v));
                    }
                }
            }
        }
        // Remove inactive validators
        self.validators.retain(|v| v.active);
        events
    }
}