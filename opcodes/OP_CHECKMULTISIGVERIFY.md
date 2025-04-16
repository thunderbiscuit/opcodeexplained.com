# OP_CHECKMULTISIGVERIFY

:::info
**Opcode number:** 175  
**Byte representation:** `0xaf`  
**Short description:** Verify multiple signatures and fail the script if the verification fails.
:::

`OP_CHECKMULTISIGVERIFY` combines `OP_CHECKMULTISIG` and `OP_VERIFY`. It checks whether a set of signatures are valid for a set of public keys and fails the script immediately if the verification fails. Unlike `OP_CHECKMULTISIG`, it does not push a result to the stack; it either passes silently or causes script failure.

### Operation

1. Pops an integer n: total number of public keys.
2. Pops n public keys.
3. Pops an integer m: number of required signatures.
4. Pops m signatures.
5. Pops one extra unused value (typically OP_0 — see bug note below).
6. Verifies that at least m signatures are valid for the public keys.
7. If valid: continue script execution.
8. If invalid: script fails immediately.

### Notes

- Functionally equivalent to `OP_CHECKMULTISIG OP_VERIFY`, but more compact.
- The dummy `OP_0` is still required due to the historical off-by-one bug in `OP_CHECKMULTISIG`. See the [`OP_CHECKMULTISIG`](./OP_CHECKMULTISIG.md) page for details of this bug.
- Used in scripts where the multisig check must pass for the script to continue—ideal when no result is needed on the stack.
- Used in P2SH scripts that chain multiple verification steps.
- Special quirk: The dummy value. As with `OP_CHECKMULTISIG`, you must include a dummy element (`OP_0`) before the signatures. This accounts for a bug in the original implementation that incorrectly counted elements during verification. Even though it has no effect, omitting it will break the script.

## Examples

Example 1

2-of-3 multisig, verification required.

```shell
# ASM script
OP_2 <pubkey1> <pubkey2> <pubkey3> OP_3 OP_CHECKMULTISIGVERIFY

# Raw script (simplified)
00 <sig1> <sig2> 52 <pk1> <pk2> <pk3> 53 ae

# Stack (after OP_CHECKMULTISIGVERIFY)
(empty) — continues execution if valid
```
