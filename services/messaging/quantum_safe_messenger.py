from pqcrypto.kem.kyber768 import generate_keypair, encrypt, decrypt

# Generate keys for each user/session
pk, sk = generate_keypair()
def encrypt_message(msg: bytes, recipient_pk: bytes) -> bytes:
    ciphertext, shared_secret = encrypt(recipient_pk)
    # Use shared_secret with symmetric encryption (e.g., AES-GCM) for the message itself
    ...

def decrypt_message(ciphertext: bytes, sk: bytes) -> bytes:
    shared_secret = decrypt(ciphertext, sk)
    ...