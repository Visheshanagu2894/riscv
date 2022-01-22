// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filen_iame          :   sram.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :  External memory for bus access           
//
// Create Date       :   Thu Jul  2 10:17:56 2020 
// Last Change       :   $Date: 2021-03-15 13:05:52 +0100 (Mon, 15 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module sram #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 16
) (
  input  			clk_i,
  input 			i_bus_we,
  input 			i_bus_en,
  input  [ADDR_WIDTH-1:0] 	i_bus_addr,
  input  [1:0]			i_bus_size,	
  inout   [DATA_WIDTH-1:0] 	b_bus_data,
  //bus interface going outside
  output    			o_bus_ready,
  input ready
);

	localparam 	RAM_DEPTH = 16384; //64kB of memory

	reg [DATA_WIDTH-1:0] 	ram [0:RAM_DEPTH-1];

	reg bus_push_data;
	reg [31:0] d_read_data;


	/*read request*/
	
	assign  #1 o_bus_ready =ready; // comb read so slave always ready 

	always @ (posedge clk_i) begin

			if(o_bus_ready &&  i_bus_en && !i_bus_we)begin
				d_read_data <= ram[i_bus_addr[15:2]];
				bus_push_data <= 1'b1;
			end
			else
				bus_push_data <= 1'b0;	
	end

	assign #1 b_bus_data= bus_push_data ? d_read_data : 32'hZZZZZZZZ;




	/*write request*/
	always @(posedge clk_i) begin
		if((i_bus_en==1'b1) && (i_bus_we == 1'b1 )) begin
			if (i_bus_size == 2'd0) begin
				case({i_bus_addr[1],i_bus_addr[0]})
					2'b00 : ram[i_bus_addr[15:2]] [7  :  0] <= b_bus_data[ 7 : 0];
					2'b01 : ram[i_bus_addr[15:2]] [15 :  8] <= b_bus_data[15 : 8];
					2'b10 : ram[i_bus_addr[15:2]] [23 : 16] <= b_bus_data[23 :16];
					2'b11 : ram[i_bus_addr[15:2]] [31 : 24] <= b_bus_data[31 :24];
				endcase
			end
			else if (i_bus_size == 2'd1) begin
				if( ( {i_bus_addr[1],i_bus_addr[0]} ) == 2'd0 ) begin
					ram[i_bus_addr[15:2]] [15  : 0]  <= b_bus_data[15 : 0];
				end
				if( ( {i_bus_addr[1],i_bus_addr[0]} ) == 2'd0 ) begin
					ram[i_bus_addr[15:2]] [31  : 16] <= b_bus_data[31 : 16];
				end
			end
			else if (i_bus_size == 2'd2) begin
				if( ( {i_bus_addr[1],i_bus_addr[0]} ) == 2'd0 ) begin
					ram[i_bus_addr[15:2]] [31  : 0] <= b_bus_data[31 : 0];	
				end
			end
		end
				
	end
 
endmodule
