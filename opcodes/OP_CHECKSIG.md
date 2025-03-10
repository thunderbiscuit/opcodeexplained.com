# OP_CHECKSIG
:::info
**Opcode number:** 172  
**Byte representation:** `0xac`  
**Short Description:** Validates an ECDSA signature against a public key  
:::

The `OP_CHECKSIG` opcode pops two items off the stack: first a public key, then a signature. It verifies whether the provided ECDSA signature corresponds to the public key. If the verification succeeds, it pushes 1 (true) onto the stack; otherwise, it pushes 0 (false).

## Example
```shell
# ASM script
OP_PUSHBYTES_71 # sig
304402204e45e16932b8af514961a1d3a1a25fdf3f4f7732e9d624c6c61548ab5fb8cd410220181522ec8eca07de4860a4acdd12909d831cc56cbbac4622082221a8768d1d0901
OP_PUSHBYTES_65 # pubkey
0411db93e1dcdb8a016b49840f8c53bc1eb68a382e97b1482ecad7b148a6909a5cb2e0eaddfb84ccf9744464f82e160bfa9b8b64f9d4c03f999b8643f656b412a3 
OP_CHECKSIG

# Raw script
47304402204e45e16932b8af514961a1d3a1a25fdf3f4f7732e9d624c6c61548ab5fb8cd410220181522ec8eca07de4860a4acdd12909d831cc56cbbac4622082221a8768d1d0901410411db93e1dcdb8a016b49840f8c53bc1eb68a382e97b1482ecad7b148a6909a5cb2e0eaddfb84ccf9744464f82e160bfa9b8b64f9d4c03f999b8643f656b412a3ac

# Final stack
01
```
