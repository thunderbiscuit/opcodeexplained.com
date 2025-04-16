# OP_INVALIDOPCODE

:::info
**Opcode number:** 255  
**Byte representation:** `0xff`  
**Short description:** Fail the script immediately.
:::

`OP_INVALIDOPCODE` fails the script immediately, but it must be executed (for example it does not render a script invalid if it is in a branch of an if/else statement that doesn't get executed).
