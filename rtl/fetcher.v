// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   fetcher.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   <short description>            
//
// Create Date       :   Tue Jun 30 16:59:42 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module fetcher (clk,
		rst,
		inst_addr_o,
		pc_next,
		halt_core,
		f_bus_en,
		pc_incr
	
		);
  	input  			clk;
  	input  			rst;
  	output [31:0] 		inst_addr_o;
	input  [31:0]           pc_next;
 	input 			halt_core;
	input 			pc_incr;
	input 			f_bus_en;
	reg [31:0] 		inst_addr;
	


	always@(posedge clk,negedge rst) begin
		if(!rst)
			inst_addr <= 32'h0004; //Reset handler is at 0x0008,pc_next given to MCntroller so 0x004 set

		else begin
			if(!f_bus_en )begin
				if(!halt_core) 
					inst_addr <= pc_next;
			end
			else if(pc_incr) // for bus side fetch
				inst_addr <= pc_next;
		end
		
	end


	assign inst_addr_o = inst_addr;

endmodule
