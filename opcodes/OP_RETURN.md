# OP_RETURN
:::info
**Opcode number:** 106  
**Byte representation:** `0x6a`  
**Short description:** Fail the script immediatly (must be executed).
:::

[`OP_RETURN`](./OP_RETURN.md) is an opcode in bitcoin's scripting system that allows for the inclusion of a small amount of arbitrary data in a transaction. This opcode immediately marks the transaction output as unspendable, ensuring that the output can't be used as an input in a subsequent transaction. It's primarily used to embed arbitrary data in the blockchain.

### Operation
1. Terminate the script execution unsuccessfully. Any transaction output with this opcode is not spendable, but the data after [`OP_RETURN`](./OP_RETURN.md) remains permanently on the blockchain. It's a way of declaring that the output can't be spent, and it's only here for the data.

## Notes
- [`OP_RETURN`](./OP_RETURN.md) is commonly followed by a pushdata operation that determines the length of the data to be embedded, and then the data itself.
- The maximum size of the data push is limited to the block weight limit in case the transaction weight limit standarness rule of 400000 WU is bypassed.
- [`OP_RETURN`](./OP_RETURN.md) outputs are used for various purposes, from proving the existence of a particular piece of data at a certain point in time to more complex protocols built on top of bitcoin.
- Historically, there were debates around the use of [`OP_RETURN`](./OP_RETURN.md) because embedding data into the bitcoin blockchain adds to its size without directly supporting the transfer of bitcoin.

## Examples
### Example 1
Embedding the string "HELLO" into the blockchain:
```shell
# ASM script
OP_RETURN OP_PUSHBYTES_5 48454c4c4f

# Raw script
6a0548454c4c4f

# Script result
Output is unspendable and contains the data "HELLO".
```
