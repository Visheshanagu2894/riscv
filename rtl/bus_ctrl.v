// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   bus_ctrl.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   Bus interface control for both load and fetch access          
//
// Create Date       :   Sun Nov  8 17:27:16 2020 
// Last Change       :   $Date: 2021-03-15 13:05:52 +0100 (Mon, 15 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module bus_ctrl  #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 16
) (
  	  //from pads
	  input  			clk_i,
	  input  			reset_n,
	  //mem controller
          input				ld_on_rst,
	  input 			bus_wen,
	  input 			bus_en,
	  input  [ADDR_WIDTH-1:0] 	bus_address,
	  input  [1:0]			bus_access_size,
	  input [DATA_WIDTH-1:0] 	bus_st_data,
	  input  [DATA_WIDTH-1:0]	i_bus_ld_data,//from pads
	  output  [DATA_WIDTH-1:0]	bus_ld_data,
	  output			bus_ack,
	  //for init controller operation during a_reset
	  output reg [ADDR_WIDTH-1:0]   r_pram_addr,
	  //bus interface going to pads
	  output 			o_bus_we,
	  output 			o_bus_en,
	  output  [ADDR_WIDTH-1:0] 	o_bus_addr,
	  output  [1:0]			o_bus_size,	
	  output  [31:0]		o_bus_st_data,
	  //bus interface going outside
	  input    			i_bus_ready,
	  input 			mem_cntrl_ls,
	  output reg [DATA_WIDTH-1:0] 	bus_inst_data,
	  output  			bus_fetch_ack
  
);


	reg 			r_wen ;
	reg 			r_en ;
	reg[1:0]		r_size;
	reg [ADDR_WIDTH-1:0]    r_addr;
	reg [DATA_WIDTH-1:0]    bus_data;
	
	reg                     bus_push_data;
	reg                     bus_pull_data;

	reg                     bus_pull_data_fetch;


	always @ (posedge clk_i, negedge reset_n) begin
		if(reset_n == 1'b0) begin
			r_wen <= 1'b0;	
			r_en <= 1'b0;	
			r_size <= 2'd0;	
			r_addr <= 16'd0;		
	
		end	
		else begin
			r_pram_addr <= r_addr;
			if((bus_ack || bus_pull_data_fetch) && !ld_on_rst ) begin //&& !ld_on_rst
				r_wen <= 1'b0;	
				r_en <= 1'b0;	
				r_size <= 2'd0;	
				r_addr <= 16'd0;
			end
			else if(i_bus_ready) begin
				r_wen <= bus_wen;	
				r_en <= bus_en;	
				r_size <= bus_access_size;	
				r_addr <= bus_address;
			end
				
		end
	end


	always @ (posedge clk_i, negedge reset_n) begin
		if(reset_n == 1'b0) begin
			bus_data <= 32'd0;
			bus_push_data <= 1'b0;
			bus_pull_data <= 1'b0;
			bus_pull_data_fetch <= 1'b0;
		end	
		else begin
			if((i_bus_ready) && (r_wen) && (r_en) && (!bus_ack) && (mem_cntrl_ls) && (!bus_pull_data_fetch))begin
				bus_data <= bus_st_data;
				bus_push_data <= 1'b1;	
			end
			else begin
				bus_push_data <= 1'b0;	
				
			end
			if ((i_bus_ready) && (!r_wen) && (r_en) && (!bus_ack) && (mem_cntrl_ls ) && (!bus_pull_data_fetch))begin
				bus_pull_data <= 1'b1;
			end
			else begin
				bus_pull_data <= 1'b0;
			end
			if ((i_bus_ready) && (!r_wen) && (r_en) && (!ld_on_rst) && (!mem_cntrl_ls) &&(!bus_fetch_ack))begin
				bus_pull_data_fetch <= 1'b1;
			end
			else  begin
				bus_pull_data_fetch <= 1'b0;
			end
		end
	end

	
	always @ (posedge clk_i, negedge reset_n) begin
		if(reset_n == 1'b0) begin
			bus_inst_data <= 32'd0;
		end	
		else begin
			if(bus_pull_data_fetch)begin
				bus_inst_data <= i_bus_ld_data;
			end
		end
	end



	//ack and bus data towards mem_ctrller

	assign bus_ack = (bus_push_data || bus_pull_data) && i_bus_ready ;
	assign bus_ld_data = i_bus_ld_data ;
	assign bus_fetch_ack = bus_pull_data_fetch && i_bus_ready ;

	assign o_bus_we= r_wen;
	assign o_bus_en= r_en;
	assign o_bus_addr= r_addr;
	assign o_bus_size= r_size;	
	assign o_bus_st_data =bus_data;

endmodule