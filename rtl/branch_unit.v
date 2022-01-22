// Company           :   tud                      
// Author            :   erdi19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   branch_unit.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   unit for jump decisions and pc_next address to access from the memory.            
//
// Create Date       :   Tue Dec  1 08:47:13 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module branch_unit (
			input [31:0] 		pc_addr,
			input [2:0] 		branch_opcode,
			input [1:0]		sys_inst,
			input 			csr_en,
			input			jump,
			input 			jmp_valid,
			input [31:0]            imm_o,
			input [31:0]		ra_data,
			input [31:0]		rb_data,
			input [31:0]		csr_data_in,
			
			//interuppt part
			input [1:0]		int_en,
			input 			mie_bit,

			output [31:0] 		pc_next,
			output [31:0]           pc_off
			 
			
); 
	localparam 			BEQ  = 3'b000;
	localparam 			BNE  = 3'b001;
	localparam 			BLT  = 3'b010;
	localparam 			BGE  = 3'b011;
	localparam 			BLTU = 3'b100;
	localparam 			BGEU = 3'b101;
	localparam 			JALR = 3'b110;
	localparam 			JAL  = 3'b111;
	localparam 			OFFSET = 32'd4;
	localparam			ECALL = 2'b00;
	localparam			MRET = 2'b11;

	wire [31:0] jalr_target_w;
	reg  [31:0] pc_next_w;

	wire flag_zero;
	wire slt;
	wire sltu;

	wire  [32:0]    alu_bk_jalr;
	wire  [32:0] 	alu_bk_off;
	wire  [32:0] 	alu_bk_imm;
	wire  [32:0] 	alu_bk_sub ;
	wire zero;
	wire one;
	wire [31:0]pc_imm;

	assign zero =1'b0;
	assign one=1'b1;
	bk_adder bk_jalr_i(.a(imm_o),.b(ra_data),.sum(alu_bk_jalr),.cin(zero));
	bk_adder bk_off_i(.a(pc_addr),.b(OFFSET),.sum(alu_bk_off),.cin(zero));
	bk_adder bk_imm_i(.a(pc_addr),.b(imm_o),.sum(alu_bk_imm),.cin(zero));
	bk_adder bk_sub_i(.a(ra_data),.b(~rb_data),.sum(alu_bk_sub),.cin(one));


	assign flag_zero = ~|(alu_bk_sub[31:0]);

	assign slt= (!ra_data[31] && rb_data[31])? 1'b0 : (ra_data[31] && !rb_data[31])? 1'b1: alu_bk_sub[31]? 1'b1:1'b0;

	assign sltu = alu_bk_sub[32]? 1'b0: 1'b1;

	assign jalr_target_w = alu_bk_jalr;


	assign pc_imm = alu_bk_imm;
	assign pc_off = alu_bk_off;



	//Combinational block to decide branch and jump instructions
	always @ ( * ) begin


		if(int_en[0] && mie_bit && !jmp_valid)
			pc_next_w = 32'd0;
		else if(int_en[1] && mie_bit && !jmp_valid)
			pc_next_w = 32'd4;
		

	       else if (jump && !csr_en && jmp_valid) begin
			
			    	case (branch_opcode)
						BEQ: pc_next_w = (flag_zero == 1'd1)? pc_imm: pc_off;      
						BNE: pc_next_w = (flag_zero == 1'd0)?  pc_imm: pc_off; 
						BLT: pc_next_w = (slt)?  pc_imm: pc_off;  
						BGE: pc_next_w = (!slt)?  pc_imm: pc_off;    
						BLTU: pc_next_w = (sltu)?  pc_imm: pc_off;  
						BGEU: pc_next_w = (!sltu)? pc_imm: pc_off;    
						JALR :  pc_next_w = {jalr_target_w[31:1],1'b0};       
						JAL  :  pc_next_w = pc_imm;  
				endcase
				
		end 
		else if(jump && csr_en && (sys_inst == ECALL) && jmp_valid) begin
			pc_next_w = 32'h10;
		end
		else if(jump && csr_en && (sys_inst == MRET) && jmp_valid) begin
			pc_next_w = csr_data_in;
		end

		else if(jump && !jmp_valid && pc_addr != 32'd4) begin
			pc_next_w = 32'hc;
		end
		else begin
			pc_next_w =  pc_off;
		end
	end

	assign pc_next = pc_next_w;

endmodule
