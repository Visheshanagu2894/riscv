// Company           :   tud                      
// Author            :   erdi19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   ld_st_mem_ctrller.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   Load store control unit           
//
// Create Date       :   Sat Aug  1 17:28:06 2020 
// Last Change       :   $Date: 2020-11-21 10:20:51 +0100 (Sat, 21 Nov 2020) $
// by                :   $Author: erdi19 $                  			
//------------------------------------------------------------



module ld_st_mem_ctrller(
			input [31:0]		ld_st_addr,    		//address from alu result
			input 			mem_ctrl_ls,		//control
			output  	   	ls_stop_fetch,		//to stop when bus access
			input 			mem_wr_en,   		//from ctrl
			input 			reg_wr_en,   		//from ctrl
			input [31:0]		st_data,     		//from rs2
			//access size decide
			input [2:0] 		func_three,		//from decoder or cntrl
			output reg [1:0]	ls_access_size,		//to bus and PRAM
			input 			pram_ld_done,		//from pram to release stopfetch during internal load
			input 			pram_st_done,		//from pram to release stopfetch during internal store
			//pram io's
			input [31:0]		pram_r_data, 		//from program memory
			output reg 	   	ls_pram_wen,   		//to program memory
			output reg [15:0] 	ls_pram_addr,		//to program memory
			output reg [31:0] 	ls_pram_w_data,		//to program memory
			output reg[31:0]	ld_data_o,		//to register file
			//bus signals
			input [31:0]		ext_read_data, 		//from bus_if
			input 			bus_ack, 		//from bus_if to release stopfetch during external load or store
			output  		ls_bus_en,		//to bus_if 
			output reg 		ls_bus_wr_en,		//to bus_if 
			output reg [15:0]	ls_bus_addr,		//to bus_if load or store address for external LS
			output reg [31:0]	ls_bus_wr_data		//to bus_if store data	
			);




			localparam 		BYTE       = 3'b000;
			localparam 		HALFWORD   = 3'b001;
			localparam 		WORD       = 3'b010;
			localparam 		BYTE_U     = 3'b100;
			localparam 		HALFWORD_U = 3'b101;
			localparam 		WORD_U     = 3'b110;


			wire [31:0] 		d_read_data;

	assign ls_bus_en= mem_ctrl_ls?(ld_st_addr[14] || ld_st_addr[15] ||ld_st_addr[16]) :1'b0;
	
	always@ ( * )begin

		ls_pram_wen    = 1'b0;   			
		ls_pram_addr   = 16'd0;		
		ls_access_size = 2'b10; 
		ls_pram_w_data = 32'd0;
		ls_bus_wr_en   = 1'b0;
		ls_bus_addr    = 16'd0;
		ls_bus_wr_data = 32'd0;

		if(!ls_bus_en && reg_wr_en && mem_ctrl_ls)begin
	 		ls_pram_addr   = ld_st_addr; 	
		end
		else if(!ls_bus_en && mem_wr_en && mem_ctrl_ls) begin
			ls_pram_addr   = ld_st_addr;
			ls_pram_w_data = st_data;
			ls_pram_wen    = 1'b1;
			case(func_three)
				3'b000  : ls_access_size = 2'b00;
				3'b001  : ls_access_size = 2'b01;
				3'b010  : ls_access_size = 2'b10;
				default : ls_access_size = 2'b10;
			endcase
		end
		else if(ls_bus_en && reg_wr_en && mem_ctrl_ls) begin
			ls_bus_addr   = ld_st_addr;
		end
		else if(ls_bus_en && mem_wr_en && mem_ctrl_ls) begin
			ls_bus_addr   = ld_st_addr;
			ls_bus_wr_data = st_data;
			ls_bus_wr_en    = 1'b1;
			case(func_three)
				3'b000  : ls_access_size = 2'b00;
				3'b001  : ls_access_size = 2'b01;
				3'b010  : ls_access_size = 2'b10;
				default : ls_access_size = 2'b10;
			endcase
		end
	end


	//output decision
	assign d_read_data = ls_bus_en && bus_ack ? ext_read_data : pram_r_data;

	always @( * )
		begin
		ld_data_o=32'd0;
		case(func_three)
			BYTE:begin
				case(ld_st_addr[1:0])
					2'b00:ld_data_o = {{24{d_read_data[7]}},d_read_data[7:0]};    
					2'b01:ld_data_o = {{24{d_read_data[15]}},d_read_data[15:8]};
					2'b10:ld_data_o = {{24{d_read_data[23]}},d_read_data[23:16]};
					2'b11:ld_data_o = {{24{d_read_data[31]}},d_read_data[31:24]};
				endcase
			end
			HALFWORD:begin
				case(ld_st_addr[1:0])
					2'b00:ld_data_o = {{16{d_read_data[15]}},d_read_data[15:0]};
					2'b10:ld_data_o = {{16{d_read_data[31]}},d_read_data[31:16]};
				endcase
			end
			WORD:begin
				ld_data_o = d_read_data;
			end
			BYTE_U:begin
				case(ld_st_addr[1:0])
					2'b00:ld_data_o = {{24{1'b0}},d_read_data[7:0]};    
					2'b01:ld_data_o = {{24{1'b0}},d_read_data[15:8]};
					2'b10:ld_data_o = {{24{1'b0}},d_read_data[23:16]};
					2'b11:ld_data_o = {{24{1'b0}},d_read_data[31:24]};
				endcase
			end
			HALFWORD_U:begin
				case(ld_st_addr[1:0])
					2'b00:ld_data_o = {{16{1'b0}},d_read_data[15:0]};
					2'b10:ld_data_o = {{16{1'b0}},d_read_data[31:16]};
				endcase
			end
			WORD_U:begin
				ld_data_o=d_read_data;
			end
		endcase
	end

	assign ls_stop_fetch = ls_bus_en && !bus_ack ||  (!ls_bus_en && mem_ctrl_ls && !(pram_ld_done || pram_st_done));  

endmodule