//! WASM Smart Contract Execution Module (CosmWasm/ParityWasm style)

use wasmer::{imports, Instance, Module, Store, Value, Function, Exports, ImportObject};
use anyhow::Result;

pub struct WasmHandler {
    store: Store,
}

impl WasmHandler {
    pub fn new() -> Self {
        WasmHandler {
            store: Store::default(),
        }
    }

    pub fn execute(&self, code: &[u8], input: &[u8]) -> Result<Vec<u8>, String> {
        let module = Module::new(&self.store, code).map_err(|e| e.to_string())?;
        let import_object = imports! {};
        let instance = Instance::new(&module, &import_object).map_err(|e| e.to_string())?;
        let main = instance.exports.get_function("main").map_err(|e| e.to_string())?;
        let result = main.call(&[Value::I32(input.len() as i32)]).map_err(|e| e.to_string())?;
        // You may want to expand to use memory for input/output
        Ok(vec![])
    }
}