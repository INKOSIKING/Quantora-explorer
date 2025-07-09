import os, hashlib

class Wallet:
    def __init__(self):
        self.privkey = os.urandom(32)
        self.pubkey = hashlib.sha256(self.privkey).hexdigest()
    # ... sign, verify, balance ...