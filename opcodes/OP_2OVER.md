# OP_2OVER

:::info
**Opcode number:** 112  
**Byte representation:** `0x70`  
**Short description:** Duplicate the third and fourth items from the top of the stack.
:::

[`OP_2OVER`](./OP_2OVER.md) is used to duplicate the third and fourth items from the stack (i.e., the values two over from the top).

### Operation

1. Duplicate the pair of values two over from the top of the stack, i.e., the third and fourth stack items.
2. Push these duplicates onto the stack in the same order they originally appear.


### Notes

- This opcode is part of a family of opcodes ([`OP_OVER`](./OP_OVER.md), [`OP_2OVER`](#), [`OP_DUP`](#), and a few others) designed for duplication of stack items.
- If there are fewer than four items on the stack when [`OP_2OVER`](./OP_2DUP.md) is executed, the script will fail.

## Examples

### Example 1

Duplicating stack items two over from the top (i.e., the third and fourth stack items) with four total items:

```shell
# ASM script
OP_1 OP_2 OP_3 OP_4 OP_2OVER

# Raw script
5152535470

# Stack (before OP_2OVER)
4
3
2
1

# Stack (after OP_2OVER)
2
1
4
3
2
1
```

### Example 2

Duplicating stack items two over from the top (i.e., the third and fourth stack items) with six total items:

```shell
# ASM script
OP_1 OP_2 OP_3 OP_4 OP_5 OP_6 OP_2OVER

# Raw script
51525354555670

# Stack (before OP_2OVER)
6
5
4
3
2
1

# Stack (after OP_2OVER)
4
3
6
5
4
3
2
1
```
