# OP_CHECKSIGADD

:::info
**Opcode number:** 186
**Byte representation:** `0xba`
**Short description:** Verify a signature and adds the result (0 or 1) to the top stack item.
:::

`OP_CHECKSIGADD` is a Taproot-era opcode introduced with [BIP-342 (Tapscript)](https://github.com/bitcoin/bips/blob/master/bip-0342.mediawiki). It verifies a signature against a public key and adds the result (0 or 1) to the integer on top of the stack.

This opcode was designed to simplify and optimize multisig scripts in Taproot.

### Operation

1. Pop 3 items from the stack:
    - Signature (top)
    - Public key
    - An integer counter
2. Verify the signature using the public key against the current transaction and script context.
3. If the signature is valid: push counter + 1. If not valid: push counter unchanged
4. Result is a new counter value (as a script number).

### Notes

- Only available in Tapscript (i.e., inside Taproot spends).
- Uses Schnorr signatures (not ECDSA).
- Signature must not include a sighash byte—it is implicit in the script.
- The operation is non-branching and non-failing: even invalid signatures just result in + 0 (not a script failure).
- Enables native `m-of-n` logic without branching or stack juggling.
- The final result can be compared to a threshold using `OP_EQUAL`, `OP_GREATERTHAN`, etc.

## Examples

### Example 1

Valid signature adds 1 to the counter.

```shell
# ASM script
OP_0 <pubkey> <valid_sig> OP_CHECKSIGADD

# After
1  # valid signature = 0 + 1
```


### Example 2

Invalid signature keeps counter the same.

```shell
# ASM script
OP_2 <pubkey> <invalid_sig> OP_CHECKSIGADD

# After
2  # no change
```

### Example 3

Simple 2-of-3 Taproot multisig logic:
- Starts with 0 on the stack
- Each `OP_CHECKSIGADD` adds 1 if signature is valid
- Final value must equal 2 (at least two valid signatures)

```shell
# ASM script
OP_0 <pk1> <sig1> OP_CHECKSIGADD <pk2> <sig2> OP_CHECKSIGADD <pk3> <sig3> OP_CHECKSIGADD OP_2 OP_EQUAL
```
