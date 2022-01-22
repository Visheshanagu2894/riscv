// Company           :   tud                      
// Author            :   erdi19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   mem_controller.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   Main unit which decides core access to external or internal blocks            
//
// Create Date       :   Sat Aug  1 17:28:06 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module mem_controller ( 
  
			input [31:0]		pc_addr,    		//PC_next from Branch Unit
			input [31:0]		pc_addr_reg,		//pc_addr from fetcher	
			input 			mem_wr_en,   		//from ctrl
			input 			reg_wr_en,   		//from ctrl
			input 			mem_ctrl_ls, 		//from ctrl
			input [31:0]		ld_st_addr,  		//from alu
			input [31:0]		st_data,     		//from rs2
			//access size decide
			input [2:0] 		func_three,		//from decoder or cntrl
			output  	   	stop_fetch,		//to fetcher, and to demux to send data either to decoder or register file 
			output [1:0]		pram_access_size,	//to PRAM
			output [1:0]		bus_access_size,	//to bus_if
			//pram io's
			input [31:0]		pram_r_data, 		//from program memory
			input 			pram_ld_done,		//from pram to release stopfetch during internal load
			input 			pram_st_done,		//from pram to release stopfetch during internal store
			output  	   	pram_wen,   		//to program memory
			output [15:0] 		pram_addr,		//to program memory
			output [31:0] 		pram_w_data,		//to program memory
			output [31:0]		inst_data,		//to decoder 
			output [31:0]           ld_data,		//to register file
			//bus signals
			input [31:0]		ext_read_data, 		//from bus_if
			input 			bus_ack, 		//from bus_if
			output  		bus_en,			//to bus_if
			output  		bus_wr_en,		//to bus_if
			output  [15:0]		bus_addr,		//to bus_if
			output  [31:0]		bus_wr_data,		//to bus_if
			//from init ctroller
			input   		ld_on_rst,		//PRAM initialization control
			input [15:0]		addr_counter,		//PRAM initialization address to external mem
			input [15:0]    	r_pram_addr,		//PRAM initialization address to PRAM
			input    		wen_regs,		//to execute instructions during external fetch
			output  		f_bus_en,		//fetch state machine
			output 		        ls_bus_en		// to disable PRAM load store
			
			);
	
			wire [15:0]		f_pram_addr;
			wire [15:0]		f_bus_addr;
			wire 			ls_bus_wr_en;
			wire [15:0]		ls_bus_addr;
			wire [31:0]		ls_bus_wr_data;
			wire [1:0]		ls_access_size;
			wire 			ls_pram_wen;
			wire [15:0]		ls_pram_addr;
			wire [31:0]		ls_pram_w_data;
			wire 			ls_stop_fetch;

			
	fetch_mem_ctrller fetch_mem_ctrller_i (
						.pc_addr(pc_addr),    		
						.pc_addr_reg(pc_addr_reg),	
						.pram_r_data(pram_r_data), 		
						.f_pram_addr(f_pram_addr),		
						.f_bus_en(f_bus_en),
						.f_bus_addr(f_bus_addr),
						.inst_data(inst_data)		

						);


	ld_st_mem_ctrller ld_st_mem_ctrller_i(
						.ld_st_addr(ld_st_addr),    			
						.mem_ctrl_ls(mem_ctrl_ls),
						.ls_stop_fetch(ls_stop_fetch),			
						.mem_wr_en(mem_wr_en),   			
						.reg_wr_en(reg_wr_en),   			
						.st_data(st_data),     				
						.func_three(func_three),			
						.ls_access_size(ls_access_size),		
						.pram_r_data(pram_r_data), 			
						.ls_pram_wen(ls_pram_wen),   			
						.ls_pram_addr(ls_pram_addr),			
						.ls_pram_w_data(ls_pram_w_data),		
						.ld_data_o(ld_data),							
						.ext_read_data(ext_read_data), 			
						.bus_ack(bus_ack), 				
						.ls_bus_en(ls_bus_en),
						.ls_bus_wr_en(ls_bus_wr_en),
						.ls_bus_addr(ls_bus_addr),
						.ls_bus_wr_data(ls_bus_wr_data),
						.pram_ld_done(pram_ld_done),
						.pram_st_done(pram_st_done)
						);



		//pram and BUS outputs decision
 		assign pram_w_data	= (ld_on_rst)  ? ext_read_data 	:ls_pram_w_data;
		assign pram_wen   	= (ld_on_rst ) ? 1'b1 		: (!wen_regs && mem_ctrl_ls && !ls_bus_en && !(pram_ld_done || pram_st_done ) ) ? ls_pram_wen  : 1'b0;   		
		assign pram_addr  	= (ld_on_rst)  ? r_pram_addr	: (!wen_regs && mem_ctrl_ls && !ls_bus_en && !(pram_ld_done || pram_st_done ) ) ? ls_pram_addr : f_pram_addr;		
		assign pram_access_size = (ld_on_rst)  ? 2'b10		: !wen_regs && mem_ctrl_ls && !ls_bus_en ? ls_access_size : 2'b10;


		assign bus_wr_data	= ls_bus_wr_data;
		assign bus_en    	= ld_on_rst 	? 1'b1		: (ls_bus_en && !wen_regs  ) ? 1'b1 		: f_bus_en ; 
		assign bus_wr_en 	= (ld_on_rst) 	? 1'b0 		: (ls_bus_en && !wen_regs  ) ? ls_bus_wr_en	: 1'b0;   		
		assign bus_addr  	= (ld_on_rst) 	? addr_counter 	: (ls_bus_en && !wen_regs  ) ? ls_bus_addr	: f_bus_addr;		//to program memory  f_bus_addr
		assign bus_access_size 	= (ld_on_rst) 	? 2'b10		: (ls_bus_en && !wen_regs )  ? ls_access_size 	: 2'b10;



		assign stop_fetch 	= ld_on_rst || (ls_stop_fetch && !wen_regs) ;


	

endmodule



