// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   csr.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   control status registers unit            
//
// Create Date       :   Thu Aug 20 19:09:04 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module csr #(parameter XLEN=32)(

		input 			clk,
		input			rst,		
		input [1:0]		interrupt_i,	
		input [2:0]		csr_opcode,
		input 			csr_en,
		input  [11:0]		csr_addr,
		input 			csr_data_sel,
		input [1:0]		sys_inst,	
		input 			stop_fetch,
		input [4:0] 		instruction,
		input [31:0] 		rsource_data,
		input [31:0]		pc_off,
		input 			jump,
		output [XLEN-1:0] 	csr_data_out,
		output mie_bit	
	
	    );



	wire [XLEN-1:0] 	csr_data_wr;
	wire [31:0]		csr_read_data;


	assign csr_data_wr = csr_data_sel ? { {27{1'b0}},instruction}:rsource_data;

	csr_reg_file #(.XLEN(XLEN)) csr_reg_file_i(
						.clk(clk),
						.rst(rst),
						.interrupt_i(interrupt_i),
						.csr_opcode(csr_opcode),
						.csr_en(csr_en),
						.addr(csr_addr), 
						.csr_data_wr(csr_data_wr),
						.csr_data_out(csr_read_data),
						.sys_inst(sys_inst),
						.mie_bit(mie_bit),
						.pc_off(pc_off),
						.stop_fetch(stop_fetch),
						.jump(jump)
	    					);

	assign csr_data_out = csr_read_data;


endmodule