# OP_CODESEPARATOR

:::info
**Opcode number:** 171  
**Byte representation:** `0xab`  
**Short description:** Ignore this and everything preceding when deciding what to sign when signature-checking.
:::

`OP_CODESEPARATOR` is a marker opcode used to alter how a script is serialized during the process of signature verification. It doesn’t affect the stack directly but changes the portion of the script that is considered when computing the signature hash (sighash) for `OP_CHECKSIG`.

### Operation

1. Does not modify the stack.
2. Internally, records the position in the script that follows this opcode.
3. During signature checking (`OP_CHECKSIG`/`OP_CHECKMULTISIG`), only the portion of the script after the last `OP_CODESEPARATOR` is used in the signature hash.

### Notes

- In practice, OP_CODESEPARATOR is rarely used in modern Bitcoin scripts.
- When a script contains multiple OP_CODESEPARATORs, the most recent one prior to OP_CHECKSIG determines the start point of the script portion used in the hash.
- More information on this opcode can be found on the [Bitcoin Optech topic for the opcode](https://bitcoinops.org/en/topics/op_codeseparator/).

## Example

Using `OP_CODESEPARATOR` to isolate a portion of the script:

```shell
# ASM script
<signature> OP_CODESEPARATOR <public key> OP_CHECKSIG
```

In legacy bitcoin Script, such as the above example, `OP_CODESEPARATOR` removes itself and any preceding parts of a script from the scriptCode—which is part of the data that is hashed to create the message that is signed by a signature in bitcoin. The above code separator allows the signature to only commit to the `<pubkey> OP_CHECKSIG` part of the script.
