//! WASM Smart Contract Execution Module

use wasmer::{Instance, Module, Store, imports};
use crate::runtime::evm::MultiVm;

pub struct WasmHandler {
    store: Store,
}

impl WasmHandler {
    pub fn new() -> Self {
        Self { store: Store::default() }
    }

    pub fn execute(&self, wasm_code: &[u8]) -> Result<(), String> {
        let module = Module::new(&self.store, wasm_code).map_err(|e| e.to_string())?;
        let import_object = imports! {};
        let _instance = Instance::new(&module, &import_object).map_err(|e| e.to_string())?;
        Ok(())
    }
}

impl MultiVm for WasmHandler {
    fn execute(&self, code: &[u8], _context: &evm::Context) -> Result<Vec<u8>, String> {
        self.execute(code)?;
        Ok(vec![])
    }
}