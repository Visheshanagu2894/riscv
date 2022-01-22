// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   bk_adder.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   32 bit Brent-Kung Adder implementation for the faster computation of addition.      
//
// Create Date       :   Sun Dec 27 09:58:41 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps

module bk_adder #(parameter N=32)(
input [N-1:0] a,
input [N-1:0] b,
input cin,
output [N:0] sum
);


	
	//Stage one outputs
	wire [N-1:0] p;
	wire [N-1:0] g;
	wire [N-1:0] cp_one;
	wire [N-1:0] cg_one;


	//stage two outputs

	wire cg_tw_th;
	wire cp_tw_th;

	wire cg_tw_sv;
	wire cp_tw_sv;

	wire cg_tw_el;
	wire cp_tw_el;

	wire cg_tw_fi;
	wire cp_tw_fi;

	wire cg_tw_ni;
	wire cp_tw_ni;

	wire cg_tw_twth;
	wire cp_tw_twth;

	wire cg_tw_twsv;
	wire cp_tw_twsv;

	wire cg_tw_thon;
	wire cp_tw_thon;


	//stage three outputs

	wire cg_th_sv;
	wire cp_th_sv;

	wire cg_th_fif;
	wire cp_th_fif;

	wire cg_th_twth;
	wire cp_th_twth;

	wire cg_th_thon;
	wire cp_th_thon;

	//stage four outputs


	wire cg_fr_fif;
	wire cp_fr_fif;

	wire cg_fr_thon;
	wire cp_fr_thon;

	//stage five outputs

	wire cg_fi_thon;
	//wire cp_fi_thon;

	//stage six outputs
	wire cg_sx_twth;
	wire cp_sx_twth;

	//stage seven outputs
	wire cg_sv_el;
	wire cp_sv_el;
	wire cg_sv_nin;
	wire cp_sv_nin;
	wire cg_sv_twsv;
	wire cp_sv_twsv;

	//stage eight outputs
	wire cg_ei_fv;
	wire cp_ei_fv;
	wire cg_ei_ni;
	wire cp_ei_ni;
	wire cg_ei_thir;
	wire cp_ei_thir;
	wire cg_ei_svtn;
	wire cp_ei_svtn;
	wire cg_ei_twon;
	wire cp_ei_twon;
	wire cg_ei_twfv;
	wire cp_ei_twfv;
	wire cg_ei_twni;
	wire cp_ei_twni;

	//stage nine outputs
	wire cg_ni_tw;
	//wire cp_ni_tw;

	wire cg_ni_fr;
	//wire cp_ni_fr;

	wire cg_ni_sx;
	//wire cp_ni_sx;

	wire cg_ni_ei;
	//wire cp_ni_ei;

	wire cg_ni_tn;
	//wire cp_ni_tn;

	wire cg_ni_twel;
	//wire cp_ni_twel;

	wire cg_ni_frtn;
	//wire cp_ni_frtn;

	wire cg_ni_eitn;
	//wire cp_ni_eitn;

	wire cg_ni_twty;
	//wire cp_ni_twty;

	wire cg_ni_twtw;
	//wire cp_ni_twtw;

	wire cg_ni_twfr;
	//wire cp_ni_twfr;

	wire cg_ni_twsx;
	//wire cp_ni_twsx;

	wire cg_ni_twei;
	//wire cp_ni_twei;

	wire cg_ni_th;
	//wire cp_ni_th;

	wire cg_ni_sxtn;
	//wire cp_ni_sxtn;


	// start first stage
	assign p[0] = a[0] ^ b[0] ^ cin; //^ cin;//first level zero bit start
	assign g[0] = a[0] & b[0] | (cin & ( a[0] ^ b[0])); //| (cin & ( a[0] ^ b[0]));
	assign cp_one[0] = p[0];
	assign cg_one[0] = g[0]; //first level zero bit complete

	assign p[1] = a[1] ^ b[1]; //first level first bit start
	assign g[1] = a[1] & b[1];
	assign cg_one[1] = (p[1] & g[0])| g[1];
	assign cp_one[1] = p[1] & p[0]; // first level first bit complete

	assign p[2] = a[2] ^ b[2]; //first level 2nd bit start
	assign g[2] = a[2] & b[2];
	assign cp_one[2] = p[2];
	assign cg_one[2] = g[2]; // first level 2nd bit complete

	assign p[3] = a[3] ^ b[3]; //first level 3rd bit start
	assign g[3] = a[3] & b[3];
	assign cg_one[3] = (p[3] & g[2]) | g[3];
	assign cp_one[3] = p[3] & p[2]; //first level 3rd bit complete

	assign p[4] = a[4] ^ b[4]; //first level 3rd bit start
	assign g[4] = a[4] & b[4];
	assign cg_one[4] = g[4];
	assign cp_one[4] = p[4]; //first level 3rd bit complete

	assign p[5] = a[5] ^ b[5]; //first level 3rd bit start
	assign g[5] = a[5] & b[5];
	assign cg_one[5] = (p[5] & g[4]) | g[5];
	assign cp_one[5] = p[5] & p[4]; //first level 3rd bit complete

	assign p[6] = a[6] ^ b[6]; //first level 3rd bit start
	assign g[6] = a[6] & b[6];
	assign cg_one[6] = g[6];
	assign cp_one[6] = p[6]; //first level 3rd bit complete

	assign p[7] = a[7] ^ b[7];
	assign g[7] = a[7] & b[7];
	assign cg_one[7] = (p[7] & g[6]) | g[7];
	assign cp_one[7] = p[7] & p[6];

	assign p[8] = a[8] ^ b[8];
	assign g[8] = a[8] & b[8];
	assign cg_one[8] = g[8];
	assign cp_one[8] = p[8];

	assign p[9] = a[9] ^ b[9];
	assign g[9] = a[9] & b[9];
	assign cg_one[9] = (p[9] & g[8]) | g[9];
	assign cp_one[9] = p[9] & p[8];

	assign p[10] = a[10] ^ b[10];
	assign g[10] = a[10] & b[10];
	assign cg_one[10] = g[10];
	assign cp_one[10] = p[10];

	assign p[11] = a[11] ^ b[11];
	assign g[11] = a[11] & b[11];
	assign cg_one[11] = (p[11] & g[10]) | g[11];
	assign cp_one[11] = p[11] & p[10];

	assign p[12] = a[12] ^ b[12];
	assign g[12] = a[12] & b[12];
	assign cg_one[12] = g[12];
	assign cp_one[12] = p[12];

	assign p[13] = a[13] ^ b[13];
	assign g[13] = a[13] & b[13];
	assign cg_one[13] = (p[13] & g[12]) | g[13];
	assign cp_one[13] = p[13] & p[12];

	assign p[14] = a[14] ^ b[14];
	assign g[14] = a[14] & b[14];
	assign cg_one[14] = g[14];
	assign cp_one[14] = p[14];

	assign p[15] = a[15] ^ b[15];
	assign g[15] = a[15] & b[15];
	assign cg_one[15] = (p[15] & g[14]) | g[15];
	assign cp_one[15] = p[15] & p[14];

	assign p[16] = a[16] ^ b[16];//first level zero bit start
	assign g[16] = a[16] & b[16];
	assign cp_one[16] = p[16];
	assign cg_one[16] = g[16]; //first level zero bit complete

	assign p[17] = a[17] ^ b[17]; //first level first bit start
	assign g[17] = a[17] & b[17];
	assign cg_one[17] = (p[17] & g[16])| g[17];
	assign cp_one[17] = p[17] & p[16]; // first level first bit complete



	assign p[18] = a[18] ^ b[18];//first level zero bit start
	assign g[18] = a[18] & b[18];
	assign cp_one[18] = p[18];
	assign cg_one[18] = g[18]; //first level zero bit complete

	assign p[19] = a[19] ^ b[19]; //first level first bit start
	assign g[19] = a[19] & b[19];
	assign cg_one[19] = (p[19] & g[18])| g[19];
	assign cp_one[19] = p[19] & p[18]; // first level first bit complete


	assign p[20] = a[20] ^ b[20]; //first level 3rd bit start
	assign g[20] = a[20] & b[20];
	assign cg_one[20] = g[20];
	assign cp_one[20] = p[20]; //first level 3rd bit complete

	assign p[21] = a[21] ^ b[21]; //first level 3rd bit start
	assign g[21] = a[21] & b[21];
	assign cg_one[21] = (p[21] & g[20]) | g[21];
	assign cp_one[21] = p[21] & p[20]; //first level 3rd bit complete

	assign p[22] = a[22] ^ b[22]; //first level 3rd bit start
	assign g[22] = a[22] & b[22];
	assign cg_one[22] = g[22];
	assign cp_one[22] = p[22]; //first level 3rd bit complete

	assign p[23] = a[23] ^ b[23];
	assign g[23] = a[23] & b[23];
	assign cg_one[23] = (p[23] & g[22]) | g[23];
	assign cp_one[23] = p[23] & p[22];

	assign p[24] = a[24] ^ b[24];
	assign g[24] = a[24] & b[24];
	assign cg_one[24] = g[24];
	assign cp_one[24] = p[24];

	assign p[25] = a[25] ^ b[25];
	assign g[25] = a[25] & b[25];
	assign cg_one[25] = (p[25] & g[24]) | g[25];
	assign cp_one[25] = p[25] & p[24];

	assign p[26] = a[26] ^ b[26];
	assign g[26] = a[26] & b[26];
	assign cg_one[26] = g[26];
	assign cp_one[26] = p[26];

	assign p[27] = a[27] ^ b[27];
	assign g[27] = a[27] & b[27];
	assign cg_one[27] = (p[27] & g[26]) | g[27];
	assign cp_one[27] = p[27] & p[26];

	assign p[28] = a[28] ^ b[28];
	assign g[28] = a[28] & b[28];
	assign cg_one[28] = g[28];
	assign cp_one[28] = p[28];

	assign p[29] = a[29] ^ b[29];
	assign g[29] = a[29] & b[29];
	assign cg_one[29] = (p[29] & g[28]) | g[29];
	assign cp_one[29] = p[29] & p[28];

	assign p[30] = a[30] ^ b[30];
	assign g[30] = a[30] & b[30];
	assign cg_one[30] = g[30];
	assign cp_one[30] = p[30];

	assign p[31] = a[31] ^ b[31];
	assign g[31] = a[31] & b[31];
	assign cg_one[31] = (p[31] & g[30]) | g[31];
	assign cp_one[31] = p[31] & p[30];




	//Stage two
	assign cg_tw_th=(cp_one[3] & cg_one[1]) | cg_one[3];
	assign cp_tw_th= cp_one[3] & cp_one[1];

	assign cg_tw_sv=(cp_one[7] & cg_one[5]) | cg_one[7];
	assign cp_tw_sv=cp_one[7] & cp_one[5];

	assign cg_tw_el=(cp_one[11] & cg_one[9]) | cg_one[11];
	assign cp_tw_el=cp_one[11] & cp_one[9];

	assign cg_tw_fi=(cp_one[15] & cg_one[13]) | cg_one[15];
	assign cp_tw_fi=cp_one[15] & cp_one[13];

	assign cg_tw_ni=(cp_one[19] & cg_one[17]) | cg_one[19];
	assign cp_tw_ni=cp_one[19] & cp_one[17];

	assign cg_tw_twth=(cp_one[23] & cg_one[21]) | cg_one[23];
	assign cp_tw_twth=cp_one[23] & cp_one[21];

	assign cg_tw_twsv=(cp_one[27] & cg_one[25]) | cg_one[27];
	assign cp_tw_twsv=cp_one[27] & cp_one[25];

	assign cg_tw_thon=(cp_one[31] & cg_one[29]) | cg_one[31];
	assign cp_tw_thon=cp_one[31] & cp_one[29];



	//stage three

	assign cg_th_sv= (cp_tw_sv & cg_tw_th) |cg_tw_sv ;
	assign cp_th_sv= cp_tw_sv & cp_tw_th;

	assign cg_th_fif=(cp_tw_fi & cg_tw_el) |cg_tw_fi ;
	assign cp_th_fif=cp_tw_fi & cp_tw_el;

	assign cg_th_twth=(cp_tw_twth & cg_tw_ni) |cg_tw_twth ;
	assign cp_th_twth=cp_tw_twth & cp_tw_ni;

	assign cg_th_thon=(cp_tw_thon & cg_tw_twsv) |cg_tw_thon ;
	assign cp_th_thon=cp_tw_thon & cp_tw_twsv;



	//stage four



	assign cg_fr_fif=(cp_th_fif & cg_th_sv) | cg_th_fif;
	assign cp_fr_fif=cp_th_fif & cp_th_sv;

	assign cg_fr_thon=(cp_th_thon & cg_th_twth) | cg_th_thon;
	assign cp_fr_thon=cp_th_thon & cp_th_twth;




	//stage five

	assign cg_fi_thon=(cp_fr_thon & cg_fr_fif) | cg_fr_thon;
	//assign cp_fi_thon= cp_fr_thon & cp_fr_fif;


	//stage six

	assign cg_sx_twth=(cp_th_twth & cg_fr_fif) | cg_th_twth;
	assign cp_sx_twth= cp_th_twth & cp_fr_fif;

	//stage 7

	assign cg_sv_el=(cp_tw_el & cg_th_sv) | cg_tw_el;
	assign cp_sv_el= cp_tw_el & cp_th_sv;

	assign cg_sv_nin=(cp_tw_ni & cg_fr_fif) | cg_tw_ni;
	assign cp_sv_nin= cp_tw_ni & cp_fr_fif;

	assign cg_sv_twsv=(cp_tw_twsv & cg_sx_twth) | cg_tw_twsv;
	assign cp_sv_twsv= cp_tw_twsv & cp_sx_twth;


	//stage 8


	assign cg_ei_fv=(cp_one[5] & cg_tw_th) | cg_one[5];
	assign cp_ei_fv= cp_one[5] & cp_tw_th;

	assign cg_ei_ni=(cp_one[9] & cg_th_sv) | cg_one[9];
	assign cp_ei_ni= cp_one[9] & cp_th_sv;

	assign cg_ei_thir=(cp_one[13] & cg_sv_el) | cg_one[13];
	assign cp_ei_thir= cp_one[13] & cp_sv_el;

	assign cg_ei_svtn=(cp_one[17] & cg_fr_fif) | cg_one[17];
	assign cp_ei_svtn= cp_one[17] & cp_fr_fif;

	assign cg_ei_twon=(cp_one[21] & cg_sv_nin) | cg_one[21];
	assign cp_ei_twon= cp_one[21] & cp_sv_nin;

	assign cg_ei_twfv=(cp_one[25] & cg_sx_twth) | cg_one[25];
	assign cp_ei_twfv= cp_one[25] & cp_sx_twth;

	assign cg_ei_twni=(cp_one[29] & cg_sv_twsv) | cg_one[29];
	assign cp_ei_twni= cp_one[29] & cp_sv_twsv;



	//stage nine outputs


	assign cg_ni_tw= ( cp_one[2] & cg_one[1])|cg_one[2] ;
	//assign cp_ni_tw=  cp_one[2] & cp_one[1];

	assign cg_ni_fr= ( cp_one[4] & cg_tw_th)|cg_one[4] ;
	//assign cp_ni_fr= cp_one[4] & cp_tw_th;

	assign cg_ni_sx= ( cp_one[6] & cg_ei_fv)|cg_one[6] ;
	//assign cp_ni_sx=  cp_one[6] & cp_ei_fv ;

	assign cg_ni_ei= ( cp_one[8] & cg_th_sv)|cg_one[8] ;
	//assign cp_ni_ei=  cp_one[8] & cp_th_sv;


	assign cg_ni_tn= ( cp_one[10] & cg_ei_ni)|cg_one[10] ;
	//assign cp_ni_tn= cp_one[10] & cp_ei_ni;

	assign cg_ni_twel= ( cp_one[12] & cg_sv_el)|cg_one[12] ;
	//assign cp_ni_twel= cp_one[12] & cp_sv_el;

	assign cg_ni_frtn= ( cp_one[14] & cg_ei_thir)|cg_one[14] ;
	//assign cp_ni_frtn=  cp_one[14] & cp_ei_thir;

	assign cg_ni_sxtn= ( cp_one[16] & cg_fr_fif)|cg_one[16] ;
	//assign cp_ni_sxtn= cp_one[16] & cp_fr_fif;


	assign cg_ni_eitn= ( cp_one[18] & cg_ei_svtn)|cg_one[18] ;
	//assign cp_ni_eitn= cp_one[18] & cp_ei_svtn;

	assign cg_ni_twty= ( cp_one[20] & cg_sv_nin)|cg_one[20] ;
	//assign cp_ni_twty= cp_one[20] & cp_sv_nin;

	assign cg_ni_twtw= ( cp_one[22] & cg_ei_twon)|cg_one[22] ;
	//assign cp_ni_twtw= cp_one[22] & cp_ei_twon;

	assign cg_ni_twfr= ( cp_one[24] & cg_sx_twth)|cg_one[24] ;
	//assign cp_ni_twfr= cp_one[24] & cp_sx_twth;

	assign cg_ni_twsx= ( cp_one[26] & cg_ei_twfv)|cg_one[26] ;
	//assign cp_ni_twsx= cp_one[26] & cp_ei_twfv;

	assign cg_ni_twei= ( cp_one[28] & cg_sv_twsv)|cg_one[28] ;
	//assign cp_ni_twei= cp_one[28] & cp_sv_twsv;

	assign cg_ni_th= ( cp_one[30] & cg_ei_twni)|cg_one[30] ;
	//assign cp_ni_th= cp_one[30] & cp_ei_twni;



	//Sum

	assign sum[0] = p[0];
	assign sum[1] = p[1] ^ cg_one[0];
	assign sum[2] = p[2] ^ cg_one[1];
	assign sum[3] = p[3] ^ cg_ni_tw;

	assign sum[4] = p[4] ^ cg_tw_th;
	assign sum[5] = p[5] ^ cg_ni_fr;
	assign sum[6] = p[6] ^ cg_ei_fv;
	assign sum[7] = p[7] ^ cg_ni_sx;


	assign sum[8] = p[8] ^ cg_th_sv;
	assign sum[9] = p[9] ^ cg_ni_ei;
	assign sum[10] = p[10] ^ cg_ei_ni;
	assign sum[11] = p[11] ^ cg_ni_tn;

	assign sum[12] = p[12] ^ cg_sv_el;
	assign sum[13] = p[13] ^ cg_ni_twel;
	assign sum[14] = p[14] ^ cg_ei_thir;
	assign sum[15] = p[15] ^ cg_ni_frtn;

	assign sum[16] = p[16] ^ cg_fr_fif;
	assign sum[17] = p[17] ^ cg_ni_sxtn;
	assign sum[18] = p[18] ^ cg_ei_svtn;
	assign sum[19] = p[19] ^ cg_ni_eitn;


	assign sum[20] = p[20] ^ cg_sv_nin;
	assign sum[21] = p[21] ^ cg_ni_twty;
	assign sum[22] = p[22] ^ cg_ei_twon;
	assign sum[23] = p[23] ^ cg_ni_twtw;
	assign sum[24] = p[24] ^ cg_sx_twth;
	assign sum[25] = p[25] ^ cg_ni_twfr;
	assign sum[26] = p[26] ^ cg_ei_twfv;
	assign sum[27] = p[27] ^ cg_ni_twsx;
	assign sum[28] = p[28] ^ cg_sv_twsv;
	assign sum[29] = p[29] ^ cg_ni_twei;
	assign sum[30] = p[30] ^ cg_ei_twni;
	assign sum[31] = p[31] ^ cg_ni_th;

	assign sum[32] = cg_fi_thon;

endmodule







