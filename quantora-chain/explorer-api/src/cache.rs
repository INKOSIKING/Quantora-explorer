use std::collections::HashMap;
use std::sync::{Arc, RwLock};

pub struct Cache<K, V> {
    map: Arc<RwLock<HashMap<K, V>>>,
}

impl<K, V> Cache<K, V>
where
    K: std::cmp::Eq + std::hash::Hash + Clone,
    V: Clone,
{
    pub fn new() -> Self {
        Cache {
            map: Arc::new(RwLock::new(HashMap::new())),
        }
    }

    pub fn get(&self, k: &K) -> Option<V> {
        self.map.read().unwrap().get(k).cloned()
    }

    pub fn set(&self, k: K, v: V) {
        self.map.write().unwrap().insert(k, v);
    }

    pub fn remove(&self, k: &K) {
        self.map.write().unwrap().remove(k);
    }

    pub fn clear(&self) {
        self.map.write().unwrap().clear();
    }
}