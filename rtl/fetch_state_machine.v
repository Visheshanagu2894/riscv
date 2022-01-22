// Company           :   tud                      
// Author            :   erdi19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   fetch_state_machine.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   State machine for Bus side Fetch           
//
// Create Date       :   Mon Jan  4 18:46:48 2021 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module fetch_state_machine (input 		f_bus_en,
			    input 		bus_ready,
			    input 		reset_n,
			    input 		clk,
			    
			    input 		stopfetch,
			    output reg 		pc_incr,
			    output reg [1:0] 	current_state,
			    output reg 		wen_regs,
			    output reg 		sw_fetch_internal
			     

);
	parameter INTERNAL_FETCH     	= 2'b00;
	parameter BUS_FETCH_LATCH       = 2'b01;
	parameter BUS_FETCH_DECODE      = 2'b10;

	
	
	reg[1:0]  	nextstate;  

      	
	wire busy =  stopfetch;

	always@( * ) begin
		nextstate = current_state;
		wen_regs = 1'b0;
		pc_incr = 1'b0;
		sw_fetch_internal = 1'b1;
			case(current_state)
				INTERNAL_FETCH :begin 
					 	nextstate 	  =  f_bus_en && !busy? BUS_FETCH_LATCH : INTERNAL_FETCH; 
				      end
				BUS_FETCH_LATCH:begin
						nextstate 	  = !f_bus_en ? INTERNAL_FETCH:  bus_ready ? BUS_FETCH_DECODE : BUS_FETCH_LATCH;
						wen_regs 	  = 1'b1;
						pc_incr 	  = bus_ready ? 1'b1 :1'b0;
						sw_fetch_internal = !f_bus_en ? 1'b1 :1'b0;
					end
			       BUS_FETCH_DECODE:begin
						nextstate 	  = !f_bus_en && !busy? INTERNAL_FETCH: f_bus_en && !busy ? BUS_FETCH_LATCH : BUS_FETCH_DECODE;				
						sw_fetch_internal = !f_bus_en && !busy? 1'b1 :1'b0;
					end
				

			endcase

	end
	
	always@(posedge clk or negedge reset_n ) begin
		if(!reset_n) begin
			current_state <= INTERNAL_FETCH ;
		end
		else  begin
			current_state <= nextstate;
		end
	end


endmodule