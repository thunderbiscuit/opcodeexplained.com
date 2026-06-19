# P2PKH

:::info
**Script Type:** Pay-to-PubKey-Hash (P2PKH)  
**Byte representation:** `0x76 0xa9 0x14` + 20-byte hash + `0x88 0xac`  
**Address format:** Base58Check encoded, starts with `1` (mainnet)  
**Short description:** A script that locks funds to the HASH160 of a public key.
:::

Pay-to-PubKey-Hash (P2PKH) is the most widely used legacy Bitcoin payment script. It locks funds to the HASH160 (RIPEMD160 of SHA256) of a public key, requiring the spender to reveal the public key and provide a valid signature to unlock the funds.

### Historical Context

P2PKH was introduced early in Bitcoin's history as an improvement over P2PK. By hashing the public key, it keeps the key hidden until spend time — improving both privacy and efficiency. P2PKH addresses are Base58Check encoded and start with `1` on mainnet (e.g. `1A1zP1eP5QGefi2DMPTfTL5SLmv7Divf Na`). This was the dominant address format until native SegWit addresses were introduced in 2017.

### Operation

1. The ScriptPubKey contains the HASH160 of the recipient's public key (always 20 bytes).
2. `OP_DUP` duplicates the top stack item (the public key provided in the ScriptSig).
3. `OP_HASH160` hashes the duplicate: first SHA256, then RIPEMD160, producing a 20-byte hash.
4. The 20-byte expected hash from the script is pushed onto the stack.
5. `OP_EQUALVERIFY` checks that the computed hash matches. If not, the script fails immediately.
6. `OP_CHECKSIG` verifies the signature against the original (non-hashed) public key. Pushes `1` if valid.

### Notes

- P2PKH improves privacy over P2PK: the public key is only revealed when funds are spent, not when they are received.
- The pubkey hash is always 20 bytes — the result of HASH160 (SHA256 then RIPEMD160). It is pushed in the raw script using opcode `0x14` (push 20 bytes).
- On mainnet, P2PKH addresses start with `1` due to the Base58Check version byte `0x00`.
- Once a P2PKH address has been spent from, the public key becomes visible on-chain. Reusing the same address after spending weakens privacy and exposes the public key to future scrutiny.

### Example

#### ScriptPubKey

```shell
# ASM
OP_DUP OP_HASH160 <20-byte-pubkeyhash> OP_EQUALVERIFY OP_CHECKSIG

# Raw bytes
76 a9 14 <20-byte-pubkeyhash> 88 ac
# 76 = OP_DUP, a9 = OP_HASH160, 14 = push 20 bytes, 88 = OP_EQUALVERIFY, ac = OP_CHECKSIG
```

#### ScriptSig

```shell
# ASM
<sig> <pubkey>

# Raw bytes (compressed pubkey example)
<siglen> <DER-encoded-sig> 01  21 <33-byte-pubkey>
# siglen: typically 0x47 or 0x48 (71 or 72 bytes incl. sighash type)
# 21 = push 33 bytes (compressed pubkey, prefix 02 or 03)
```
