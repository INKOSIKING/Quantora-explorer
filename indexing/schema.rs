use std::sync::Arc;

#[derive(Clone)]
pub struct SchemaRegistry {
    pub name: String,
    pub schemas: Vec<SchemaDef>,
}

#[derive(Clone)]
pub struct SchemaDef {
    pub entity: String,
    pub fields: Vec<(String, String)>,
}

impl Default for SchemaRegistry {
    fn default() -> Self {
        Self {
            name: "QuantoraChain".to_string(),
            schemas: vec![
                SchemaDef {
                    entity: "blocks".to_string(),
                    fields: vec![
                        ("hash".to_string(), "bytes32".to_string()),
                        ("number".to_string(), "u64".to_string()),
                        ("parent_hash".to_string(), "bytes32".to_string()),
                    ],
                },
                SchemaDef {
                    entity: "transactions".to_string(),
                    fields: vec![
                        ("tx_hash".to_string(), "bytes32".to_string()),
                        ("from".to_string(), "address".to_string()),
                        ("to".to_string(), "address".to_string()),
                        ("amount".to_string(), "u128".to_string()),
                    ],
                },
            ],
        }
    }
}