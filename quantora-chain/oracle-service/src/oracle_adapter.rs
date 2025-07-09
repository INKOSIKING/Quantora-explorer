use std::collections::HashMap;

pub struct OracleAdapter {
    data_sources: HashMap<String, String>,
}

impl OracleAdapter {
    pub fn new() -> Self {
        OracleAdapter {
            data_sources: HashMap::new(),
        }
    }

    pub fn add_source(&mut self, name: &str, url: &str) {
        self.data_sources.insert(name.to_string(), url.to_string());
    }

    pub fn fetch_price(&self, asset: &str) -> Option<f64> {
        // Simulated fetch from an external API
        match asset {
            "BTC" => Some(65000.0),
            "ETH" => Some(3500.0),
            _ => None,
        }
    }
}