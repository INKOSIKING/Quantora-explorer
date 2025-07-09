from cryptography.hazmat.primitives.ciphers.aead import AESGCM

def encrypt_document(doc: bytes, key: bytes, nonce: bytes) -> bytes:
    aesgcm = AESGCM(key)
    return aesgcm.encrypt(nonce, doc, None)

def decrypt_document(ciphertext: bytes, key: bytes, nonce: bytes) -> bytes:
    aesgcm = AESGCM(key)
    return aesgcm.decrypt(nonce, ciphertext, None)

# Indexing operates on ciphertext; only authorized clients decrypt at search time.