// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   init_controller.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   Unit for loading pram from the bus.          
//
// Create Date       :   Sat Aug  1 17:28:41 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module init_controller ( 
			input i_clk,
			input i_a_reset_l,
			input interrupt,
			input i_bus_ready,
			output  reg ld_from_ext,
			output reg [15:0]addr_counter

			);


	parameter IDLE =1'b0;
	parameter COUNTER =1'b1;
	reg state,nextstate;
	reg [15:0]add_counter_nxt;

       
	always@( * ) begin
		nextstate =state;
		add_counter_nxt =addr_counter;
		case(state)

		IDLE:nextstate = (!i_a_reset_l) ? COUNTER : IDLE;

		COUNTER:begin
			nextstate =((addr_counter == 16'h4000)  || interrupt)? IDLE : COUNTER;
				if(i_bus_ready)begin
				add_counter_nxt =addr_counter+16'd4;
				end
			end

		endcase

	end
	
	always@(posedge i_clk or negedge i_a_reset_l ) begin
		if(!i_a_reset_l) begin
			state<=COUNTER;
			addr_counter<= 16'd0;
			ld_from_ext <=  1'b1;
		end
		else  begin
			state<=nextstate;
			addr_counter <= state ==COUNTER ?  add_counter_nxt : 16'd0;
			ld_from_ext <= state ==COUNTER ? 1'b1 :1'b0;

		end
	end

endmodule