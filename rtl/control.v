// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   control.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   main control for all units          
//
// Create Date       :   Thu Jul  2 17:20:30 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps

module control (opcode,
		func_three,
		func_seven,
		imm_itype,
		imm_stype,
		imm_utype,
		imm_btype,
		imm_jtype,
		shamt,
		alu_opcode,
		imm_o,
		res_sel,
		reg_wr_en,
		alu_opb_sel,
		alu_opa_sel,
		jump,
		jmp_valid,
		branch_opcode,
		mem_to_reg,
		mem_wen,
		mem_ctrl_ls,
		csr_en,
		csr_opcode,
		csr_data_sel,
		sys_inst,
		halt_pc,
		csr_addr,
		int_en,
		ld_on_rst
		);

	input [2:0] 			func_three;
	input [6:0]			func_seven;
	input [6:0]			opcode;
		
	input [31:0]			imm_itype;			//I-Type
	input [31:0]			imm_stype;			//S-type
	input [31:0]			imm_utype; 			//U-Type
	input [31:0]			imm_btype; 			//B-type
	input [31:0]			imm_jtype;			//J-type
	input [31:0]			shamt;				//Shift amount
	input 				int_en;
	input				ld_on_rst;

	//Additional wires for control
	output 	reg [4:0]		alu_opcode; 			// ALU control
	output 	reg [2:0]		branch_opcode; 			
	output [31:0]			imm_o;  			//select immediate based on opcode and instruction type
	output reg [1:0]		res_sel;  			//to select between ALU and ALU_MULDIV outputs and immediate values
	output reg 			reg_wr_en; 			//to enable the reg file for writing the result.
	output reg [1:0]		alu_opb_sel; 			// 00=regfile data,01=immediate, 10= 32'd4 ,11=xx
	output reg 			alu_opa_sel; 			//to decide PC or regfile data for alu
	output reg 			jump; 
	output reg 			jmp_valid;                          //to decide on jump 
	output reg 			mem_to_reg;                     // result from ALU or DMEM to write to regfile (mux select line)
	output reg 			mem_wen;                        // DMEM(sram/ pram in our case for store instructions)
	output reg                      mem_ctrl_ls;
	
	//CSR control 
	output reg [2:0]		csr_opcode;			//ECALL and CSSRW,CSSRS,CSSRC,CSSRWI..
	output reg 			csr_data_sel;			// to select between data from register file or immidiate
	output reg 			csr_en;	
	output reg [1:0]		sys_inst;			// to activate CSR
	output reg			halt_pc;
	output reg [11:0]		csr_addr;
	//for wfi inst


	parameter [6:0]	R_TYPE        = 7'b0110011,
                	I_TYPE        = 7'b0010011,
               	 	STORE         = 7'b0100011,
                	LOAD          = 7'b0000011,
                	BRANCH_TYPE   = 7'b1100011,
                	JALR          = 7'b1100111,
                	JAL           = 7'b1101111,
                	AUIPC         = 7'b0010111,
                	LUI           = 7'b0110111,
			SYSTEM_OP     = 7'b1110011;

	localparam ECALL = 2'b00, WFI = 2'b10, MRET = 2'b11;

	//Immediate value selected based on inst type
	assign imm_o =  ((opcode == I_TYPE) && ( (func_three == 3'b001) || (func_three == 3'b101) ) ) ? shamt:  		//SLLI or SRLI or SRAI
		 	((opcode == I_TYPE) || (opcode == JALR) || (opcode == LOAD) || (opcode == SYSTEM_OP ))? imm_itype:  	//other I-type inst , JALR inst,LOAD inst, FENCE inst, CSR priv
		 	(opcode == JAL)? imm_jtype:         									//J-type , JAL inst only           
		 	(opcode == BRANCH_TYPE)? imm_btype:      								//B-Type inst
		 	(opcode == STORE)? imm_stype:       									//S-Type inst
		 	( (opcode == LUI) || (opcode == AUIPC) )? imm_utype:  							//Auipc and LUI inst
		 	32'd0;  


	//signal calculations for most wires 
  	always @( * ) begin 
		reg_wr_en      = 1'b0;
		res_sel        = 2'b00; 				
		alu_opb_sel    = 2'b00; 				
		alu_opa_sel    = 1'b0;
		alu_opcode     = 5'b00000;
		branch_opcode  = 3'b000;
		mem_to_reg     = 1'b0; 
		mem_wen	       = 1'b0;
		mem_ctrl_ls    = 1'b0;
		csr_addr       = 12'h0;
		csr_data_sel   = 1'b0;
		csr_en         = 1'b0;
		csr_opcode     = 3'd0;
		sys_inst       = 2'd0;	
		halt_pc        = 1'b0;	


		if(ld_on_rst) begin

			reg_wr_en      = 1'b0;
			res_sel        = 2'b00; 				
			alu_opb_sel    = 2'b00; 				
			alu_opa_sel    = 1'b0;
			alu_opcode     = 5'b00000;
			branch_opcode  = 3'b000;
			mem_to_reg     = 1'b0; 
			mem_wen	       = 1'b0;
			mem_ctrl_ls    = 1'b0;
			csr_addr       = 12'h0;
			csr_data_sel   = 1'b0;
			csr_en         = 1'b0;
			csr_opcode     = 3'd0;
			sys_inst       = 2'd0;	
			halt_pc        = 1'b0;	
			jump       = 1'b1;
			jmp_valid  = 1'b0;

		end
		else   begin

		
	    		case (opcode) 
		   		R_TYPE: begin
				  	jump        = 1'b0;
					jmp_valid   = 1'b0;
					reg_wr_en   = 1'b1;				
					if (func_seven == 7'b0000001) begin
						res_sel=2'b01;
						case(func_three)
							3'b000:alu_opcode = 5'b01001; //mul
							3'b001:alu_opcode = 5'b01010; //mulh
							3'b010:alu_opcode = 5'b01100; //mulhsu
							3'b011:alu_opcode = 5'b01011; //mulhu
							3'b100:alu_opcode = 5'b01101; //div
							3'b101:alu_opcode = 5'b01110; //divu
							3'b110:alu_opcode = 5'b01111; //rem
							3'b111:alu_opcode = 5'b10000; //remu
						endcase
					end
					else begin
				 		res_sel=2'b00;
						case(func_three)
							3'b000:begin
						 	 	if (func_seven == 7'b0000000) begin 
							   			alu_opcode = 5'b00000; 		//add
									end 
								else if (func_seven == 7'b0100000)begin 
							   			alu_opcode = 5'b00001; 		//sub
							 		end 
								end
							3'b001:	alu_opcode = 5'b00101;		//LSL
							3'b010:	alu_opcode = 5'b01000;		//SLT
							3'b011:	alu_opcode = 5'b10001;		//SLTU	
							3'b100:	alu_opcode = 5'b00100;		//XOR	
							3'b101:begin
						 	 	if (func_seven == 7'b0000000) begin 
							   		alu_opcode = 5'b00110; 		//SRL
							 		end 
								else if (func_seven == 7'b0100000)begin 
							  		 alu_opcode = 5'b00111; 	//SRA
								 	end 
								end
							3'b110:	alu_opcode = 5'b00010;			//OR
							3'b111:	alu_opcode = 5'b00011;			//AND
						endcase
					end
				end
		   		I_TYPE: begin 
					 jump        = 1'b0;
					 jmp_valid   = 1'b0;
					 reg_wr_en   = 1'b1;
					 alu_opb_sel = 2'b01; 					//to select immediate data
					case(func_three)
						3'b000:	alu_opcode = 5'b00000; 			//add
						3'b001:	alu_opcode = 5'b00101;			//LSL
						3'b010:	alu_opcode = 5'b01000;			//SLT
						3'b011:	alu_opcode = 5'b10001;			//SLTU
						3'b100:	alu_opcode = 5'b00100;			//XOR
					
						3'b101:begin
						 	 if (func_seven == 7'b0000000) begin 
							   alu_opcode = 5'b00110; 		//SRL
							 end else begin 
							   alu_opcode = 5'b00111; 		//SRA
							 end 
						end
						3'b110:alu_opcode = 5'b00010;			//OR
						3'b111:alu_opcode = 5'b00011;			//AND
					endcase
				end

				JALR:begin 
				 	//Additional control signals 
					 reg_wr_en    = 1'b1;
					 alu_opb_sel  = 2'b10; 					//to select constant data(32'd4)
					 alu_opa_sel  = 1'b1; 					//to select PC value
					 jump         = 1'b1;
					 jmp_valid    = 1'b1;
					 branch_opcode = 3'b110; 				//For pc address offset	 
				end

				JAL:begin 
					 reg_wr_en   = 1'b1;				
					 alu_opb_sel = 2'b10; 					//to select constant data(32'd4)
					 alu_opa_sel = 1'b1; 					//to select PC value
					 jump        = 1'b1;
					 jmp_valid    = 1'b1;
					 branch_opcode = 3'b111; 				//For pc address offset	 
				end
			
				BRANCH_TYPE:begin //Branch  		
					 jump 	      = 1'b1;
					 jmp_valid    = 1'b1;
					 if (func_three == 3'b000) begin 
					    	branch_opcode = 3'b000; 			//beq
					 end 
					 else if (func_three == 3'b001) begin 
					    	branch_opcode = 3'b001; 			//bne
					 end 
					 else if (func_three == 3'b100) begin 
					
						branch_opcode = 3'b010; 			//blt
					 end 
					 else if (func_three == 3'b101) begin
					
						branch_opcode = 3'b011; 			//bge
					 end 	
					 else if (func_three == 3'b110) begin 
					
						branch_opcode = 3'b100; 			//bltu
					 end 
					 else if (func_three == 3'b111) begin 
						branch_opcode = 3'b101; 			//bgeu
					 end 
				end
		
	      			LOAD: begin //Load 
					 reg_wr_en   = 1'b1;				
					 alu_opb_sel = 2'b01; 				
					 mem_to_reg  = 1'b1;
					 mem_ctrl_ls = 1'b1;
					 jump        = 1'b0;
					 jmp_valid   = 1'b0;
					 
				end 
			      	STORE: begin 				
					 alu_opb_sel = 2'b01; 				
					 mem_wen     = 1'b1; 
					 mem_ctrl_ls = 1'b1;
					 jump        = 1'b0;
					 jmp_valid   = 1'b0;
				     end 
				LUI: begin //LUI 
					 reg_wr_en   = 1'b1;
					 res_sel     = 2'b10;
					 jump        = 1'b0; 
					 jmp_valid   = 1'b0;				
				end
				 
				AUIPC: begin //AUIPC 
					 reg_wr_en   = 1'b1;
					 alu_opb_sel = 2'b01; 				//to select immediate data
					 alu_opa_sel = 1'b1;
					 jump        = 1'b0;	
					 jmp_valid   = 1'b0;			 	//select pc
				end
				SYSTEM_OP: begin
					csr_en      = 1'b1;
					res_sel     = 2'b11;
					jump        = 1'b0;
					jmp_valid   = 1'b0;
					csr_addr    = imm_itype[11:0];
					case(func_three)
						3'b000: begin 
								csr_opcode   =  3'd0; 	//ECALL or EBreak
								res_sel      =  2'b00;
								case(imm_itype[11:0])
									12'h0:	begin 
									   	   sys_inst     =	ECALL;	
										   jump         =       1'b1; 
										   jmp_valid    =       1'b1;
										   csr_addr     =     12'h341;
										end
									12'h105	:begin    
										   sys_inst     = WFI;
										   halt_pc      = 1'b1;	
										   if(int_en)
											halt_pc = 1'b0;
										end
									12'h302	:begin    
										   sys_inst   =	MRET;	
										   jump       = 1'b1; 
										   jmp_valid  = 1'b1;
										   csr_addr   = 12'h341;
										end
								endcase
							end
						3'b001:begin 
								csr_opcode  = 3'd1;
								csr_data_sel= 1'b0;
								reg_wr_en   = 1'b1; 	     	//CSRRW	
							end
						3'b010:	begin 
								csr_opcode  = 3'd2;	     	//CSRRS		
								csr_data_sel= 1'b0;
								reg_wr_en   = 1'b1;
							end
						3'b011:	begin 
								csr_opcode  = 3'd3;	     		
								csr_data_sel= 1'b0;		//CSRRC
								reg_wr_en   = 1'b1;
							end 	    	
						3'b101:	begin 
								csr_opcode  = 3'd5;	     		
								csr_data_sel= 1'b1;		//CSRRWI
								reg_wr_en   = 1'b1;
							end						
						3'b110:	begin 
								csr_opcode  = 3'd6;	     		
								csr_data_sel= 1'b1;		//CSRRSI
								reg_wr_en   = 1'b1;
							end					
						3'b111: begin 
								csr_opcode  = 3'd7;	     	//CSRRCI	
								csr_data_sel= 1'b1;
								reg_wr_en   = 1'b1;
							end					
					endcase
				end
				default: begin
					jump       = 1'b1;
					jmp_valid  = 1'b0;
				end
			
		endcase
	end
end

endmodule



