# OP_CHECKSIG

:::info
**Opcode number:** 172  
**Byte representation:** `0xac`  
**Short description:** Verifies a digital signature against a public key and the transaction’s sighash.
:::

`OP_CHECKSIG` is used to verify that a given digital signature is valid for a specific public key and a specific transaction context. It is a cornerstone of Bitcoin’s transaction validation and ensures that only the rightful owner of funds can authorize their spending.

See the [bitcoin wiki page on OP_CHECKSIG](https://en.bitcoin.it/wiki/OP_CHECKSIG) for a more complete treatment of the opcode.

### Operation

1. Takes the top two items from the stack:
    - Signature (top)
    - Public key (second-to-top)
2. Computes the sighash (a hash of the transaction, influenced by the SIGHASH flag).
3. Uses the public key to verify that the signature is valid for the sighash.
4. Pushes 1 (true) onto the stack if valid, or 0 (false) if invalid.

### Notes

- The signature must be a DER-encoded ECDSA signature followed by a one-byte sighash flag.
- The public key can be compressed (33 bytes) or uncompressed (65 bytes).
- If the signature is invalid or the format is incorrect, `OP_CHECKSIG` pushes 0 onto the stack (in Bitcoin Core, certain edge cases trigger a script failure instead).
- `OP_CHECKSIG` is not a pure function—it depends on the transaction context, script location, and the sighash type.
- The presence of `OP_CODESEPARATOR` may affect the portion of the script used in the sighash.

## Example

A standard P2PK script (Pay-to-PubKey). This script checks if the provided signature corresponds to the given public key and the transaction’s sighash.

```shell
# ASM script
<pubkey> OP_CHECKSIG

# Stack (after OP_CHECKSIG)
1      # if valid signature
```
