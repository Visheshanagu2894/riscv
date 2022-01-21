# Dobby_RISCV
A project on design of RISC-V processor from RTL specfication to GDS|| generation. Below is the summary of the core.

## Top level view of the design
![image](https://user-images.githubusercontent.com/44490133/150550253-ed1a7a13-0fb4-4bd7-a99c-8d47656d2ecb.png)

Core Details:

- core implementing the RISC-V ISA (I- Integer extensions, M- Multiplication and division extension)  2 non maskable interrupt inputs 
- 16 kB on-chip PRAM, used as  program memory(also used as DRAM for unused locations). 
- External bus interface with slave memory for extension of the storage.  
- Init-controller for PRAM  initializations (copies the machine code from the external memory to internal memory)
- memory-controller controls access  to PRAM and the external bus interface based on Memory layout.

## Memory Address Mapping information
- Byte Addressable memory used
- Mapping and access decided in Memory controller
- Core address output 32bits -> Upper 15 bits of the address ignored and rest used as shown below
- SRAM macros were used for these (4 blocks of 4kB each)
![image](https://user-images.githubusercontent.com/44490133/150553761-feb06bc3-9035-4371-a908-90207ae05e74.png)

## Service routines

Details of the service routines for interrupts and system calls are shown below
![image](https://user-images.githubusercontent.com/44490133/150553952-4b5719f3-ebe7-40ec-9a6b-dc924b8ce3c0.png)

## Bus interfaces
- Customised Interface
- Bus Data write and read based on Slave ready.
- Data gets latched once cycle later than all signals
- BUS multiplexing possible.
![image](https://user-images.githubusercontent.com/44490133/150555011-fe095de6-25a7-4130-9b1b-f8f769d34fe3.png)


## Summary

The design summary is as shown below. For details on the project please refer the report folder -> ![Report](Report/)
![image](https://user-images.githubusercontent.com/44490133/150555238-69b29385-c32a-40ce-a604-2ccc57eb2c88.png)

![image](https://user-images.githubusercontent.com/44490133/150555831-aa46d2ff-9b18-418a-be24-7accec94fc5c.png)

