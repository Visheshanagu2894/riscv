// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   restore_div.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   <short description>            
//
// Create Date       :   Thu Dec 31 10:19:36 2020 
// Last Change       :   $Date: 2021-01-03 11:36:29 +0100 (Sun, 03 Jan 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module new_div #(parameter N=32)(clk, reset, dividend, divisor, quotient, remainder,start,busy);
	input clk, reset;
	input [N-1:0] dividend, divisor;
	input start;
	output busy;

	output reg [N+1:0] quotient, remainder;
	reg [N+1:0] p, a;
	reg [N+1:0] result_one;
	reg [3:0] count;
	reg  cnt_start;
	integer i ;

	always @(posedge clk, negedge reset)
	begin
		if( !reset )
		begin
			quotient <= {N+2{1'b0}};
			remainder <= {N+2{1'b0}};
			cnt_start<= 1'b0;
		end
		else if(start && !cnt_start) begin
			quotient <= {2'b00,dividend};
			remainder <= {N+2{1'b0}};
			cnt_start<= 1'b1;
		end	
		 else if(!busy)begin
		 cnt_start<= 1'b0;
		 end
		else	
		begin
			quotient <= a;
			remainder <= p;
			
		end
		
	end

	always @(posedge clk, negedge reset)
	begin
		if( !reset )
		begin
			count <= 4'd0;
		end
		else if(cnt_start && busy) begin
			count<=count+4'd1;
		end	
		else	
		begin
			count<=4'd0;
			
		end
		
	end


	assign busy = start && (count < 4'd6);

		
	


always @( * )
	begin
		a = quotient;
		p = remainder;

		for(i = 0; i < 6; i = i+1)
		begin
			//Shift Left carrying a's MSB into p's LSB


			
			p =  {p[N:0],a[N+1]};
			a = {a[N:0],1'b0};

			//store value in case we have to restore
			result_one = p;

			//Subtract
			p = p - {2'b00,divisor};

			if( p[N+1] ) // if p < 0
				p = result_one; //restore value
			else
				a = a | {{(N+1){1'b0}},1'b1};
		end	
	end
	
		
endmodule






















