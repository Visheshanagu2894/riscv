// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   mux4_1.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   <short description>            
//
// Create Date       :   Fri Aug 21 08:39:30 2020 
// Last Change       :   $Date: 2020-09-20 23:37:58 +0200 (Sun, 20 Sep 2020) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module mux4_1 (
    sel,
    in_one,
    in_two,
    in_three,
    in_four,
    outp
);
    parameter N=1;
    input [1:0] sel;
    input [N-1:0] in_one;
    input [N-1:0] in_two;
    input [N-1:0] in_three;
    input [N-1:0] in_four;
    output reg [N-1:0] outp;
    
    always @( * ) begin
        case(sel)
            2'b00: outp = in_one;
            2'b01: outp = in_two;
            2'b10: outp = in_three;
            2'b11: outp = in_four;
        endcase
    end
    
endmodule