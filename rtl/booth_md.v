// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   booth_md.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   <short description>            
//
// Create Date       :   Fri Dec 25 18:32:03 2020 
// Last Change       :   $Date: 2021-01-17 18:05:10 +0100 (Sun, 17 Jan 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module booth_md (  rega,
		   regb,
		   alu_opcode,
		   alu_res_muldiv,
		   flag_divbyzero,
		   clk,
		   reset,
		   busy,
		   wen_regs
		  );
	parameter 		N=32;

	input [N-1:0]		rega;
	input [N-1:0]		regb;
	input [4:0]		alu_opcode;
	input			clk;
	input 			reset;
	input 			wen_regs;
	output			busy;

	output  reg [N-1:0]	alu_res_muldiv; 
	output  		flag_divbyzero;

	wire [ 2*(N+2)-1 : 0 ] 	alu_res_boomul;
	reg  [ N+1 : 0 ] 		regam;
	reg  [ N+1 : 0 ] 		regbm;

	wire [ N+3: 0 ] 		alu_res_booquo;
	wire [ N+3 : 0 ] 		alu_res_boorem;
	wire [N-1:0] 		oper_a,oper_b;
	wire 			ignore;

	reg 			mul_start;
	reg 			div_start;
	wire 			mul_busy;
	wire 			div_busy;

   	parameter 		MUL    = 5'b01001;
   	parameter 		MULH   = 5'b01010;
    	parameter 		MULHU  = 5'b01011;
    	parameter 		MULHSU = 5'b01100;
    	parameter 		DIV    = 5'b01101;
    	parameter 		DIVU   = 5'b01110;
    	parameter 		REMM   = 5'b01111;
    	parameter 		REMU   = 5'b10000;

	assign oper_a = rega[N-1] ? -rega :rega;
	assign oper_b = regb[N-1] ? -regb :regb;
	assign ignore = ~|(rega) || ~|(regb);

    always @( * )
    begin

	alu_res_muldiv = {N{1'b0}};
	regam=34'd0;
	regbm=34'd0;
	div_start=1'b0;
	mul_start=1'b0;


        case(alu_opcode)
        	MUL   : begin
			regam = {rega[N-1],rega[N-1],rega};
			regbm = {regb[N-1],regb[N-1],regb};
			mul_start=!ignore ;//1'b1;
			alu_res_muldiv = ignore ? {N{1'b0}}:alu_res_boomul[N-1:0] ; //signed

			end
        	MULH  : begin
			regam = {rega[N-1],rega[N-1],rega};
			regbm = {regb[N-1],regb[N-1],regb};
			mul_start=!ignore ;//1'b1;
			alu_res_muldiv = ignore ? {N{1'b0}}:alu_res_boomul[2*N-1:N] ; //signed

			end

        	MULHU : begin
			regam = {1'b0,1'b0,rega};
			regbm = {1'b0,1'b0,regb};
			mul_start=!ignore ;//1'b1;
			alu_res_muldiv = ignore? {N{1'b0}}:alu_res_boomul[2*N-1:N] ;  //unsigned
			end 
        	MULHSU: begin
			regam = {rega[N-1],rega[N-1],rega};
			regbm = {1'b0,1'b0,regb};
			mul_start=!ignore ;//1'b1;
			alu_res_muldiv = ignore ? {N{1'b0}}:alu_res_boomul[2*N-1:N];
			end 

	       	DIV   : begin
			regam = {2'b00,oper_a};
			regbm = {2'b00,oper_b};
			div_start=!ignore ;//1'b1;
			alu_res_muldiv =(rega == {N{1'b0}}) ? {N{1'b0}}: flag_divbyzero ? {N{1'b1}} : (rega[N-1] == regb[N-1])? alu_res_booquo:-alu_res_booquo;
			end 
		DIVU  : begin
			regam = {2'b00,rega};
			regbm = {2'b00,regb};	
			div_start=!ignore ;//1'b1;
			alu_res_muldiv = (rega == {N{1'b0}}) ? {N{1'b0}}:flag_divbyzero ? {N{1'b1}} :alu_res_booquo;
			end 
        	REMM  : begin
			regam = {2'b00,oper_a};
			regbm = {2'b00,oper_b};	
			div_start=!ignore ;//1'b1;
			alu_res_muldiv = (rega == {N{1'b0}}) ? {N{1'b0}}:flag_divbyzero ? rega:(rega[N-1])?-alu_res_boorem:alu_res_boorem;
			end 
        	REMU  : begin
			regam = {2'b00,rega};
			regbm = {2'b00,regb};
			div_start=!ignore ;//1'b1;
			alu_res_muldiv = (rega == {N{1'b0}}) ? {N{1'b0}}: flag_divbyzero ? rega:alu_res_boorem ;
			end 

        endcase
     end

	assign flag_divbyzero = ((regb == {N{1'b0}}) && ((alu_opcode== DIV) || (alu_opcode== DIVU) || (alu_opcode== REMM) || (alu_opcode== REMU)))? 1'b1 : 1'b0 ;


	wire mul_start_final=mul_start && !wen_regs;
	wire div_start_final=div_start && !wen_regs;

	new_mul #(.N(N+2)) new_mul_i (.mc(regam), .mp(regbm), .prod(alu_res_boomul));
	new_div #(.N(N+2))new_div_i(.clk(clk), .reset(reset), .dividend(regam), .divisor(regbm), .quotient(alu_res_booquo), .remainder(alu_res_boorem),.start(div_start_final),.busy(div_busy));


	assign busy =( div_busy)&& (!wen_regs);//mul_busy ||

endmodule

