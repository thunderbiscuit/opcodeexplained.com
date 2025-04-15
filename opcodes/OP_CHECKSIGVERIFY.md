# OP_CHECKSIGVERIFY

:::info
**Opcode number:** 173  
**Byte representation:** `0xad`  
**Short description:** Verify a digital signature; fail the script if it is invalid.
:::

`OP_CHECKSIGVERIFY` combines the behavior of `OP_CHECKSIG` and `OP_VERIFY`. It checks whether a given signature is valid for a public key and a transaction’s sighash. If the verification fails, the entire script immediately fails. If successful, it removes the signature and public key from the stack and continues execution.

### Operation

1. Pop the top two items from the stack:
    - Signature (top)
    - Public key (second-to-top)
2. Verify that the signature is valid for the public key and the given sighash.
3. If valid: nothing is pushed and script evaluation continues.
4. If invalid: script fails immediately.

### Notes

- Equivalent to `OP_CHECKSIG` `OP_VERIFY`, but more compact and efficient.
- A failed verification results in an immediate script failure—no value is pushed to the stack.

## Examples

### Example 1

Typical usage in a P2PK-like script that must validate a signature:

```shell
# ASM script
<sig> <pubkey> OP_CHECKSIGVERIFY

# Stack (after OP_CHECKSIGVERIFY)
(empty)  # signature verified and removed from stack
```

### Example 2

Invalid signature results in script failure:

```shell
# Stack (before OP_CHECKSIGVERIFY)
<invalid_sig> <pubkey> OP_CHECKSIGVERIFY

# Execution result
Script fails immediately, and no value is pushed to the stack.
```
