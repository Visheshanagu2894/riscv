// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   dobby_top.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   Dobby top with pads and core         
//
// Create Date       :   Sun Oct 18 14:09:07 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module dobby_top (

	 input     I_CLK,
	 input     I_A_RESET_L,
	 input     [1:0]I_INTR_H,
	 input     I_BUS_RDY,
	 output    O_BUS_EN,
	 output    O_BUS_WEN,
	 output    [1:0]O_BUS_SIZE,
	 output    [15:0]O_BUS_ADDR,
	 inout     [31:0]B_BUS_DATA,
	 output    [1:0]O_INTR_ACK,
	inout VCC,
	inout GND,
	inout VCC3IO,
	inout GNDIO
);
	parameter A ="NONE";
	parameter B ="NONE";
	parameter C ="NONE";
	parameter D ="NONE";	

wire [1:0]intr_h;
wire a_reset_l;
wire clk;
wire bus_ready;
wire bus_en;
wire bus_wen;
wire [15:0]bus_addr;
wire [1:0]bus_size;
wire [31:0]store_data;
wire [31:0]load_data;
wire [1:0]intr_ack;

dobby_core #(.A(A),.B(B),.C(C),.D(D)) dobby_core_i(
	     //from pads
	     .clk(clk),
	     .a_reset_l(a_reset_l),
	     .i_intr(intr_h),
	     .i_bus_ready(bus_ready),
	     .i_load_data(load_data),
	     //to pads
	     .o_bus_en(bus_en),
	     .o_bus_wen(bus_wen),
	     .o_bus_addr(bus_addr),
	     .o_bus_size(bus_size),
	     .o_intr_ack(intr_ack),
	     .o_store_data(store_data)
	);


pads pads_i(  .I_CLK(I_CLK),
	     .I_A_RESET_L(I_A_RESET_L),
	     .I_INTR_H(I_INTR_H),
	     .I_BUS_RDY(I_BUS_RDY),
	     .O_BUS_EN(O_BUS_EN),
	     .O_BUS_WEN(O_BUS_WEN),
	     .O_BUS_SIZE(O_BUS_SIZE),
	     .O_BUS_ADDR(O_BUS_ADDR),
	     .B_BUS_DATA(B_BUS_DATA),
	     .O_INTR_ACK(O_INTR_ACK),
	     .clk(clk),
	     .a_reset_l(a_reset_l),
	     .intr_h(intr_h),
	     .bus_ready(bus_ready),
	     .bus_en(bus_en),
	     .bus_wen(bus_wen),
	     .bus_addr(bus_addr),
	     .bus_size(bus_size),
	     .store_data(store_data),
	     .load_data(load_data),
	     .intr_ack(intr_ack),
	     .VCC(VCC),
	     .GND(GND),
	     .VCC3IO(VCC3IO),
	     .GNDIO(GNDIO)	
);




endmodule