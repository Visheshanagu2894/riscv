// Company           :   tud                      
// accuthor            :   vepr19            
// E-multail            :   <email>                    
//                    			
// Filename          :   multiplier.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   <short description>            
//
// Create Date       :   Tue Dec 29 14:13:29 2020 
// Last Change       :   $Date: 2021-01-03 11:36:29 +0100 (Sun, 03 Jan 2021) $
// by                :   $accuthor: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps

module new_mul #(parameter N=32) (prod, mc, mp);
output reg [2*N-1:0] prod;
input [N-1:0] mc, mp;
wire [2*N-1:0] temp [16:0];
wire zero=1'b0;
	 partial_product #(.N(N)) p_one (.ip(mc), .seg({mp[1:0],zero}), .op(temp[0]));
	 partial_product #(.N(N)) p_two (.ip(mc), .seg(mp[3:1]), .op(temp[1]));
	 partial_product #(.N(N)) p_thr (.ip(mc), .seg(mp[5:3]), .op(temp[2]));
	 partial_product #(.N(N)) p_fr  (.ip(mc), .seg(mp[7:5]), .op(temp[3]));
	 partial_product #(.N(N)) p_fv  (.ip(mc), .seg(mp[9:7]), .op(temp[4]));
	 partial_product #(.N(N)) p_sx  (.ip(mc), .seg(mp[11:9]), .op(temp[5]));
	 partial_product #(.N(N)) p_svn (.ip(mc), .seg(mp[13:11]), .op(temp[6]));
	 partial_product #(.N(N)) p_ei  (.ip(mc), .seg(mp[15:13]), .op(temp[7]));
	 partial_product #(.N(N)) p_ni  (.ip(mc), .seg(mp[17:15]), .op(temp[8]));
	 partial_product #(.N(N)) p_ten (.ip(mc), .seg(mp[19:17]), .op(temp[9]));
	 partial_product #(.N(N)) p_elv (.ip(mc), .seg(mp[21:19]), .op(temp[10]));
	 partial_product #(.N(N)) p_twlv (.ip(mc), .seg(mp[23:21]),.op( temp[11]));
	 partial_product #(.N(N)) p_thir (.ip(mc), .seg(mp[25:23]), .op(temp[12]));
	 partial_product #(.N(N)) p_frtn (.ip(mc), .seg(mp[27:25]), .op(temp[13]));
	 partial_product #(.N(N)) p_fitn (.ip(mc), .seg(mp[29:27]), .op(temp[14]));
	 partial_product #(.N(N)) p_sxtn (.ip(mc), .seg(mp[31:29]), .op(temp[15]));
	 partial_product #(.N(N)) p_svtn (.ip(mc), .seg(mp[33:31]), .op(temp[16]));

	always @( * )
	begin


		prod= ($signed(temp[0])+$signed(temp[1]<<2)+$signed(temp[2]<<4)+
		$signed(temp[3]<<6)+$signed(temp[4]<<8)+$signed(temp[5]<<10)+
		$signed(temp[6]<<12)+$signed(temp[7]<<14)+$signed(temp[8]<<16)+$signed(temp[9]<<18)+
		$signed(temp[10]<<20)+$signed(temp[11]<<22)+$signed(temp[12]<<24)+
		$signed(temp[13]<<26)+$signed(temp[14]<<28)+$signed(temp[15]<<30)+$signed(temp[16]<<32));

		
	end


endmodule