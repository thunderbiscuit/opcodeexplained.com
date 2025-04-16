# OP_CHECKSEQUENCEVERIFY

:::info
**Opcode number:** 178  
**Byte representation:** `0xb2`  
**Short description:** Prevent a transaction input from being spent until a relative timelock has passed.
:::

`OP_CHECKSEQUENCEVERIFY` (`CSV`) enforces a relative timelock: it restricts spending of a UTXO until a certain amount of time or blocks have passed since the output being spent was confirmed.

`CSV` was introduced in [BIP-112](https://github.com/bitcoin/bips/blob/master/bip-0112.mediawiki) as a soft fork, reinterpreting the previous `OP_NOP3` opcode.

Unlike `OP_CHECKLOCKTIMEVERIFY`, which uses an absolute locktime (and applies to the whole transaction), `OP_CHECKSEQUENCEVERIFY` applies to individual inputs and is relative.

### Operation

1. Peeks at the top stack item (does not remove it).
2. Interprets it as a script number: the relative locktime.
3. Verifies that:
    - The input’s nSequence field satisfies the relative locktime.
    - The type (block-based or time-based) matches.
    - The transaction has nVersion >= 2.
4. If all conditions pass, script continues.
5. If any check fails, the script fails immediately.

### Notes

- Like `OP_CLTV`, this opcode leaves the value on the stack—use `OP_DROP` after if needed.
- The stack value and the transaction's `nSequence` must use the same locktime type:
- If bit 31 (`0x80000000`) is set, the locktime is disabled, and `OP_CSV` is a no-op.
- If not set, the input enforces a relative locktime:
    - Bit 22 = 0; value is measured in blocks
    - Bit 22 = 1; value is measured in time (512-second units).
- The transaction version must be ≥ `2`, and the input’s `nSequence` must be less than `0xffffffff` to enable `CSV`.

## Examples

### Example 1

Delay spending until 100 blocks after the UTXO is confirmed.

```shell
# ASM script
OP_PUSHBYTES_1 0x64 OP_CHECKSEQUENCEVERIFY OP_DROP <pubkey> OP_CHECKSIG

# Raw script (simplified)
0164b2 75 <pubkey> ac

# Input nSequence
Must be ≥ 100
```

### Example 2

Using CSV with time-based delay (e.g., 1 day):

- 1 day = 86400 seconds → 86400 / 512 = 168 intervals
- Add time-based flag: 0x00400000
- Final value: 0x004000A8

```shell
# ASM script
OP_PUSHBYTES_4 a8004000 OP_CHECKSEQUENCEVERIFY OP_DROP <pubkey> OP_CHECKSIG

# nSequence
Must be ≥ 0x004000a8 and not disabled
```
