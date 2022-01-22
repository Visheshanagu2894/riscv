// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   alu_muldiv.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   <short description>            
//
// Create Date       :   Sun Jun 21 11:38:09 2020 
// Last Change       :   $Date: 2020-12-29 18:10:06 +0100 (Tue, 29 Dec 2020) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module alu_muldiv (rega,
	           regb,
                   alu_opcode,
	           alu_res_muldiv,
                   flag_divbyzero
		  );
	parameter 		N=32;
	input [N-1:0]		rega;
	input [N-1:0]		regb;
	input [4:0]		alu_opcode;

	output  reg [N-1:0]	alu_res_muldiv; //to be declared as reg for top module any output
	output  		flag_divbyzero;



	//calculate the results and assign whats neccessary.
	wire [2*N-1:0]		alu_mulres;
	wire [2*N-1:0]		alu_mul_sign;
	wire [2*N-1:0]		alu_mul_opp;
	

	wire [N-1:0]		alu_div_us;
	wire [N-1:0]		alu_rem_us;
	wire [N-1:0]		alu_div_uns;
	wire [N-1:0]		alu_rem_uns;
	wire [N-1:0] 		oper_a,oper_b;

   	parameter 		MUL    = 5'b01001;
   	parameter 		MULH   = 5'b01010;
    	parameter 		MULHU  = 5'b01011;
    	parameter 		MULHSU = 5'b01100;
    	parameter 		DIV    = 5'b01101;
    	parameter 		DIVU   = 5'b01110;
    	parameter 		REMM   = 5'b01111;
    	parameter 		REMU   = 5'b10000;


	
    	assign alu_mulres   = {{ { N {1'b0}},rega}}  * {{ { N {1'b0}},regb}}   ; //unsigned
	assign alu_mul_sign = {{ N {rega[N-1]}},rega}*{{ { N {regb[N-1]}},regb}};  //signed
	assign alu_mul_opp  = {{ N {rega[N-1]}},rega}*{{ { N {1'b0}},regb}}	; //signed * unsigned
	

	assign oper_a = rega[N-1] ? -rega :rega;
	assign oper_b = regb[N-1] ? -regb :regb;


	assign alu_div_us   = oper_b   == 0 ? {N{1'b1}}: oper_a / oper_b ;
	assign alu_rem_us   = oper_b   == 0   ? rega   :  oper_a % oper_b ;

	
	assign alu_div_uns   = regb   == 0 ? {N{1'b1}}: rega / regb ;
	assign alu_rem_uns   = regb   == 0   ? rega   : rega % regb ;

	

    always @( * )
    begin
	alu_res_muldiv = {N{1'b0}};
        case(alu_opcode)
        	MUL   : alu_res_muldiv = alu_mul_sign[N-1:0] ; //signed
        	MULH  : alu_res_muldiv = alu_mul_sign[2*N-1:N] ; //signed
        	MULHU : alu_res_muldiv = alu_mulres[2*N-1:N] ;  //unsigned
        	MULHSU: alu_res_muldiv = alu_mul_opp[2*N-1:N];
        	DIV   : alu_res_muldiv = (rega[N-1] == regb[N-1])? alu_div_us:-alu_div_us;
		DIVU  : alu_res_muldiv = alu_div_uns;
        	REMM  : alu_res_muldiv = (rega[N-1])?-alu_rem_us:alu_rem_us;
        	REMU  : alu_res_muldiv = alu_rem_uns ;
        endcase
     end

assign flag_divbyzero = ((regb == {N{1'b0}}) && ((alu_opcode== DIV) || (alu_opcode== DIVU) || (alu_opcode== REMM) || (alu_opcode== REMU) ))? 1'b1 : 1'b0 ;

endmodule
