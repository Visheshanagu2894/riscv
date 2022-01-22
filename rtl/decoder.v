// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   decoder.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   Decoder unit for Instruction decode.(All possibilities decoded here ,control decides what to take)           
//
// Create Date       :   Thu Jul  2 11:33:52 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
/* 
	This module takes the inst which is of 32 bit from the PRAM and decodes it for different fields. There are 6 inst formats for RISC V and all the format have been 
	decoded here.The control logic uses these as inputs and decides the control for the datapath.*/


module decoder (inst,
		rd_sel_a,rd_sel_b,dest_addr,//rs1,rs2,rd
		func_three,func_seven,opcode,//all opcodes
		imm_itype,imm_stype,imm_utype,imm_btype,imm_jtype,shamt
);


	input [31:0]inst;

	//R-Type  (also other types uses some of these)
	output [4:0]		rd_sel_a,rd_sel_b;
	output [4:0] 		dest_addr;
	output [2:0] 		func_three;
	output [6:0]		func_seven;
	output [6:0]		opcode;
	
	 
	
	output [31:0]		imm_itype; //I-Type
	output [31:0]		imm_stype; //S-type
	output [31:0]		imm_utype; //U-Type
	output [31:0]		imm_btype; //B-type
	output [31:0]		imm_jtype; //J-type
	output [31:0]		shamt;     //Shift amount

	

	// Read registers
	assign rd_sel_a   =  inst[19:15];//rs1
	assign rd_sel_b   = inst[24:20]; //rs2

	//inst decoding
	assign opcode     = inst[6:0]; 
	assign func_seven = inst[31:25];
	assign func_three = inst[14:12];
	
	// Write register
	assign dest_addr = inst[11:7];//rd


	//immediate calculations 
	assign imm_itype = { {20{inst[31]}},inst[31:20]}; //sign extend upper 20-bits
	assign imm_stype = { {20{inst[31]}},inst[31:25],inst[11:7]};
	assign imm_utype = {inst[31:12],{12{1'b0}}};
	assign imm_btype= { {19{inst[31]}},inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
	assign imm_jtype= { {11{inst[31]}},inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
	assign shamt     = {{27{1'b0}}, inst[24:20]};


endmodule