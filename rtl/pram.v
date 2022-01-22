// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   pram.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   PRAM module            
//
// Create Date       :   Sat Aug  1 17:14:21 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module pram  (
  		input  			clk,
		input 			rst_n,
  		input        		wen,
  		input  [15:0] 		mem_addr,//done for compatibility
  		input  [31:0] 		w_in,
		input  [1:0]		access_size,
		input 			mem_ctrl_ls,
  		output [31:0] 		pram_data_o,
		output reg		load_done,
		output reg		store_done

);


        //Active low write enable and chipselect
	wire    	cs_zero, cs_one, cs_two, cs_three;
	wire [31:0] 	r_data_zero, r_data_one, r_data_two, r_data_three;
	reg  [3:0]	mask_wen;
	wire [13:0] 	a_i;
	wire [31:0]     w_i; 
	wire w_en;

	wire clk_one;
	wire clk_two;
	wire clk_three;
	reg cs_one_r;
	reg cs_two_r;
	reg cs_three_r;

	parameter INITFILE0 ="none";
	parameter INITFILE1 ="none";	
	parameter INITFILE2 ="none";
	parameter INITFILE3 ="none";

	always@(posedge clk , negedge rst_n) begin
		if(!rst_n) begin
			load_done<=1'b0;
			store_done <=1'b0;
		end
		else if(!wen && mem_ctrl_ls&& !load_done) begin
			load_done<=1'b1;
			store_done <=1'b0;
		end
		else if (wen&& mem_ctrl_ls&& !store_done) begin
			store_done <=1'b1;
			load_done<=1'b0;
		end
		else	begin
			load_done<=1'b0;
			store_done <=1'b0;
		end
				
	end
	

	assign #1 cs_three = ( (a_i[13]==1'b1)  &&   (a_i[12]==1'b1) ) ? 1'b0 : 1'b1;
	assign #1 cs_two   = ( (a_i[13]==1'b1)  &&   (a_i[12]==1'b0) ) ? 1'b0 : 1'b1;
	assign #1 cs_one   = ( (a_i[13]==1'b0)  &&   (a_i[12]==1'b1) ) ? 1'b0 : 1'b1;
	assign #1 cs_zero  = ( (a_i[13]==1'b0)  &&   (a_i[12]==1'b0) ) ? 1'b0 : 1'b1;


	assign #1 a_i = mem_addr;

	assign #1 w_i = w_in;

	assign #1 w_en = wen;

	always @( * )begin
			mask_wen = 4'b1111;
		 	if(w_en == 1'b1) begin
				case(access_size)
					2'b00 : begin
						case(a_i[1:0])
							2'b00: mask_wen = 4'b1110;   
							2'b01: mask_wen = 4'b1101;
							2'b10: mask_wen = 4'b1011;
							2'b11: mask_wen = 4'b0111;
						endcase
					end
					2'b01:begin
						case(a_i[1:0])
							2'b00:mask_wen = 4'b1100;
							2'b10:mask_wen = 4'b0011;
						endcase
					end
					2'b10:begin
							mask_wen = 4'b0000;
					end
				endcase
			end
			
		end

	assign clk_one  =  !cs_one;  
	assign clk_two  =  !cs_two; 
	assign clk_three = !cs_three;

	always@(posedge clk, negedge rst_n ) begin
		if(!rst_n) begin
			cs_one_r<=1'b1;
			cs_two_r <=1'b1;
			cs_three_r<= 1'b1;
		end
		else begin
			if (clk_one)
			cs_one_r<=1'b0;
			else
			cs_one_r<=1'b1;
			if (clk_two)
			cs_two_r<=1'b0;
			else
			cs_two_r<=1'b1;
			if (clk_three)
			cs_three_r<=1'b0;
			else
			cs_three_r<=1'b1;
		end	
	end



	
	/*bank0  0-1023*/
	SY180_1024X8X4CM4 #(.INITFILE0(INITFILE0),
			   .INITFILE1(INITFILE1),
		           .INITFILE2(INITFILE2),
			   .INITFILE3(INITFILE3))
		    block0( 
			   .A0(a_i[2]), .A1(a_i[3]), .A2(a_i[4]), .A3(a_i[5]), .A4(a_i[6]) , .A5(a_i[7]), .A6(a_i[8]) , .A7(a_i[9]) , .A8(a_i[10]) , .A9(a_i[11]) ,
			   .DO0(r_data_zero[0]) , .DO1(r_data_zero[1]), .DO2(r_data_zero[2]) , .DO3(r_data_zero[3]) , .DO4(r_data_zero[4]) ,
                           .DO5(r_data_zero[5]) , .DO6(r_data_zero[6]) , .DO7(r_data_zero[7]) , .DO8(r_data_zero[8]) , .DO9(r_data_zero[9]) ,
			   .DO10(r_data_zero[10]) , .DO11(r_data_zero[11]) , .DO12(r_data_zero[12]) , .DO13(r_data_zero[13]), .DO14(r_data_zero[14]),
                           .DO15(r_data_zero[15]) , .DO16(r_data_zero[16]) , .DO17(r_data_zero[17]) , .DO18(r_data_zero[18]) , .DO19(r_data_zero[19]) , 
			   .DO20(r_data_zero[20]) , .DO21(r_data_zero[21]) , .DO22(r_data_zero[22]) ,.DO23(r_data_zero[23]) , .DO24(r_data_zero[24]) , 
			   .DO25(r_data_zero[25]) , .DO26(r_data_zero[26]) , .DO27(r_data_zero[27]) , .DO28(r_data_zero[28]) , .DO29(r_data_zero[29]) , 
			   .DO30(r_data_zero[30]), .DO31(r_data_zero[31]), .DI0(w_i[0]) , .DI1(w_i[1]), .DI2(w_i[2]) , .DI3(w_i[3]) ,
			   .DI4(w_i[4]) , .DI5(w_i[5]) , .DI6(w_i[6]), .DI7(w_i[7]), .DI8(w_i[8]), .DI9(w_i[9]), 
			   .DI10(w_i[10]), .DI11(w_i[11]), .DI12(w_i[12]), .DI13(w_i[13]) , .DI14(w_i[14]) , .DI15(w_i[15]), .DI16(w_i[16]) ,
			   .DI17(w_i[17]), .DI18(w_i[18]) , .DI19(w_i[19]) , .DI20(w_i[20]) , .DI21(w_i[21]) , .DI22(w_i[22]) , .DI23(w_i[23]) , .DI24(w_i[24]) , .DI25(w_i[25]) ,
                           .DI26(w_i[26]) , .DI27(w_i[27]) , .DI28(w_i[28]) , .DI29(w_i[29]) , .DI30(w_i[30]) , .DI31(w_i[31]) , .CK(clk), .WEB0(mask_wen[0]) , .WEB1(mask_wen[1]),
                           .WEB2(mask_wen[2]) , .WEB3(mask_wen[3]) , .CSB(cs_zero) 
			);



      /*bank1  1024-2047*/
	SY180_1024X8X4CM4 #(.INITFILE0(INITFILE0),
			   .INITFILE1(INITFILE1),
		           .INITFILE2(INITFILE2),
			   .INITFILE3(INITFILE3))

			block1( .A0(a_i[2]), .A1(a_i[3]), .A2(a_i[4]), .A3(a_i[5]), .A4(a_i[6]) , .A5(a_i[7]), .A6(a_i[8]) , .A7(a_i[9]) , .A8(a_i[10]) , .A9(a_i[11]),
			   .DO0(r_data_one[0]) , .DO1(r_data_one[1]), .DO2(r_data_one[2]) , .DO3(r_data_one[3]) , .DO4(r_data_one[4]) ,
                           .DO5(r_data_one[5]) , .DO6(r_data_one[6]) , .DO7(r_data_one[7]) , .DO8(r_data_one[8]) , .DO9(r_data_one[9]) ,
			   .DO10(r_data_one[10]) , .DO11(r_data_one[11]) , .DO12(r_data_one[12]) , .DO13(r_data_one[13]), .DO14(r_data_one[14]),
                           .DO15(r_data_one[15]) , .DO16(r_data_one[16]) , .DO17(r_data_one[17]) , .DO18(r_data_one[18]) , .DO19(r_data_one[19]) , 
			   .DO20(r_data_one[20]) , .DO21(r_data_one[21]) , .DO22(r_data_one[22]) ,.DO23(r_data_one[23]) , .DO24(r_data_one[24]) , 
			   .DO25(r_data_one[25]) , .DO26(r_data_one[26]) , .DO27(r_data_one[27]) , .DO28(r_data_one[28]) , .DO29(r_data_one[29]) , 
			   .DO30(r_data_one[30]), .DO31(r_data_one[31]), .DI0(w_i[0]) , .DI1(w_i[1]), .DI2(w_i[2]) , .DI3(w_i[3]) ,
			   .DI4(w_i[4]) , .DI5(w_i[5]) , .DI6(w_i[6]), .DI7(w_i[7]), .DI8(w_i[8]), .DI9(w_i[9]), .DI10(w_i[10]), .DI11(w_i[11]),
			   .DI12(w_i[12]), .DI13(w_i[13]) , .DI14(w_i[14]) , .DI15(w_i[15]), .DI16(w_i[16]) ,.DI17(w_i[17]), .DI18(w_i[18]) ,
			   .DI19(w_i[19]) , .DI20(w_i[20]) , .DI21(w_i[21]) ,.DI22(w_i[22]) , .DI23(w_i[23]) , .DI24(w_i[24]) , .DI25(w_i[25]) ,
                           .DI26(w_i[26]) , .DI27(w_i[27]) , .DI28(w_i[28]) , .DI29(w_i[29]) , .DI30(w_i[30]) , .DI31(w_i[31]) , .CK(clk), .WEB0(mask_wen[0]) , .WEB1(mask_wen[1]),
                           .WEB2(mask_wen[2]) , .WEB3(mask_wen[3]) , .CSB(cs_one)
			);



	/*bank2  2048-3071*/
	SY180_1024X8X4CM4 #(.INITFILE0(INITFILE0),
			   .INITFILE1(INITFILE1),
		           .INITFILE2(INITFILE2),
			   .INITFILE3(INITFILE3))

			block2(.A0(a_i[2]), .A1(a_i[3]), .A2(a_i[4]), .A3(a_i[5]), .A4(a_i[6]) , .A5(a_i[7]), .A6(a_i[8]) , .A7(a_i[9]) , .A8(a_i[10]) , .A9(a_i[11]) ,
			   .DO0(r_data_two[0]) , .DO1(r_data_two[1]), .DO2(r_data_two[2]) , .DO3(r_data_two[3]) , .DO4(r_data_two[4]) ,
                           .DO5(r_data_two[5]) , .DO6(r_data_two[6]) , .DO7(r_data_two[7]) , .DO8(r_data_two[8]) , .DO9(r_data_two[9]) ,
			   .DO10(r_data_two[10]) , .DO11(r_data_two[11]) , .DO12(r_data_two[12]) , .DO13(r_data_two[13]), .DO14(r_data_two[14]),
                           .DO15(r_data_two[15]) , .DO16(r_data_two[16]) , .DO17(r_data_two[17]) , .DO18(r_data_two[18]) , .DO19(r_data_two[19]) , 
			   .DO20(r_data_two[20]) , .DO21(r_data_two[21]) , .DO22(r_data_two[22]) ,.DO23(r_data_two[23]) , .DO24(r_data_two[24]) , 
			   .DO25(r_data_two[25]) , .DO26(r_data_two[26]) , .DO27(r_data_two[27]) , .DO28(r_data_two[28]) , .DO29(r_data_two[29]) , 
			   .DO30(r_data_two[30]), .DO31(r_data_two[31]), .DI0(w_i[0]) , .DI1(w_i[1]), .DI2(w_i[2]) , .DI3(w_i[3]) ,
			   .DI4(w_i[4]) , .DI5(w_i[5]) , .DI6(w_i[6]), .DI7(w_i[7]), .DI8(w_i[8]), .DI9(w_i[9]), 
			   .DI10(w_i[10]), .DI11(w_i[11]), .DI12(w_i[12]), .DI13(w_i[13]) , .DI14(w_i[14]) , .DI15(w_i[15]), .DI16(w_i[16]) ,
			   .DI17(w_i[17]), .DI18(w_i[18]) , .DI19(w_i[19]) , .DI20(w_i[20]) , .DI21(w_i[21]) , .DI22(w_i[22]) , .DI23(w_i[23]) , .DI24(w_i[24]) , .DI25(w_i[25]) ,
                           .DI26(w_i[26]) , .DI27(w_i[27]) , .DI28(w_i[28]) , .DI29(w_i[29]) , .DI30(w_i[30]) , .DI31(w_i[31]) , .CK(clk), .WEB0(mask_wen[0]) , .WEB1(mask_wen[1]),
                           .WEB2(mask_wen[2]) , .WEB3(mask_wen[3]) , .CSB(cs_two)  
			);


	/*bank3  3072-4095*/ 
	SY180_1024X8X4CM4 #(.INITFILE0(INITFILE0),
			   .INITFILE1(INITFILE1),
		           .INITFILE2(INITFILE2),
			   .INITFILE3(INITFILE3))

			  block3( .A0(a_i[2]), .A1(a_i[3]), .A2(a_i[4]), .A3(a_i[5]), .A4(a_i[6]) , .A5(a_i[7]), .A6(a_i[8]) , .A7(a_i[9]) , .A8(a_i[10]) , .A9(a_i[11]),
			   .DO0(r_data_three[0]) , .DO1(r_data_three[1]), .DO2(r_data_three[2]) , .DO3(r_data_three[3]) , .DO4(r_data_three[4]) ,
                           .DO5(r_data_three[5]) , .DO6(r_data_three[6]) , .DO7(r_data_three[7]) , .DO8(r_data_three[8]) , .DO9(r_data_three[9]) ,
			   .DO10(r_data_three[10]) , .DO11(r_data_three[11]) , .DO12(r_data_three[12]) , .DO13(r_data_three[13]), .DO14(r_data_three[14]),
                           .DO15(r_data_three[15]) , .DO16(r_data_three[16]) , .DO17(r_data_three[17]) , .DO18(r_data_three[18]) , .DO19(r_data_three[19]) , 
			   .DO20(r_data_three[20]) , .DO21(r_data_three[21]) , .DO22(r_data_three[22]) ,.DO23(r_data_three[23]) , .DO24(r_data_three[24]) , 
			   .DO25(r_data_three[25]) , .DO26(r_data_three[26]) , .DO27(r_data_three[27]) , .DO28(r_data_three[28]) , .DO29(r_data_three[29]) , 
			   .DO30(r_data_three[30]), .DO31(r_data_three[31]), .DI0(w_i[0]) , .DI1(w_i[1]), .DI2(w_i[2]) , .DI3(w_i[3]) ,
			   .DI4(w_i[4]) , .DI5(w_i[5]) , .DI6(w_i[6]), .DI7(w_i[7]), .DI8(w_i[8]), .DI9(w_i[9]), 
			   .DI10(w_i[10]), .DI11(w_i[11]), .DI12(w_i[12]), .DI13(w_i[13]) , .DI14(w_i[14]) , .DI15(w_i[15]), .DI16(w_i[16]) ,
			   .DI17(w_i[17]), .DI18(w_i[18]) , .DI19(w_i[19]) , .DI20(w_i[20]) , .DI21(w_i[21]) , .DI22(w_i[22]) , .DI23(w_i[23]) , .DI24(w_i[24]) , .DI25(w_i[25]) ,
                           .DI26(w_i[26]) , .DI27(w_i[27]) , .DI28(w_i[28]) , .DI29(w_i[29]) , .DI30(w_i[30]) , .DI31(w_i[31]) , .CK(clk), .WEB0(mask_wen[0]) , .WEB1(mask_wen[1]),
                           .WEB2(mask_wen[2]) , .WEB3(mask_wen[3]) , .CSB(cs_three)  
			);




	assign  pram_data_o = (cs_three_r ==1'b0 ) ? r_data_three : (cs_two_r ==1'b0 ) ? r_data_two : (cs_one_r ==1'b0 ) ? r_data_one : r_data_zero ;
	

endmodule