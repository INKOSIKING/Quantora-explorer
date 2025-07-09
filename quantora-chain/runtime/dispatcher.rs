//! Advanced multi-VM dispatcher with logging, events, and validation

use super::{evm::EvmHandler, wasm::WasmHandler, movevm::MoveHandler, cairo::CairoHandler, VmType, RuntimeError};
use async_trait::async_trait;
use tracing::{info, error};
use std::sync::Arc;

pub struct VmDispatcher {
    pub evm: Arc<EvmHandler>,
    pub wasm: Arc<WasmHandler>,
    pub movevm: Arc<MoveHandler>,
    pub cairo: Arc<CairoHandler>,
}

impl VmDispatcher {
    pub fn new() -> Self {
        Self {
            evm: Arc::new(EvmHandler::default()),
            wasm: Arc::new(WasmHandler::default()),
            movevm: Arc::new(MoveHandler::default()),
            cairo: Arc::new(CairoHandler::default()),
        }
    }

    /// Dispatch smart contract execution to the requested VM
    pub async fn execute(
        &self,
        vm_type: VmType,
        code: &[u8],
        input: &[u8],
        sender: &str,
    ) -> Result<Vec<u8>, RuntimeError> {
        info!(target: "vm_dispatch", "Executing on VM {:?} from sender {}", vm_type, sender);
        let output = match vm_type {
            VmType::Evm => self.evm.execute(code, input).await,
            VmType::Wasm => self.wasm.execute(code, input).await,
            VmType::Move => self.movevm.execute(code, input).await,
            VmType::Cairo => self.cairo.execute(code, input).await,
        };
        match &output {
            Ok(_) => info!(target: "vm_dispatch", "Execution succeeded"),
            Err(e) => error!(target: "vm_dispatch", "Execution failed: {}", e),
        }
        output
    }
}