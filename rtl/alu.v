// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   alu.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   <short description>            
//
// Create Date       :   Thu May 28 15:12:53 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module alu (rega,
	    regb,
            alu_opcode,
	    alu_res,
            flag_zero,
	    flag_of
	    );

	input [31:0]			rega;
	input [31:0]			regb;
	input [4:0]			alu_opcode;

	output [31:0]			alu_res; 	
	output  			flag_zero;
	output  			flag_of;

	reg [31:0]			alu_res;
	reg 				flag_of;

    	localparam 			ADD  = 5'b00000;
    	localparam 			SUB  = 5'b00001;
    	localparam 			LOR  = 5'b00010;
   	localparam 			LAND = 5'b00011;
    	localparam 			LXOR = 5'b00100;
   	localparam 			LSL  = 5'b00101;
    	localparam 			LSR  = 5'b00110;
    	localparam 			ASR  = 5'b00111;
    	localparam 			SLT  = 5'b01000;

    	//9-16 are for mul and div in other .v file.seperated due to 64 bit and 32 bit problem as we need more initialisations here.
    	localparam 			SLTU = 5'b10001;


	wire  [32:0]        alu_bk_adder,alu_bk_sub;

	wire zero,one;
	// shift left
	wire [31:0] sl_zero  = regb[0] ? { rega[30:0],     1'b0 } : rega    ;
	wire [31:0] sl_one   = regb[1] ? { sl_zero[29:0],  2'b0 } : sl_zero ;
	wire [31:0] sl_two   = regb[2] ? { sl_one[27:0],   4'b0 } : sl_one  ;
	wire [31:0] sl_three = regb[3] ? { sl_two[23:0],   8'b0 } : sl_two  ;
	wire [31:0] sl_four  = regb[4] ? { sl_three[15:0], 16'b0} : sl_three;

	

	wire sr_msb = (alu_opcode == ASR)? rega[31]:1'b0;

	//shift right
	wire [31:0] sr_zero   = regb[0] ? {  {1{sr_msb}},  rega[31:1] }     : rega    ;
	wire [31:0] sr_one    = regb[1] ? {  {2{sr_msb}},  sr_zero[31:2] }  : sr_zero ;
	wire [31:0] sr_two    = regb[2] ? {  {4{sr_msb}},  sr_one[31:4] }   : sr_one  ;
	wire [31:0] sr_three  = regb[3] ? {  {8{sr_msb}},  sr_two[31:8] }   : sr_two  ;
	wire [31:0] sr_four   = regb[4] ? {  {16{sr_msb}}, sr_three[31:16]} : sr_three;	

    	wire set_less = alu_bk_sub[32]? 1'b0: 1'b1;
	wire s_set_less = (!rega[31] && regb[31])? 1'b0 : (rega[31] && !regb[31])? 1'b1: alu_bk_sub[31]? 1'b1:1'b0;


	assign zero= 1'b0;
	assign one =1'b1;

	bk_adder bk_adder_i(.a(rega),.b(regb),.sum(alu_bk_adder),.cin(zero));
	bk_adder bk_sub_i(.a(rega),.b(~regb),.sum(alu_bk_sub),.cin(one));


    	//Combinational block 
    	always @( * )begin
		flag_of=1'b0; 
		alu_res = 32'd0;
        	case(alu_opcode)
        		ADD:	{flag_of,alu_res} = alu_bk_adder          ;    	//addition
        		SUB:	alu_res		  = alu_bk_sub            ;     //subtraction
        		LOR:	alu_res 	  = rega | regb           ; 	//logical OR
        		LAND: 	alu_res 	  = rega & regb           ; 	// logical AND
        		LXOR:   alu_res 	  = rega ^ regb           ; 	//logical XOR
       			LSL:	alu_res 	  = sl_four 	          ; 	// Logical shift left
	     		LSR:    alu_res 	  = sr_four               ;	//logical shift right
                	ASR:    alu_res		  = sr_four               ; 	//Arithmetic shift right		
        		SLTU: 	alu_res           ={ {31{1'b0}}, set_less};	//set less than	
        		SLT:	alu_res           ={ {31{1'b0}}, s_set_less};
        	endcase
    	end

     	assign flag_zero = (alu_res==32'd0) ? 1'b1:1'b0;
 

endmodule


