# Zeptron - RISC-V CPU

## TO-DO
- Generate Signature File Dump

## Test Utils Module
- Memory mapped at 0x100
- 0x100 address begin signature
- 0x104 address end signature
- 0x108 address if non zero -> dump signature and quit sim


## Memory Model
- 0x0000 - 0x0100 not in Use
- 0x0100 - 0x0112 Test Utils Module
- 0x0112 - 0x0200 not in Use
- 0x0200 - 0xXXXX Code
