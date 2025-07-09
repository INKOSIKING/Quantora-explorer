pub mod runtime;
pub mod rollup;
pub mod da;
pub mod ai_verification;
pub mod indexing;
pub mod creator;
pub mod governance;
pub mod validator;
pub mod crypto;
pub mod fees;
pub mod transfer;
pub mod stake;
pub mod api; // REST API

use runtime::vm::{VmDispatch, VmType, VmContext};
use rollup::{RollupContext, RollupConfig, L2Mode};
use da::{DALayer, DAConfig, DAType};
use ai_verification::AIValidationLayer;
use indexing::IndexingLayer;
use creator::CreatorHub;
use governance::GovernanceHub;
use validator::ValidatorLayer;
use crypto::{CryptoLayer, CryptoSuite};
use fees::{FeeManager, FeeConfig};
use transfer::{send_tokens, receive_tokens};
use stake::{stake_tokens, unstake_tokens};

pub struct QuantoraConfig {
    pub vm_type: VmType,
    pub l2_mode: L2Mode,
    pub da_config: DAConfig,
    pub rollup_config: RollupConfig,
    pub crypto_suite: CryptoSuite,
    pub fee_config: FeeConfig,
}

pub struct Quantora {
    pub vm: VmDispatch,
    pub rollup: RollupContext,
    pub da: DALayer,
    pub ai: AIValidationLayer,
    pub indexing: IndexingLayer,
    pub creator: CreatorHub,
    pub governance: GovernanceHub,
    pub validator: ValidatorLayer,
    pub crypto: CryptoLayer,
    pub fees: FeeManager,
    pub config: QuantoraConfig,
}

impl Quantora {
    pub async fn new(config: QuantoraConfig) -> Self {
        let da = DALayer::new(config.da_config.clone());
        let rollup = RollupContext::new(config.rollup_config.clone());
        let fees = FeeManager::new(config.fee_config.clone()).await;
        Self {
            vm: VmDispatch::new(),
            rollup,
            da,
            ai: AIValidationLayer::new(),
            indexing: IndexingLayer::new(),
            creator: CreatorHub::new(),
            governance: GovernanceHub::new(),
            validator: ValidatorLayer::new(),
            crypto: CryptoLayer::new(),
            fees,
            config,
        }
    }
    // ... (all robust methods for each module with fee enforcement, as shown earlier)
}