import bitcoin
from bitcoin.wallet import CBitcoinSecret, P2SHBitcoinAddress, CBitcoinAddress, CBitcoinAddressError
from bitcoin.core import COIN, b2lx, lx, COutPoint, CTxIn, CTxOut, CMutableTxOut, CMutableTxIn, CMutableTransaction
from bitcoin.core.script import CScript, OP_CHECKMULTISIG

def create_multisig_address(pubkeys, m_required):
    # pubkeys: List of hex-encoded public keys
    redeem_script = CScript([m_required] + [bytes.fromhex(k) for k in pubkeys] + [len(pubkeys), OP_CHECKMULTISIG])
    address = P2SHBitcoinAddress.from_redeemScript(redeem_script)
    return str(address), redeem_script.hex()

def sign_and_send(tx_hex, privkeys, redeem_script_hex):
    # tx_hex: hex-encoded unsigned transaction
    # privkeys: WIF-encoded private keys for signing
    # redeem_script_hex: hex of redeem script
    # Use bitcoinlib or custom code for signing
    # Broadcast with RPC, log txid, and alert compliance team
    pass