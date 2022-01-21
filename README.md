# Dobby_RISCV
A project on design of RISC-V processor from RTL specfication to GDS|| generation.

## Top level view of the design
![image](https://user-images.githubusercontent.com/44490133/150550253-ed1a7a13-0fb4-4bd7-a99c-8d47656d2ecb.png)

Core Details:

- core implementing the RISC-V ISA (I- Integer extensions, M- Multiplication and division extension)  2 non maskable interrupt inputs 
- 16 kB on-chip PRAM, used as  program memory(also used as DRAM for unused locations). 
- External bus interface with slave memory for extension of the storage.  
- Init-controller for PRAM  initializations (copies the machine code from the external memory to internal memory)
- memory-controller controls access  to PRAM and the external bus interface based on Memory layout.

