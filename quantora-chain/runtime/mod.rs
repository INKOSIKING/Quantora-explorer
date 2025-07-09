//! Multi-VM Runtime: EVM, WASM, Move, Cairo (async, composable, production-ready)
pub mod evm;
pub mod wasm;
pub mod movevm;
pub mod cairo;

use thiserror::Error;
use async_trait::async_trait;

#[derive(Debug, Clone, Copy)]
pub enum VmType {
    Evm,
    Wasm,
    Move,
    Cairo,
}

#[derive(Debug, Error)]
pub enum RuntimeError {
    #[error("EVM error: {0}")]
    Evm(String),
    #[error("WASM error: {0}")]
    Wasm(String),
    #[error("Move error: {0}")]
    Move(String),
    #[error("Cairo error: {0}")]
    Cairo(String),
    #[error("Invalid VM")]
    InvalidVm,
}

#[async_trait]
pub trait VmExecutor: Send + Sync {
    async fn execute(&self, code: &[u8], input: &[u8]) -> Result<Vec<u8>, RuntimeError>;
    fn vm_type(&self) -> VmType;
}

pub struct Runtime {
    pub evm: evm::EvmHandler,
    pub wasm: wasm::WasmHandler,
    pub movevm: movevm::MoveHandler,
    pub cairo: cairo::CairoHandler,
}

impl Runtime {
    pub fn new() -> Self {
        Runtime {
            evm: evm::EvmHandler::default(),
            wasm: wasm::WasmHandler::default(),
            movevm: movevm::MoveHandler::default(),
            cairo: cairo::CairoHandler::default(),
        }
    }

    pub async fn execute(
        &self,
        vm_type: VmType,
        code: &[u8],
        input: &[u8],
    ) -> Result<Vec<u8>, RuntimeError> {
        match vm_type {
            VmType::Evm => self.evm.execute(code, input).await,
            VmType::Wasm => self.wasm.execute(code, input).await,
            VmType::Move => self.movevm.execute(code, input).await,
            VmType::Cairo => self.cairo.execute(code, input).await,
        }
    }
}