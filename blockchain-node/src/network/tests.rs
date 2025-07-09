#[cfg(test)]
mod tests {
    use super::*;
    use std::net::{SocketAddr, IpAddr, Ipv4Addr};

    #[test]
    fn peer_set_add_and_remove() {
        let peer_set = PeerSet::new();
        let addr1 = SocketAddr::new(IpAddr::V4(Ipv4Addr::LOCALHOST), 9001);
        let addr2 = SocketAddr::new(IpAddr::V4(Ipv4Addr::LOCALHOST), 9002);

        peer_set.add_peer(addr1);
        peer_set.add_peer(addr2);

        let peers = peer_set.get_peers();
        assert!(peers.contains(&addr1));
        assert!(peers.contains(&addr2));

        peer_set.remove_peer(&addr1);
        let peers = peer_set.get_peers();
        assert!(!peers.contains(&addr1));
        assert!(peers.contains(&addr2));
    }

    #[test]
    fn peer_set_max_peers() {
        let peer_set = PeerSet::new();
        for i in 0..(MAX_PEERS + 10) {
            let addr = SocketAddr::new(IpAddr::V4(Ipv4Addr::LOCALHOST), 10000 + i as u16);
            peer_set.add_peer(addr);
        }
        let peers = peer_set.get_peers();
        assert_eq!(peers.len(), MAX_PEERS);
    }
}