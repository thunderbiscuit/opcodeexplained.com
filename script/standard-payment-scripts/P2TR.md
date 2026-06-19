# P2TR

:::info
**Script Type:** Pay-to-Taproot (P2TR)  
**Byte representation:** `0x51 0x20` + 32-byte x-only tweaked pubkey (always 34 bytes total)  
**Address format:** bech32m encoded, starts with `bc1p` (mainnet)  
**Short description:** A SegWit v1 script that locks funds to a Taproot tweaked x-only public key, supporting both key path and script path spending.
:::

Pay-to-Taproot (P2TR) is the most expressive Bitcoin payment type available today. It locks funds to a 32-byte x-only public key that commits to both a key path (a single Schnorr signature) and an optional Merkle tree of spending scripts. Unexercised script branches are never revealed on-chain.

### Historical Context

P2TR was introduced by the Taproot soft fork, which bundled three BIPs: BIP 340 (Schnorr Signatures), BIP 341 (Taproot), and BIP 342 (Tapscript). It activated on mainnet in November 2021 at block 709632. Taproot replaced ECDSA with Schnorr signatures, enabling key and signature aggregation schemes like MuSig2. P2TR addresses use bech32m encoding (BIP 350) and start with `bc1p` on mainnet. BIP 86 defines the HD wallet derivation path: `m/86'/0'/0'`.

### Operation

P2TR supports two spending paths:

**Key path spend:**
1. The ScriptPubKey contains `OP_1 <32-byte-tweaked-x-only-pubkey>`.
2. The ScriptSig is **empty**.
3. The spender provides a single 64-byte Schnorr signature in the witness field.
4. The signature is verified against the tweaked public key using BIP 340 Schnorr verification. If valid, the script succeeds.

**Script path spend:**
1. Same ScriptPubKey — only the witness data differs.
2. The spender provides in the witness: all inputs required by the leaf script, the leaf script itself, and a control block.
3. The control block encodes the internal public key and a Merkle proof demonstrating that the leaf script is committed to by the output key.
4. The script engine verifies the Merkle proof, then executes the leaf script with the provided inputs.
5. If the script executes successfully, the spend is valid.

### Notes

- The output key is a *tweaked* key: `Q = P + t·G`, where `t = HASH(P || merkle_root)`. This mathematically commits all script paths into the key itself.
- If no script paths are needed, the key is tweaked with just the internal key hash, resulting in a key-path-only output that is indistinguishable on-chain from one with a full script tree.
- All unexercised script branches remain private — only the executed path (or none, for key path) is ever revealed.
- Schnorr signatures (BIP 340) are 64 bytes, more compact than DER-encoded ECDSA, and enable key aggregation.
- The ScriptSig is always **empty** for P2TR.
- All P2TR outputs look identical on-chain regardless of the underlying script tree, improving privacy for all users.
- BIP 86 derivation path: `m/86'/0'/0'/account'/change/index`.

### Example

#### ScriptPubKey

```shell
# ASM
OP_1 <32-byte-x-only-tweaked-pubkey>

# Raw bytes (always 34 bytes)
51 20 <32-byte-x-only-tweaked-pubkey>
# 51 = OP_1 (witness version 1), 20 = push 32 bytes
```

#### ScriptSig

```shell
# Always empty for P2TR
(empty)
```

#### Witness — Key Path Spend

```shell
# Single Schnorr signature (64 bytes)
<64-byte-schnorr-sig>

# With non-default sighash type appended (optional)
<64-byte-schnorr-sig> <sighash_type>
# SIGHASH_DEFAULT (implicit) = commits to all inputs and outputs
```

#### Witness — Script Path Spend

```shell
# Stack items required by the script, then the script, then the control block
<script_input_1> ... <script_input_n>
<leaf_script>
<control_block>

# Control block structure:
# [leaf_version + output_key_parity (1 byte)]
# [internal_x_only_pubkey (32 bytes)]
# [merkle_proof_node_1 (32 bytes)] ... [merkle_proof_node_n (32 bytes)]
```
