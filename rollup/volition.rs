use super::circuits::ZkCircuit;
use super::aggregator::BatchAggregator;

pub struct VolitionEngine {
    pub aggregator: BatchAggregator,
    pub da_backend: String,
}

impl VolitionEngine {
    pub fn new(aggregator_url: String, da_backend: String) -> Self {
        VolitionEngine {
            aggregator: BatchAggregator::new(aggregator_url),
            da_backend,
        }
    }

    pub fn aggregate_and_prove(&self, txs: &[Vec<u8>]) -> Result<Vec<u8>, String> {
        // In Volition, users choose per-tx if data is on L1 or L2 DA.
        let (l1_txs, l2_txs): (Vec<_>, Vec<_>) = txs.iter().partition(|tx| is_l1(tx));
        let l1_batch = self.aggregator.aggregate(&l1_txs)?;
        let l2_batch = self.aggregator.aggregate(&l2_txs)?;
        let proof_l1 = ZkCircuit::from_batch(&l1_batch).prove()?;
        let proof_l2 = ZkCircuit::from_batch(&l2_batch).prove()?;
        self.aggregator.publish_to_da(&l1_batch, &proof_l1, "L1")?;
        self.aggregator.publish_to_da(&l2_batch, &proof_l2, "L2")?;
        Ok([proof_l1, proof_l2].concat())
    }
}

// In production, this would inspect tx metadata.
fn is_l1(_tx: &Vec<u8>) -> bool {
    // Placeholder: real logic inspects tx data for user DA intent
    false
}