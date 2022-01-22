// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   flip_flops.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   <short description>            
//
// Create Date       :   Sun Jan  3 15:45:44 2021 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module flip_flops #(parameter N=32)(
	input		clk,
	input		a_reset_l,
	input 		clear,
	input 		hold,
	input 	[N-1:0]	data_in,
	output	reg [N-1:0]	data_out
);

	wire zero =1'b0;

	always@(posedge clk) begin

		if(clear)begin
			data_out <= {N{zero}};  
		end
		else if(!hold)begin
			data_out <= data_in;
		end 
			

	end

endmodule