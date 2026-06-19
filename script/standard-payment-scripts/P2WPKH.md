# P2WPKH

:::info
**Script Type:** Pay-to-Witness-PubKey-Hash (P2WPKH)  
**Byte representation:** `0x00 0x14` + 20-byte pubkeyhash (always 22 bytes total)  
**Address format:** bech32 encoded, starts with `bc1q` (mainnet)  
**Short description:** A native SegWit v0 script that locks funds to the HASH160 of a public key.
:::

Pay-to-Witness-PubKey-Hash (P2WPKH) is the native SegWit version of P2PKH. It moves the signature and public key into the transaction's witness field, leaving the ScriptSig empty and enabling a transaction weight discount.

### Historical Context

P2WPKH was introduced with SegWit (BIP 141), activated on mainnet in August 2017 at block 481824. It uses bech32 address encoding (BIP 173), producing addresses that start with `bc1q` on mainnet. BIP 84 defines the HD wallet derivation path for P2WPKH: `m/84'/0'/0'`. A key motivation for SegWit was eliminating transaction malleability — a long-standing issue where a third party could alter witness data and change a transaction's TXID before confirmation. This fix was a prerequisite for the Lightning Network.

### Operation

1. The ScriptPubKey contains a witness version byte (`OP_0`) followed by the 20-byte HASH160 of the recipient's public key.
2. The ScriptSig is **empty** — no data is placed there.
3. To spend, the witness field provides:
   - A valid DER-encoded signature (+ sighash type byte).
   - The compressed public key.
4. The script engine computes HASH160 of the provided public key and verifies it matches the hash in the ScriptPubKey.
5. `OP_CHECKSIG` verifies the signature against the transaction data and the public key.
6. If both checks pass, the script succeeds.

### Notes

- The ScriptSig is always **empty** for P2WPKH. All spending data is in the witness field.
- Witness bytes are counted at 1 weight unit instead of 4, making P2WPKH transactions cheaper than P2PKH.
- P2WPKH addresses use bech32 encoding and start with `bc1q` on mainnet.
- BIP 84 defines the derivation path: `m/84'/0'/0'/account'/change/index`.
- The pubkeyhash is always 20 bytes, produced by HASH160 (SHA256 then RIPEMD160 of the compressed public key).

### Example

#### ScriptPubKey

```shell
# ASM
OP_0 <20-byte-pubkeyhash>

# Raw bytes (always 22 bytes)
00 14 <20-byte-pubkeyhash>
# 00 = OP_0 (witness version 0), 14 = push 20 bytes
```

#### ScriptSig

```shell
# Always empty for P2WPKH
(empty)
```

#### Witness

```shell
# Two items in the witness stack
<sig>
<pubkey>

# Example (compressed pubkey)
<siglen> <DER-encoded-sig> 01   # sig + SIGHASH_ALL byte
21 <33-byte-compressed-pubkey>  # 21 = push 33 bytes
```
