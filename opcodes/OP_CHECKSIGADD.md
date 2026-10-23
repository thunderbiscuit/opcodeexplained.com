# OP_CHECKSIGADD

:::info
**Opcode number:** 186  
**Byte representation:** `0xba`  
**Short description:** Verify a signature and add the result (0 or 1) to a counter on the stack.
:::

`OP_CHECKSIGADD` is a Taproot-era opcode introduced with [BIP-342 (Tapscript)](https://github.com/bitcoin/bips/blob/master/bip-0342.mediawiki). It verifies a signature against a public key and adds the result (0 or 1) to an integer counter popped from the stack.

This opcode was designed to simplify and optimize multisig scripts in Taproot.

### Operation

1. Pop 3 items from the stack:
    - Public key (top)
    - An integer counter (second-to-top)
    - Signature (third-to-top)
2. Verify the signature using the public key against the current transaction and script context. An empty signature is not verified.
3. If the signature is valid: push counter + 1. If the signature is empty: push counter unchanged. If not valid: the script fails.
4. Result is a new counter value (as a script number).

### Notes

- Only available in Tapscript (i.e., inside Taproot spends).
- Uses Schnorr signatures (not ECDSA).
- The signature is 64 bytes (`SIGHASH_DEFAULT`, which signs the whole transaction like `SIGHASH_ALL`) or 65 bytes with a sighash byte appended, which must not be `0x00`.
- The operation is non-branching, but it can fail: an invalid signature fails the whole script. Only an empty signature adds 0 to the counter, which is how a key that did not sign is skipped (see the [BIP-342 rules for signature opcodes](https://github.com/bitcoin/bips/blob/master/bip-0342.mediawiki#rules-for-signature-opcodes)).
- Enables native `m-of-n` logic without branching or stack juggling.
- The final result can be compared to a threshold using `OP_EQUAL`, `OP_GREATERTHAN`, etc.
- More information on this opcode can be found in the [LearnBitcoin glossary entry for the opcode](https://www.learnbitcoin.com/glossary/op-checksigadd).

## Examples

### Example 1

Valid signature adds 1 to the counter.

```shell
# ASM script
<valid_sig> OP_0 <pubkey> OP_CHECKSIGADD

# After
1  # valid signature = 0 + 1
```


### Example 2

Empty signature (an empty byte vector, as pushed by `OP_0`) keeps counter the same. An invalid signature would fail the script instead.

```shell
# ASM script
<empty_sig> OP_2 <pubkey> OP_CHECKSIGADD

# After
2  # no change
```

### Example 3

Simple 2-of-3 Taproot multisig logic:
- Signatures are pushed first (by the witness), last key first; a key that did not sign supplies an empty signature
- Pushes 0 as the starting counter
- Each `OP_CHECKSIGADD` adds 1 if signature is valid
- Final value must equal 2 (at least two valid signatures)

```shell
# ASM script
<sig3> <sig2> <sig1> OP_0 <pk1> OP_CHECKSIGADD <pk2> OP_CHECKSIGADD <pk3> OP_CHECKSIGADD OP_2 OP_EQUAL
```
