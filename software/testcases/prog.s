/* remove to allow compressed instructions */
.option norvc

/* irqs */
.org 0x0
    jal x0, default_handler
.org 0x4
    jal x0, default_handler

/* reset */
.org 0x8
    jal x0, _START

/* illegal instruction */
.org 0xc
    jal x0, illegal_handler

/* ecall */
.org 0x10
    jal x0, default_handler
    MRET




default_handler:
    /* infinite loop */
    MRET
    jal x0, default_handler


illegal_handler:
    /* infinite loop */
    nop
    jal x0, illegal_handler

#addi to all registers to initialize the values
_START:	addi x0,x0,5 #corner check shouldn't write
	#all registers add 1
	addi x1,x0,1
	addi x2,x0,1
	addi x3,x0,1
	addi x4,x0,1
	addi x5,x0,1
	addi x6,x0,1
	addi x7,x0,1
	addi x8,x0,1
	addi x9,x0,1
	addi x10,x0,1
	addi x11,x0,1
	addi x12,x0,1
	addi x13,x0,1
	addi x14,x0,1
	addi x15,x0,1
	addi x16,x0,1
	addi x17,x0,1
	addi x18,x0,1
	addi x19,x0,1
	addi x20,x0,1
	addi x21,x0,1
	addi x22,x0,1
	addi x23,x0,1
	addi x24,x0,1
	addi x25,x0,1
	addi x26,x0,1
	addi x27,x0,1
	addi x28,x0,1
	addi x29,x0,1
	addi x30,x0,1
	addi x31,x0,1
	slli  x31,x31,14

	#load values to registers from bus
	lb x1, 10(x31)
	lb x2, 10(x31)
	lb x3, 10(x31)
	lb x4, 10(x31)
	lh x5, 10(x31)
	lh x6, 10(x31)
	lh x7, 10(x31)
	lh x8, 10(x31)

	lhu x9, 10(x31)
	lhu x10, 10(x31)
	lhu x11, 10(x31)
	lhu x12, 10(x31)
	lbu x13, 10(x31)
	lbu x15, 10(x31)
	lbu x16, 10(x31)


	lw x17, 10(x31)
	lw x18, 10(x31)
	lw x19, 10(x31)
	lw x20, 10(x31)

	#pram side load
	lb x17, 10(x1)
	lb x18, 10(x1)
	lh x19, 10(x1)
	lh x20, 10(x1)
	lhu x17, 10(x1)
	lhu x18, 10(x1)
	lbu x19, 10(x1)
	lbu x20, 10(x1)
	lw x17, 10(x1)
	lw x18, 10(x1)

	#immediate instructions
	lui x5, 0x11000
	auipc x4, 0x00110

	#pseudo instruction
	mv x6, x4
	li x5,100
	neg x6, x5
	seqz x6, x5
	snez x6, x5
	sltz x6, x5
	sgtz x6, x5


	#bitwise instructions

	
	#shift instructions
	li x5, 4  # x5 ←− 2
	li x3, 2  # x3 ←− 2
	sll x1, x5, x3 # x1 ←− x5 << x3
	srl x1, x5, x3
	sra x1, x5, x3
	
	#logical instructions
	li x5, 0x0100 # x5 ←− 0x0100
	li x3, 0x0010 # x3 ←− 0x0010
	or x1, x5, x3 # x1 ←− x5|x3
	xor x1, x5, x3 
	and x1, x5, x3 
	not x6, x5

	#compare instructions
	li x5, 3 # x5 ←− 3
	li x3, 5 # x3 ←− 5
	slt x1, x5, x3 # x1 ←− x5 < x3
	sltu x1, x5, x3
	
	#logical shift immediate
	slli x1, x1, 1

	srli x1, x1, 1
	srai x1, x1, 1


	li x5, 0x0100 # x5 ←− 0x0100
	ori x1, x5, 0x0010 # x1 ←− x5|2
	andi x1, x5, 4	
	xori x1, x5, 0b100000
	slti x1, x1, 2
	sltiu x1, x1, 2




	#Arithmetic instructions
	li x2, 3 # x2 ←− 3
	li x3, 4 # x3 ←− 4
	add x1, x2, x3 # x1 ←− x2 + x3
	sub x1, x2, x3
	mul x1, x9, x13

	li x1,-80 # x1 ←− -80
	li x5,20 # x5 ←− 20
	mul x1, x5, x1
	mulh x1, x5, x1 # x5 ←− High Bits [x5*x1]
	mulhu x1, x5, x1
	mulhsu x1, x5, x1

	li x1,0 # x1 ←− -80
	li x5,20 # x5 ←− 20
	mul x1, x5, x1
	mulh x1, x5, x1 # x5 ←− High Bits [x5*x1]
	mulhu x1, x5, x1
	mulhsu x1, x5, x1

	li x1,-80 # x1 ←− -80
	li x5,-80 # x5 ←− 20
	mul x1, x5, x1
	mulh x1, x5, x1 # x5 ←− High Bits [x5*x1]
	mulhu x1, x5, x1
	mulhsu x1, x5, x1

	li x1,80 # x1 ←− -80
	li x5,20 # x5 ←− 20
	mul x1, x5, x1
	mulh x1, x5, x1 # x5 ←− High Bits [x5*x1]
	mulhu x1, x5, x1
	mulhsu x1, x5, x1

	li x1,80 # x1 ←− -80
	li x5,-20 # x5 ←− 20
	mul x1, x5, x1
	mulh x1, x5, x1 # x5 ←− High Bits [x5*x1]
	mulhu x1, x5, x1
	mulhsu x1, x5, x1



	li x9, -400 # x9 ←− -400
	li x13, 200 # x13 ←− 200
	div x1, x9, x13 # x4 ←− x9/x13
	divu x1, x9, x13
	rem x1, x9, x13 # x4 ←− x9%x13
	remu x1, x9, x13

	li x9, 400 # x9 ←− -400
	li x13, 200 # x13 ←− 200
	div x1, x9, x13 # x4 ←− x9/x13
	divu x1, x9, x13
	rem x1, x9, x13 # x4 ←− x9%x13
	remu x1, x9, x13

	li x9, -400 # x9 ←− -400
	li x13, -200 # x13 ←− 200
	div x1, x9, x13 # x4 ←− x9/x13
	divu x1, x9, x13
	rem x1, x9, x13 # x4 ←− x9%x13
	remu x1, x9, x13

	li x9, 400 # x9 ←− -400
	li x13, -200 # x13 ←− 200
	div x1, x9, x13 # x4 ←− x9/x13
	divu x1, x9, x13
	rem x1, x9, x13 # x4 ←− x9%x13
	remu x1, x9, x13

	li x9, 400 # x9 ←− -400
	li x13, -2000 # x13 ←− 200
	div x1, x9, x13 # x4 ←− x9/x13
	divu x1, x9, x13
	rem x1, x9, x13 # x4 ←− x9%x13
	remu x1, x9, x13

	li x9, 0 # x9 ←− -400
	li x13, -2000 # x13 ←− 200
	div x1, x9, x13 # x4 ←− x9/x13
	divu x1, x9, x13
	rem x1, x9, x13 # x4 ←− x9%x13
	remu x1, x9, x13

	#control transfer Instructions
	li x5, -4
	loop_bne: addi x5, x5, 1 # x5 ←x5 + 1
	bne x5, x0, loop_bne # x5 != x0 jump to loop
	
	li x5, 5
	loop_beq: addi x5, x5, -5 # x5 ←x5 - 5
	beq x5, x0, loop_beq # x5 == x0 jump to loop

	li x4,0
	li x9,100
	label_blt: addi x4, x4, 20 # x4 ←− x4 + 20
	blt x4, x9, label_blt # x4 < x9 jump to label
	
	addi x5, x0, 4 # x5 ←− x0 + 3
	addi x1, x0, 1 
	loop_bltu: addi x1, x1, -1 # x1 ←− x0 + 1
	bltu x1, x5, loop_bltu # x1 < x5 jump to loop


	li x4,200
	li x9,100
	label_bge: addi x4, x4, -20 # x4 ←− x4 + 20
	bge x4, x9, label_bge # x4 > x9 jump to label
	
	addi x5, x0, 1 # x5 ←− x0 + 3
	addi x1, x0, 2 
	loop_bgeu: addi x1, x1, -1 # x1 ←− x0 + 1
	bgeu x1, x5, loop_bgeu # x1 > x5 jump to loop

	li x4,0



	jal x1, loop_jal

	li x4,200

	#CSR Instructions

	csrrc x1, mcause, zero
	csrrc x1, mepc, zero
	csrrci x1, mstatus, 0xA0
	csrrci x1, mcause, 3
	csrrci x1, mepc, 3

	li x1,208
	csrr x5, misa
	csrr x5, mepc
	csrr x5, mstatus # x5 ←− mstatus
	csrr x5, mcause
	csrr x5, mtvec

	csrrw zero, mcause, t0
	csrrw zero, mepc, t0
	csrrw zero, mstatus, t0

	csrrwi zero, mcause, 3
	csrrwi zero, mepc, 3
	csrrwi zero, mstatus, 3
	li x1,0xD8
	csrrs zero, mstatus, x1
	csrrs zero, mcause, x1
	csrrs zero, mepc, x1

	csrrsi zero, mstatus, 3
	csrrsi zero, mepc, 3
	csrrsi zero, mcause, 3	
	

	#store instructions from pram side
	li x5,2000
	li x1,100
	sb x1, 0(x5)
	addi x5,x5,1
	sb x1, 0(x5)
	addi x5,x5,1
	sb x1, 0(x5)
	addi x5,x5,1
	sb x1, 0(x5)

	li x5,2000
	sh x1, 0(x5)
	li x5,2002
	sh x1, 0(x5)

	li x5,2000
	sw x1, 0(x5)


	#store instructions from bus side

	li x5,0x5000
	sb x1, 0(x5)
	sh x1, 0(x5)
	sw x1, 0(x5)




	#mul cases


	li x9 ,100
	li x13 ,10
	#case1
	mul x1, x9, x13
	addi x2,x0,1
	addi x3,x0,1
	addi x4,x0,1

	div  x1, x9, x13
	addi x5,x0,1
	addi x6,x0,1
	addi x7,x0,1
	addi x8,x0,1	
	addi x5,x0,1
	addi x6,x0,1
	addi x7,x0,1
	addi x8,x0,1
	addi x5,x0,1
	addi x6,x0,1
	addi x7,x0,1
	addi x8,x0,1


	#case2 
	
	mul x1, x9, x13
	addi x2,x1,1
	addi x3,x0,1
	addi x4,x1,1

	mul x1, x9, x13
	addi x2,x0,1
	addi x3,x1,1
	addi x4,x1,1

	div  x1, x9, x13
	addi x5,x0,1
	addi x6,x0,1
	addi x7,x0,1
	addi x8,x1,1	
	addi x5,x0,1
	addi x6,x0,1
	addi x7,x0,1
	addi x8,x0,1

	#corner cases
	div x1, x9, x0
	divu x1, x9, x0
	rem x1, x9, x0
	remu x1, x9, x0



	ecall
	wfi

	jal x1, loop_dummy

	#unconditional jump
	
	loop_jal: addi x5, x4, 1 # x5 ←− x4 + 1
		  addi x5, x4, 2 # x5 ←− x4 + 1
		  addi x5, x4, 4 # x5 ←− x4 + 1
		  ret

	 loop_dummy:
			li x5,0x8000
			li x1,0x1000
			jalr x0,0(x5)
	li x1,0x2000
/*
# multiplication_repeated_addition.rvi
#
# Multiplication using repeated addition
# a*b is returned in r5

# r1:a, r2:b, r3: is_neg
# r5: ans
_START:
	addi x3,x0,2047
	addi x10,x0,20
	jal  x11,PUSH
	addi x3, x0, 1
	jal x11,POP
HALT:
	jal x11, HALT

# Increments stack pointer and
# pushes the value in x3 to stack
PUSH:
	addi x10,x10,4
	sw   x10,x3,0
	jalr x0,x11,0
# Pops the value from stack to x3
# and decrements stack pointer
POP:
	lw x4, x10
	addi x10,x10,-4
	jalr x0,x11,0	

SWAP:
	add x3,x0,x1
	add x1,x0,x2
	add x2,x0,x3
	jalr x0,x11,0

*/


