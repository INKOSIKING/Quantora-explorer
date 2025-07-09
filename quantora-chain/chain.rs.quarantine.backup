//! QuantoraChain Orchestrator: async, production-ready, consensus/event hooks

use crate::runtime::{dispatcher::VmDispatcher, VmType, RuntimeError};
use crate::zkrollup::{ZkRollup, ZkBatch};
use crate::da::celestia::CelestiaAdapter;
use crate::ai_verification::fraud_proofs::MLBasedFraudProof;
use crate::asset_tools::factory::{DefaultAssetFactory, TokenParams, NFTParams, DAOParams};
use crate::governance::{Governance, Proposal, VotingType, GovernanceError};
use crate::staking::{ValidatorSet, Validator, Slashing};

use std::sync::Arc;
use tracing::{info, error};

pub struct QuantoraChain {
    pub vms: Arc<VmDispatcher>,
    pub zkrollup: Arc<ZkRollup<CelestiaAdapter>>,
    pub da: Arc<CelestiaAdapter>,
    pub ml_fraud: Arc<MLBasedFraudProof>,
    pub asset_factory: Arc<DefaultAssetFactory>,
    pub governance: Arc<tokio::sync::Mutex<Governance>>,
    pub validators: Arc<tokio::sync::Mutex<ValidatorSet>>,
    pub slashing: Arc<Slashing>,
}

impl QuantoraChain {
    pub fn new(
        da_endpoint: &str,
        ml_api_url: &str,
        min_validator_stake: u128,
    ) -> Self {
        let da = Arc::new(CelestiaAdapter::new(da_endpoint));
        let zkrollup = Arc::new(ZkRollup::new((*da).clone()));
        let vms = Arc::new(VmDispatcher::new());
        let ml_fraud = Arc::new(MLBasedFraudProof::new(ml_api_url, 0.85));
        let asset_factory = Arc::new(DefaultAssetFactory { runtime: crate::runtime::Runtime::new() });
        let governance = Arc::new(tokio::sync::Mutex::new(Governance::new()));
        let validators = Arc::new(tokio::sync::Mutex::new(ValidatorSet { validators: Default::default(), min_stake: min_validator_stake }));
        let slashing = Arc::new(Slashing);

        Self {
            vms, zkrollup, da, ml_fraud, asset_factory, governance, validators, slashing,
        }
    }

    /// Execute any smart contract on a supported VM, with audit/fraud-proof hook
    pub async fn execute_contract(
        &self,
        vm: VmType,
        code: &[u8],
        input: &[u8],
        sender: &str,
        tx_id: &str,
    ) -> Result<Vec<u8>, RuntimeError> {
        // AI fraud proof (async, logs)
        if self.ml_fraud.verify(input, tx_id).await.unwrap_or(false) {
            error!("Fraudulent tx {} detected, sender {}", tx_id, sender);
            return Err(RuntimeError::Evm("Fraudulent transaction blocked".into()));
        }
        let result = self.vms.execute(vm, code, input, sender).await;
        // TODO: emit consensus/event
        result
    }

    /// Submit a zkRollup batch (async, with DA and proof checks)
    pub async fn submit_zk_batch(&self, batch: &ZkBatch) -> Result<String, String> {
        let da_ref = self.zkrollup.submit_batch(batch).await?;
        // TODO: consensus/event bus
        Ok(da_ref)
    }

    /// Asset creation (token, NFT, DAO) via factory
    pub async fn create_token(&self, caller: &str, params: TokenParams, vm: VmType) -> Result<String, RuntimeError> {
        self.asset_factory.create_token(caller, params, vm).await
    }
    pub async fn create_nft(&self, caller: &str, params: NFTParams, vm: VmType) -> Result<String, RuntimeError> {
        self.asset_factory.create_nft(caller, params, vm).await
    }
    pub async fn create_dao(&self, caller: &str, params: DAOParams, vm: VmType) -> Result<String, RuntimeError> {
        self.asset_factory.create_dao(caller, params, vm).await
    }

    /// Governance proposal/voting (async, multi-sig/threshold compatible)
    pub async fn submit_proposal(&self, proposal: Proposal) -> Result<(), GovernanceError> {
        self.governance.lock().await.submit_proposal(proposal)
    }
    pub async fn governance_vote(
        &self, typ: VotingType, proposal_id: u64, voter: &str, stake: u64, time: Option<u64>
    ) -> Result<(), GovernanceError> {
        self.governance.lock().await.vote(typ, proposal_id, voter, stake, time)
    }
    pub async fn approve_proposal(&self, proposal_id: u64, threshold: u128) -> bool {
        self.governance.lock().await.approve(proposal_id, threshold)
    }

    /// Validator management
    pub async fn add_validator(&self, v: Validator) {
        self.validators.lock().await.add(v);
    }
    pub async fn remove_validator(&self, addr: &str) {
        self.validators.lock().await.remove(addr);
    }
    pub async fn rotate_validators(&self) {
        self.validators.lock().await.rotate();
    }
    pub async fn slash_validator(&self, addr: &str, amount: u128) {
        if let Some(v) = self.validators.lock().await.get_mut(addr) {
            self.slashing.slash(v, amount);
        }
    }
}