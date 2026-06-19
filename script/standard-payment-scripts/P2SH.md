# P2SH

:::info
**Script Type:** Pay-to-Script-Hash (P2SH)  
**Byte representation:** `0xa9 0x14` + 20-byte hash + `0x87`  
**Address format:** Base58Check encoded, starts with `3` (mainnet)  
**Short description:** A script that locks funds to the HASH160 of a redeem script.
:::

Pay-to-Script-Hash (P2SH) allows funds to be locked to the HASH160 of an arbitrary redeem script. At spend time, the spender reveals the redeem script and provides all inputs needed to satisfy it.

### Historical Context

P2SH was introduced in BIP 16, activated in March 2012. Before P2SH, complex spending conditions (like multisig) required embedding the full script in the ScriptPubKey, which was costly and burdensome for the sender. P2SH shifts that complexity to the spender: the sender only needs to know a 20-byte hash, while the spender provides the full script. P2SH addresses are Base58Check encoded and start with `3` on mainnet (e.g. `3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy`). It is still widely used today for multisig wallets and as a wrapper for SegWit outputs (P2SH-P2WPKH, P2SH-P2WSH).

### Operation

1. The ScriptPubKey contains the HASH160 of the redeem script (always 20 bytes).
2. To spend, the ScriptSig must push:
   - All arguments required to satisfy the redeem script (e.g. signatures for a multisig).
   - The serialized redeem script itself as the **final** pushed item.
3. The script engine hashes the top stack item (the redeem script) and checks it matches the hash in the ScriptPubKey via `OP_EQUAL`.
4. If the hash matches, the redeem script is deserialized and executed with the remaining stack items as inputs.
5. If execution of the redeem script succeeds with a truthy top value, the script passes.

### Notes

- The serialized redeem script must always be the **last** item pushed in the ScriptSig.
- The script hash is always 20 bytes (HASH160 output), pushed in the raw ScriptPubKey using `0x14` (push 20 bytes).
- P2SH shifts the transaction size cost and script encoding complexity to the spender rather than the sender.
- On mainnet, P2SH addresses start with `3` due to the Base58Check version byte `0x05`.
- P2SH is also used as a SegWit compatibility wrapper: P2SH-P2WPKH and P2SH-P2WSH wrap native SegWit witness programs inside a P2SH address.

### Example

#### ScriptPubKey

```shell
# ASM
OP_HASH160 <20-byte-scripthash> OP_EQUAL

# Raw bytes
a9 14 <20-byte-scripthash> 87
# a9 = OP_HASH160, 14 = push 20 bytes, 87 = OP_EQUAL
```

#### ScriptSig

```shell
# ASM (example: 2-of-3 multisig redeem script)
OP_0 <sig1> <sig2> <redeem_script>

# Raw bytes
00 <siglen1> <sig1> <siglen2> <sig2> <scriptlen> <redeem_script>
# OP_0 is required due to a known off-by-one bug in OP_CHECKMULTISIG
# The redeem script is always the last pushed item
```
