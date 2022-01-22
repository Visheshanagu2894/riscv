// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   interrupt_ctrl.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   Interrupt control for acknowledgement          
//
// Create Date       :   Sun Nov  8 17:34:01 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module interrupt_ctrl (
			input clk,
			input rst_n,
		        input [1:0]i_intr_h,
		        input mie_bit,
		        output  int_en,
			output reg [1:0]o_int_ack,
			input  stop_fetch,
			input jump
);



	assign int_en = (i_intr_h[0] || i_intr_h[1]) ;

	always@(posedge clk,negedge rst_n) begin

	if(!rst_n)
		o_int_ack <= 2'b00;
	else if(i_intr_h[0] && mie_bit && !stop_fetch && !jump)
		o_int_ack[0] <=1'b1;
	else if (i_intr_h[1] && mie_bit && !stop_fetch && !jump)
		o_int_ack[1] <=1'b1;
	else
		o_int_ack <= 2'b00;	

	end

endmodule