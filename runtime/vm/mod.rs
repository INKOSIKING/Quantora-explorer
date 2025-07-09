pub mod evm;
pub mod wasm;
pub mod move_vm;
pub mod dispatcher;

use crate::runtime::vm::dispatcher::VmDispatch;
use crate::runtime::vm::evm::EvmVm;
use crate::runtime::vm::wasm::WasmVm;
use crate::runtime::vm::move_vm::MoveVm;

pub enum VmType {
    Evm,
    Wasm,
    Move,
}

pub trait VirtualMachine {
    fn execute(&self, code: &[u8], input: &[u8], context: &VmContext) -> Result<Vec<u8>, VmError>;
    fn validate(&self, code: &[u8]) -> Result<(), VmError>;
}

pub struct VmContext {
    pub caller: [u8; 20],
    pub value: u128,
    pub gas_limit: u64,
    pub block_number: u64,
    // ... more context fields
}

#[derive(Debug)]
pub enum VmError {
    OutOfGas,
    InvalidOpcode,
    Revert,
    ValidationFailed,
    ExecutionFailed(String),
    UnsupportedVm,
}