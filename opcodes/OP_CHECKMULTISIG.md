# OP_CHECKMULTISIG

:::info
**Opcode number:** 174  
**Byte representation:** `0xae`  
**Short description:** Verify multiple signatures against a set of public keys.
:::

`OP_CHECKMULTISIG` verifies that a specified number of signatures are valid for a given list of public keys. It is commonly used in m-of-n multisig scripts, where m is the number of required signatures and n is the total number of public keys.

This opcode is used in older bitcoin scripts like Pay-to-Script-Hash (P2SH) multisig. While superseded in some use cases by Schnorr-based Taproot multisig, `OP_CHECKMULTISIG` is still valid and widely supported.

### Operation

1. Pop an integer `n` from the stack (total number of public keys).
2. Pop `n` public keys.
3. Pop an integer `m` (number of required signatures).
4. Pop `m` signatures.
5. Pop one extra unused value (see special quirk note below).
6. For each signature, verify it against the list of public keys.
7. If at least `m` signatures are valid for any `m` public keys (in order), push `1`; otherwise push `0`.

### Notes

- Public keys and signatures must be provided in the same order.
- The opcode consumes one extra stack element (typically an empty OP_0) due to a historical bug in the original Bitcoin implementation. This must always be included.
- Signatures must be DER-encoded and end with a sighash flag.
- The m and n values must be small integers (between 0 and 20); they are typically pushed using OP_1 through OP_20.
- Special quirk: The Dummy Value. Bitcoin’s original implementation accidentally popped an extra item from the stack. To maintain compatibility, all uses of `OP_CHECKMULTISIG` must include a dummy value (commonly `OP_0`) before the signatures. This is required even though this value is not used.

## Example

2-of-3 multisig script.

```shell
# ASM script
OP_2 <pubkey1> <pubkey2> <pubkey3> OP_3 OP_CHECKMULTISIG

# Raw script (simplified)
00 <sig1> <sig2> 52 <pk1> <pk2> <pk3> 53 ae

# Stack (after OP_CHECKMULTISIG)
1  # if both signatures are valid for any 2 of the 3 pubkeys
```
