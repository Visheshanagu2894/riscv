// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   pads.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   pads for the Dobby top unit           
//
// Create Date       :   Sun Oct 18 14:10:29 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module pads (I_CLK,
	     I_A_RESET_L,
	     I_INTR_H,
	     I_BUS_RDY,
	     O_BUS_EN,
	     O_BUS_WEN,
	     O_BUS_SIZE,
	     O_BUS_ADDR,
	     B_BUS_DATA,
	     O_INTR_ACK,
	     clk,
	     a_reset_l,
	     intr_h,
	     bus_ready,
	     bus_en,
	     bus_wen,
	     bus_addr,
	     bus_size,
	     store_data,
	     load_data,
	     intr_ack,
	     VCC,
	     GND,
	     VCC3IO,
	     GNDIO	
);

	input		I_CLK;
	input		I_A_RESET_L;

	//to full core
	output		clk;
	output		a_reset_l;

	input   [1:0]	I_INTR_H;
	input 		I_BUS_RDY;
	//to full core
	output 	[1:0]	intr_h;
	output  	bus_ready;

	//to pads
	input           bus_en;
	input           bus_wen;
	input 	 [1:0]	bus_size;
	input  [15:0]	bus_addr;
	//pad outputs towards external
	output     	O_BUS_EN;
	output  	O_BUS_WEN;
	output  [1:0]  	O_BUS_SIZE;
	output  [15:0]	O_BUS_ADDR;

	//from core-- to pads--from pads to core
	input 	[31:0]	store_data;
	inout   [31:0]	B_BUS_DATA;
	output  [31:0]  load_data;

	//from core to pads --> external 
	input   [1:0]   intr_ack;
	output  [1:0]	O_INTR_ACK;

	inout		VCC;
	inout		GND;
	inout		VCC3IO;
	inout		GNDIO;


	wire zero=1'b0;
	wire one =1'b1;
	//input pads
	XMC clk_pad_i (
	.I(I_CLK),
	.O(clk),
	.SMT(zero),
	.PU(zero),
	.PD(zero)
	);

	XMC a_reset_l_pad_i (
	.I(I_A_RESET_L),
	.O(a_reset_l),
	.SMT(zero),
	.PU(zero),
	.PD(zero)
	);

	XMC bus_rdy_pad_i (
	.I(I_BUS_RDY),
	.O(bus_ready),
	.SMT(zero),
	.PU(zero),
	.PD(zero)
	);

	XMC intr_h_in_pad_i [1:0] (
	.I(I_INTR_H),
	.O(intr_h),
	.SMT(zero),
	.PU(zero),
	.PD(zero)
	);

	//output pads

	YA2GSC bus_en_pad_i (
	.O(O_BUS_EN),
	.I(bus_en),
	.E(one),
	.E2(one),
	.E4(one),
	.E8(zero),
	.SR(one)
	);

	YA2GSC bus_wen_pad_i (
	.O(O_BUS_WEN),
	.I(bus_wen),
	.E(one),
	.E2(one),
	.E4(one),
	.E8(zero),
	.SR(one)
	);

	YA2GSC bus_size_pad_i [1:0] (
	.O(O_BUS_SIZE),
	.I(bus_size),
	.E(one),
	.E2(one),
	.E4(one),
	.E8(zero),
	.SR(one)
	);

	YA2GSC bus_addr_pad_i [15:0] (
	.O(O_BUS_ADDR),
	.I(bus_addr),
	.E(one),
	.E2(one),
	.E4(one),
	.E8(zero),
	.SR(one)
	);

	YA2GSC intr_ack_pad_i [1:0] (
	.O(O_INTR_ACK),
	.I(intr_ack),
	.E(one),
	.E2(one),
	.E4(one),
	.E8(zero),
	.SR(one)
	);

	ZMA2GSC bus_data_pad_i [31:0] (
	.O(load_data),
	.I(store_data),
	.IO(B_BUS_DATA),
	.E(bus_wen),
	.E2(one),
	.E4(one),
	.E8(zero),
	.SR(one),
	.PU(zero),
	.PD(zero),
	.SMT(zero)
	);





	VCCKC VCC_pad_i(
	.VCC(VCC)
	);

	GNDKC GND_pad_i(
	.GND(GND)
	);

	VCC3IOC VCC3IO_pad_i(
	.VCC3IO(VCC3IO)
	);

	GNDIOC GNDIO_pad_i(
	.GNDIO(GNDIO)
	);
	CORNERC NWCORNER_pad_i ();
	CORNERC NECORNER_pad_i ();
	CORNERC SECORNER_pad_i ();
	CORNERC SWCORNER_pad_i ();
endmodule


