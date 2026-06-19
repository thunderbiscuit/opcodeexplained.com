# P2WSH

:::info
**Script Type:** Pay-to-Witness-Script-Hash (P2WSH)  
**Byte representation:** `0x00 0x20` + 32-byte SHA256 witness script hash (always 34 bytes total)  
**Address format:** bech32 encoded, starts with `bc1q` (mainnet) — longer than P2WPKH  
**Short description:** A native SegWit v0 script that locks funds to the SHA256 hash of a witness script, enabling complex multi-party conditions with the SegWit weight discount.
:::

Pay-to-Witness-Script-Hash (P2WSH) is the native SegWit equivalent of P2SH. It locks funds to the SHA256 hash of an arbitrary witness script. At spend time, the spender reveals the full witness script and all required inputs in the witness field, leaving the ScriptSig entirely empty.

### Historical Context

P2WSH was introduced with SegWit (BIP 141), activated on mainnet in August 2017. It serves the same role as P2SH — enabling complex scripts like multisig — but with two key improvements: the script hash is 32 bytes (SHA256 only, not HASH160), providing stronger collision resistance, and all witness data receives the SegWit weight discount. P2WSH addresses use bech32 encoding (BIP 173) and share the `bc1q` prefix with P2WPKH, but are 62 characters long compared to P2WPKH's 42. Like P2SH, P2WSH is also available in a wrapped form (P2SH-P2WSH) for backward compatibility with legacy wallets.

### Operation

1. The ScriptPubKey contains a witness version byte (`OP_0`) followed by the 32-byte SHA256 hash of the witness script.
2. The ScriptSig is **empty** — no data is placed there.
3. To spend, the witness field must provide:
   - All inputs required by the witness script (e.g. signatures for a multisig).
   - The full serialized witness script as the **last** item.
4. The script engine hashes the last witness item (the witness script) with SHA256 and verifies it matches the hash in the ScriptPubKey.
5. If the hash matches, the witness script is deserialized and executed with the remaining witness stack items as inputs.
6. If the witness script executes successfully with a truthy top value, the script passes.

### Notes

- The ScriptSig is always **empty** for P2WSH. All spending data goes in the witness field.
- P2WSH uses SHA256 (32 bytes) for its script hash, unlike P2SH which uses HASH160 (20 bytes). This provides stronger preimage resistance.
- The witness script must be the **last** item in the witness stack.
- Witness data benefits from the SegWit weight discount (1 weight unit per byte instead of 4), making complex scripts such as large multisigs significantly cheaper than their P2SH equivalents.
- P2WSH is commonly used for Lightning Network channel funding outputs and multisig wallets.
- P2WSH addresses start with `bc1q` on mainnet and are 62 characters long (vs. 42 for P2WPKH), making them visually distinguishable.

### Example

#### ScriptPubKey

```shell
# ASM (e.g. for a 2-of-3 multisig witness script)
OP_0 <32-byte-sha256-witness-script-hash>

# Raw bytes (always 34 bytes)
00 20 <32-byte-sha256-witness-script-hash>
# 00 = OP_0 (witness version 0), 20 = push 32 bytes
```

#### ScriptSig

```shell
# Always empty for P2WSH
(empty)
```

#### Witness

```shell
# Witness stack items: inputs required by the script + the witness script last
# Example: 2-of-3 multisig

OP_0          # required due to off-by-one bug in OP_CHECKMULTISIG
<sig1>
<sig2>
<witness_script>

# Where the witness script is the serialized redeem logic, e.g.:
# OP_2 <pubkey1> <pubkey2> <pubkey3> OP_3 OP_CHECKMULTISIG
```
