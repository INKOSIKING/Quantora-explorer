
pub struct Validator {
    pub id: String,
    pub stake: u64,
}

impl Validator {
    pub fn new(id: &str, stake: u64) -> Self {
        Self {
            id: id.to_string(),
            stake,
        }
    }
}

