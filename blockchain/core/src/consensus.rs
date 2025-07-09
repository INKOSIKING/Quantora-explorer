use libp2p::{
    identity, PeerId, Swarm, Multiaddr, noise, tcp, yamux, Transport,
    swarm::{SwarmEvent, NetworkBehaviour},
    mdns::{Mdns, MdnsConfig, MdnsEvent},
    core::upgrade,
};
use std::collections::HashMap;
use tokio::sync::mpsc;
use tracing::{info, error};

#[derive(Debug, Clone)]
pub struct Validator {
    pub address: String,
    pub stake: u64,
}

#[derive(Debug, Clone)]
pub struct ConsensusState {
    pub validators: HashMap<String, Validator>,
    pub epoch: u64,
    pub last_block_hash: String,
}

pub struct PoSConsensus {
    pub state: ConsensusState,
    // Add local node info, channels for blocks/txs, etc.
}

impl PoSConsensus {
    pub fn new(initial_validators: Vec<Validator>, genesis_hash: String) -> Self {
        let mut state = ConsensusState {
            validators: HashMap::new(),
            epoch: 0,
            last_block_hash: genesis_hash,
        };
        for v in initial_validators {
            state.validators.insert(v.address.clone(), v);
        }
        Self { state }
    }

    /// Select next block proposer by weighted random (stake)
    pub fn select_proposer(&self) -> Option<String> {
        let total_stake: u64 = self.state.validators.values().map(|v| v.stake).sum();
        if total_stake == 0 { return None; }
        let r = rand::random::<u64>() % total_stake;
        let mut acc = 0;
        for v in self.state.validators.values() {
            acc += v.stake;
            if r < acc {
                return Some(v.address.clone());
            }
        }
        None
    }

    /// Advance epoch, update state
    pub fn next_epoch(&mut self, new_block_hash: String) {
        self.state.epoch += 1;
        self.state.last_block_hash = new_block_hash;
    }
}

// ==== libp2p networking example ====
// This will allow nodes to discover each other and share blocks/txs
pub async fn start_p2p_node(listen_addr: &str) {
    let id_keys = identity::Keypair::generate_ed25519();
    let peer_id = PeerId::from(id_keys.public());
    info!("Local peer id: {:?}", peer_id);

    let transport = tcp::tokio::Transport::default()
        .upgrade(upgrade::Version::V1)
        .authenticate(noise::NoiseConfig::xx(id_keys).into_authenticated())
        .multiplex(yamux::YamuxConfig::default())
        .boxed();

    #[derive(NetworkBehaviour)]
    struct MyBehaviour {
        mdns: Mdns,
        // ...add Gossipsub, custom RPC, etc...
    }

    let behaviour = MyBehaviour {
        mdns: Mdns::new(MdnsConfig::default()).await.unwrap(),
    };

    let mut swarm = Swarm::new(transport, behaviour, peer_id);
    let addr: Multiaddr = listen_addr.parse().unwrap();
    Swarm::listen_on(&mut swarm, addr).unwrap();

    loop {
        match swarm.select_next_some().await {
            SwarmEvent::Behaviour(MyBehaviourEvent::Mdns(MdnsEvent::Discovered(peers))) => {
                for (peer, _) in peers {
                    info!("Discovered peer: {:?}", peer);
                }
            }
            _ => {}
        }
    }
}