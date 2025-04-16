# OP_CHECKLOCKTIMEVERIFY

:::info
**Opcode number:** 177  
**Byte representation:** `0xb1`  
**Short description:** Prevent a transaction input from being spent until a specified absolute time or block height.
:::

`OP_CHECKLOCKTIMEVERIFY` (`CLTV`) allows a script to require that the current transaction's locktime (nLockTime) be greater than or equal to a specified value on the stack. This enables time-based spending conditions, such as "can't be spent until block 700000" or "not before a certain UNIX timestamp."

When `OP_CLTV` is encountered, it does not consume the value on the stack but instead checks whether the transaction's locktime satisfies the condition. If it does not, the script fails.

### Operation

1. Peek at the top stack item (do not remove it).
2. Interpret it as an integer (locktime).
3. Check if the transaction’s nLockTime is greater than or equal to this value.
4. Also check that the transaction’s nLockTime and the stack locktime are of the same type:
    - both block heights (less than 500000000), or
    - both timestamps (≥ 500000000)
5. If all conditions pass, continue execution.
6. If any condition fails, the script fails immediately.

### Notes

- OP_CLTV does not remove the top item from the stack.
- `OP_CHECKLOCKTIMEVERIFY` is implemented by reinterpreting the existing `OP_NOP2` opcode (`0xb1`). Older clients treat this byte as a no-op, while upgraded clients enforce the locktime condition. This made the `CLTV` upgrade a soft fork.
- Requires the transaction's input to set the `nSequence` field below `0xffffffff` to make `nLockTime` active.
- Commonly used for delayed spending, covenants, and vault constructions.

## Example

Simple timelock that prevents spending before block 800000.

```shell
# ASM script
OP_PUSHBYTES_3 00350c OP_CHECKLOCKTIMEVERIFY OP_DROP <pubkey> OP_CHECKSIG

# Raw script (simplified)
03 00350c b1 75 <pubkey> ac

# Transaction nLockTime
800000 or higher -> passes  
Less than 800000 -> fails
```
