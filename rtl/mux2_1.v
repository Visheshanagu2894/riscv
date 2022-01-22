// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   mux2_1.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   <short description>            
//
// Create Date       :   Fri Aug 21 08:39:01 2020 
// Last Change       :   $Date: 2020-09-15 08:43:10 +0200 (Tue, 15 Sep 2020) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module mux2_1 (
    sel,
    in_one,
    in_two,
    outp
);
    parameter N=1;
    output [N-1:0] outp;
    input [N-1:0] in_one;
    input [N-1:0] in_two;
    input sel;
    
    assign outp = (sel)?in_two:in_one;

endmodule