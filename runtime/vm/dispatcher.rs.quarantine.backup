use super::{evm::EvmVm, wasm::WasmVm, move_vm::MoveVm, VmType, VmContext, VirtualMachine, VmError};

pub struct VmDispatch {
    pub evm: EvmVm,
    pub wasm: WasmVm,
    pub move_vm: MoveVm,
}

impl VmDispatch {
    pub fn new() -> Self {
        VmDispatch {
            evm: EvmVm::new(),
            wasm: WasmVm::new(),
            move_vm: MoveVm::new(),
        }
    }

    pub fn execute(
        &self,
        vm_type: VmType,
        code: &[u8],
        input: &[u8],
        ctx: &VmContext,
    ) -> Result<Vec<u8>, VmError> {
        match vm_type {
            VmType::Evm => self.evm.execute(code, input, ctx),
            VmType::Wasm => self.wasm.execute(code, input, ctx),
            VmType::Move => self.move_vm.execute(code, input, ctx),
        }
    }

    pub fn validate(&self, vm_type: VmType, code: &[u8]) -> Result<(), VmError> {
        match vm_type {
            VmType::Evm => self.evm.validate(code),
            VmType::Wasm => self.wasm.validate(code),
            VmType::Move => self.move_vm.validate(code),
        }
    }
}