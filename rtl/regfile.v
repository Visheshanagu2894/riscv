// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   regfile.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   32 bit 32 register file            
//
// Create Date       :   Sun Jun 21 15:19:47 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module regfile (clk,
		wen,
		ra_addr,
		rb_addr,
		rdest_addr,
		wdata,
		ra_data,
		rb_data,
		rst_n
		);

		input 			clk;
		input 			wen;
		input [4:0] 		ra_addr;		//rs1
		input [4:0] 		rb_addr;		//rs2
		input [4:0] 		rdest_addr;		//rd
		input [31:0]		 wdata;			//data
		input rst_n;

		output [31:0] 		ra_data;
		output [31:0] 		rb_data;

		reg [31:0] 		rf[31:0];		// three ported register file,2 port read and 1 port for write at clk control.

		integer i;
	
		always @ (posedge clk, negedge rst_n) begin
			if(!rst_n) begin
				for(i=0; i<32; i=i+1) begin
					rf[i]<=32'h0000;
				end
			end
			else if (wen && rdest_addr!=5'd0)  
			rf[rdest_addr] <= wdata;  
		end



		assign ra_data = (ra_addr != 5'd0) ? rf[ra_addr] : 0;
		assign rb_data = (rb_addr !=  5'd0) ? rf[rb_addr] : 0;


endmodule
