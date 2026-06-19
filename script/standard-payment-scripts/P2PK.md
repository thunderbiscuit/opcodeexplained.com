# P2PK

:::info
**Script Type:** Pay-to-PubKey (P2PK)  
**Byte representation:** `0x21` + pubkey + `0xac` (compressed) or `0x41` + pubkey + `0xac` (uncompressed)  
**Address format:** None — P2PK has no standard Bitcoin address encoding  
**Short description:** A script that locks funds directly to a public key.
:::

Pay-to-PubKey (P2PK) is one of the simplest and oldest Bitcoin payment scripts. It locks funds directly to a public key, requiring a valid signature from the corresponding private key to spend them.

### Historical Context

P2PK is the original Bitcoin payment script used by Satoshi Nakamoto in the genesis block and in early coinbase outputs. In those early days, uncompressed 65-byte public keys were the norm; compressed 33-byte keys became standard later. P2PK has since been superseded by P2PKH, which improves privacy by withholding the public key from the locking script. Notably, P2PK has no standard address format — funds locked in P2PK outputs cannot be represented as a traditional Bitcoin address.

### Operation

**Locking (ScriptPubKey):**
1. The recipient's public key is embedded directly in the script.
2. `OP_CHECKSIG` signals that a valid signature will be required to spend.

**Unlocking (ScriptSig):**
1. The spender pushes a DER-encoded signature (appended with a sighash type byte) onto the stack.
2. `OP_CHECKSIG` pops the signature and the public key, verifies the ECDSA signature against the transaction data, and pushes `1` (true) if valid or `0` (false) if not.
3. If the result is `0`, the script fails.

### Notes

- P2PK exposes the public key in the locking script itself, making it visible on-chain before any spending occurs. P2PKH only reveals the public key at spend time.
- There is no P2PK address format. You cannot represent a P2PK output as a standard Base58Check or bech32 address.
- Uncompressed public keys (65 bytes, prefix `04`) were common in early Bitcoin. Compressed keys (33 bytes, prefix `02` or `03`) are standard today.
- A large amount of early Bitcoin — including Satoshi's coinbase rewards — is locked in P2PK outputs. Their public keys are already visible on-chain, making them potentially vulnerable to future quantum computing attacks.

### Example

#### ScriptPubKey

```shell
# ASM (compressed pubkey)
<33-byte-pubkey> OP_CHECKSIG

# ASM (uncompressed pubkey, early Bitcoin)
<65-byte-pubkey> OP_CHECKSIG

# Raw bytes (compressed)
21 <33-byte-pubkey> ac

# Raw bytes (uncompressed)
41 <65-byte-pubkey> ac
```

#### ScriptSig

```shell
# ASM
<sig>

# Raw bytes
# Signature is DER-encoded + 1-byte sighash type (01 = SIGHASH_ALL)
<siglen> <DER-encoded-sig> 01
# Example: 48 <71-byte DER sig> 01
```
