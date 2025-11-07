# OP_LESSTHANOREQUAL

:::info
**Opcode number:** 161  
**Byte representation:** `0xa1`  
**Short description:** Pop the top two items; push 1 if the second is less than or equal to the top, 0 otherwise.  
:::

`OP_LESSTHANOREQUAL` compares the top two items on the stack as integers. If the second item is less than or equal to the top item, it pushes 1 (true) onto the stack. If not, it pushes an empty array (false). Both items are removed from the stack after the comparison.

### Operation

1.	Take the top item (a) and the second item (b) from the stack.
2.	Compare the two items:
    - If b <= a, push 1 (true) onto the stack.
    - Otherwise, push an empty array (false) onto the stack.
3.	Remove the original items (a and b) from the stack.

### Notes

- Both items must be valid integers. Bitcoin Script interprets byte arrays up to **4 bytes** as integers.
- An empty array (`[]`) is treated as 0 when compared.
- If there are fewer than two items on the stack when `OP_GREATERTHAN` is executed, the script will fail.

## Examples

### Example 1: Second item is less than the top item

```shell
# ASM script
OP_2 OP_3 OP_LESSTHANOREQUAL

# Raw script
5253a2

# Stack (before OP_LESSTHANOREQUAL)
3  # top
2

# Stack (after OP_LESSTHANOREQUAL)
1  # true, as 2 <= 3
```

### Example 2: Second item is equal to the top item

```shell
# ASM script
OP_2 OP_2 OP_LESSTHANOREQUAL

# Raw script
5252a2

# Stack (before OP_LESSTHANOREQUAL)
2  # top
2

# Stack (after OP_LESSTHANOREQUAL)
1  # true, as 2 <= 2
```
