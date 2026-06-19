# P2SH-P2WPKH

:::info
**Script Type:** Pay-to-Script-Hash of Pay-to-Witness-PubKey-Hash (P2SH-P2WPKH)  
**Byte representation:** `0xa9 0x14` + 20-byte hash + `0x87` (ScriptPubKey — identical to P2SH)  
**Address format:** Base58Check encoded, starts with `3` (mainnet) — indistinguishable from a plain P2SH address  
**Short description:** A wrapped SegWit script: a P2SH address that embeds a native P2WPKH witness program.
:::

P2SH-P2WPKH is a "wrapped SegWit" format introduced alongside SegWit to allow SegWit adoption on wallets and services that only supported legacy P2SH addresses. It wraps a P2WPKH witness program inside a standard P2SH locking script. The actual signature and public key travel in the **witness** field, not the ScriptSig.

### Historical Context

SegWit (BIP 141) was activated on mainnet in August 2017. To ease the transition, BIP 49 defined P2SH-P2WPKH as a compatibility bridge: it uses a `3...` address (familiar to wallets and exchanges) but takes advantage of the SegWit witness structure under the hood. This allowed services to send to SegWit-compatible wallets without needing to support the new bech32 address format. Today, native P2WPKH (bech32 `bc1q...`) is preferred for lower fees and cleaner semantics.

### Operation

P2SH-P2WPKH has three layers:

1. **ScriptPubKey** — a standard P2SH script containing the HASH160 of the redeem script.
2. **ScriptSig** — contains *only* the serialized redeem script, which is the P2WPKH witness program: `OP_0 <20-byte-pubkeyhash>`.
3. **Witness** — contains the signature and public key, exactly as in native P2WPKH.

**Spending flow:**
1. The script engine sees a standard P2SH ScriptPubKey: `OP_HASH160 <hash> OP_EQUAL`.
2. The ScriptSig provides only the redeem script (`OP_0 <pubkeyhash>`). The engine hashes it and verifies the match.
3. The redeem script is recognized as a version-0 witness program (22 bytes: `00 14 <20-byte-hash>`).
4. The witness field is evaluated as P2WPKH: `OP_DUP OP_HASH160 <pubkeyhash> OP_EQUALVERIFY OP_CHECKSIG` is run against the witness `<sig>` and `<pubkey>`.
5. If all checks pass, the script succeeds.

### Notes

- The ScriptPubKey is structurally identical to a regular P2SH output — you cannot distinguish P2SH-P2WPKH from plain P2SH by the address alone.
- The ScriptSig contains **only** the redeem script. Signatures and public keys go in the witness field.
- Witness data benefits from the SegWit weight discount (1 weight unit per byte instead of 4), making transactions cheaper.
- BIP 49 defines the HD wallet derivation path for P2SH-P2WPKH: `m/49'/0'/0'/account'/change/index`.
- This format is considered a transitional compatibility layer. New wallets should prefer native P2WPKH with bech32 addresses.

### Example

#### ScriptPubKey

```shell
# ASM (standard P2SH — identical structure to any P2SH output)
OP_HASH160 <20-byte-hash-of-redeem-script> OP_EQUAL

# Raw bytes
a9 14 <20-byte-hash-of-redeem-script> 87
```

#### ScriptSig

```shell
# ASM (only the redeem script — the P2WPKH witness program)
OP_0 <20-byte-pubkeyhash>

# Raw bytes (the 22-byte redeem script pushed as a single data item)
16 00 14 <20-byte-pubkeyhash>
# 16 = push 22 bytes, 00 = OP_0, 14 = push 20 bytes
```

#### Witness

```shell
# Two items in the witness stack (not in the ScriptSig)
<sig>
<pubkey>

# Example (compressed pubkey)
<siglen> <DER-encoded-sig> 01   # sig + SIGHASH_ALL byte
21 <33-byte-compressed-pubkey>  # 21 = push 33 bytes
```
