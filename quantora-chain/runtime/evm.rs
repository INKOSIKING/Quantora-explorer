//! EVM Execution Module: Ethereum-compatible smart contracts

use evm::{Config, Context, ExitReason, Handler, Runtime, ExitSucceed, ExitError};
use evm::backend::MemoryBackend;

pub struct EvmHandler {
    config: Config,
}

impl EvmHandler {
    pub fn new() -> Self {
        EvmHandler {
            config: Config::istanbul(),
        }
    }

    pub fn execute(&self, bytecode: &[u8], input: &[u8]) -> Result<Vec<u8>, String> {
        let mut backend = MemoryBackend::default();
        let context = Context {
            address: Default::default(),
            caller: Default::default(),
            apparent_value: Default::default(),
        };
        let mut runtime = Runtime::new(bytecode, input, context, &self.config);
        match runtime.run(&mut backend) {
            Ok(ExitReason::Succeed(ExitSucceed::Stopped)) => Ok(runtime.machine().return_value().to_vec()),
            Ok(reason) => Err(format!("EVM execution failed: {:?}", reason)),
            Err(e) => Err(format!("EVM runtime error: {:?}", e)),
        }
    }
}