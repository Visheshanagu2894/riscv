// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   csr_reg_file.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   csr register control           
//
// Create Date       :   Thu Aug 20 19:09:04 2020 
// Last Change       :   $Date: 2020-09-15 08:43:10 +0200 (Tue, 15 Sep 2020) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module csr_reg_file #(parameter XLEN=32)(

		input 			clk,
		input 			rst,
		input [31:0]		pc_off, 		//pc value directly give it
		input [1:0]		interrupt_i,		// from core irq0 and 1
		input [2:0]		csr_opcode,
		input 			csr_en,
		input [1:0]		sys_inst,
		input 			jump,
		input [11:0]		addr, 
		input [XLEN-1:0] 	csr_data_wr,
		input 			stop_fetch,

		output  [XLEN-1:0] 	csr_data_out, // given to control for further processing
		output mie_bit
	
	    );


	// registers used in Privileged mode
	//mepc -exception program counter --written with virtual address of the inst that encounters exception--r/w
	//mstatus-keeps track of operating state --r/w
	//mcause- written with the code that cause the machine mode trap --r/w
	//misa -info about the architecture -read only and constant
	//mtvec- trap vector -sets pc to base when exception --read only here and hardwired to zero. 


	//CSR reg
	reg [XLEN-1:0]		mepc;
	reg [XLEN-1:0]		mstatus;
	reg [XLEN-1:0]		mcause;


	//next state reg
	reg [XLEN-1:0]		mepc_r;
	reg [XLEN-1:0]		mstatus_r;
	reg [XLEN-1:0]		mcause_r;
	reg valid;
	

	parameter MSTATUS_MASK 	= 32'h00001888;		// to use for r/w mstatus 
	parameter MEPC_MASK    	= 32'hFFFFFFFF;		// to use for r/w mepc 
	parameter MCAUSE_MASK   = 32'h8000000F;		// to use for r/w mtrap 
		localparam 	ECALL_MCAUSE   = 31'd11; 
		localparam	EXT_INTRPT     = 31'd11 ;
		localparam 	CSSRW 	       = 3'b001 ;
		localparam 	CSSRS 	       = 3'b010 ;
		localparam 	CSSRC 	       = 3'b011 ;
		localparam 	CSSRWI 	       = 3'b101 ;
		localparam 	CSSRSI 	       = 3'b110 ;
		localparam 	CSSRCI 	       = 3'b111 ; 

		localparam ECALL = 2'b00, MRET = 2'b11;

	//read logic for reading csr registers based on 12 bit address
	reg [XLEN-1:0]read_data;

	assign mie_bit = mstatus[3];
	always @ ( * ) begin 
		read_data = 32'd0;
		if (csr_en) begin 
			case (addr)
			     	12'h300:    					//mstatus
				    read_data = mstatus & MSTATUS_MASK;
				12'h341:    					//mepc
				    read_data = mepc & MEPC_MASK;
				12'h342:    					//mcause
				    read_data = mcause & MCAUSE_MASK ;
				12'h301:    					//misa //MXL(2 bits)--WIRI(4bits)--Extensions(26 bits)
				    read_data = 32'h40001100; 			//misa is just read so always returns constant value so no need of register.This value represents RV32IM support
				12'h305:    					//mtvec
				    read_data = 32'b0; 				//hardwired to zero and mode is zero. this is given to ctrl to set pc to 0000
		    	endcase
		end
		
	end


	//combinational block for csr write
	always @ ( * ) begin 
		mepc_r    = mepc;
		mstatus_r = mstatus;
		mcause_r  = mcause;
		valid     = 1'b0;
		if((interrupt_i[0]||interrupt_i[1]) && mstatus[3] && !stop_fetch && !jump)begin //to decide if mie should be updated if running interrupt

			mepc_r          =  pc_off; // interuppt during normal fetch
			mcause_r        = {1'b1,EXT_INTRPT };
			mstatus_r      = 32'h00001880 & MSTATUS_MASK;
			valid     = 1'b1;
		end
		else if( csr_en && (csr_opcode ==3'd0) )  begin
			
			valid     = 1'b1;
			case(sys_inst)
				ECALL:begin
					mepc_r          = pc_off;
					mcause_r        = {1'b0,ECALL_MCAUSE}; //to be done
				end
			
				MRET: begin
					mstatus_r      =  MSTATUS_MASK;
				end

			
			endcase
		
		end
		else if ( csr_en  && ( (csr_opcode == CSSRW) || (csr_opcode == CSSRWI) ) ) begin  //CSSRW or CSSRWI
		    valid     = 1'b1;
		    case (addr)
			12'h300:    						//mstatus
			    	mstatus_r = csr_data_wr & MSTATUS_MASK;
			12'h341:    						//mepc
			    	mepc_r 	= csr_data_wr & MEPC_MASK;
			12'h342:    						//mcause
			    	mcause_r= csr_data_wr & MCAUSE_MASK ;
		    endcase
		end
		else if ( csr_en  && ( (csr_opcode == CSSRS) || (csr_opcode == CSSRSI) ) ) begin  //CSSRS or CSSRSI
		    valid     = 1'b1;
		    case (addr)
			12'h300:    							//mstatus
			    mstatus_r 	= ( mstatus | csr_data_wr) & MSTATUS_MASK;
			12'h341:    							//mepc
			    mepc_r 	= ( mepc    | csr_data_wr) & MEPC_MASK;
			12'h342:    							//mcause
			    mcause_r 	= ( mcause  | csr_data_wr) & MCAUSE_MASK ;
		    endcase
		end
		else if ( csr_en  && ( (csr_opcode == CSSRC) || (csr_opcode == CSSRCI) ) ) begin //CSSRC or CSSRCI
		    valid     = 1'b1;
		    case (addr)
			12'h300:    							//mstatus
			    mstatus_r 	= ( mstatus & (~csr_data_wr) ) & MSTATUS_MASK;
			12'h341:    							//mepc
			    mepc_r 	= ( mepc    & (~csr_data_wr) ) & MEPC_MASK;
			12'h342:    							//mcause
			    mcause_r 	= ( mcause  & (~csr_data_wr) ) & MCAUSE_MASK ;
		    endcase
		end

	    end


	//for writing to csr registers
	always @ (posedge clk , negedge rst) begin
		if (!rst) begin
		    mepc        <= 32'b0;
		    mstatus     <= MSTATUS_MASK;// MIE bit
		    mcause      <= 32'b0;
		end
		else if(valid)begin
		    mepc        <= mepc_r ;
		    mstatus     <= mstatus_r;
		    mcause      <= mcause_r  ;
		end
	end


assign csr_data_out = read_data;

endmodule