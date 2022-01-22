// Company           :   tud                      
// Author            :   erdi19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   fetch_mem_controller.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   Fetching from memory          
//
// Create Date       :   Sat Aug  1 17:28:06 2020 
// Last Change       :   $Date: 2020-11-21 10:20:51 +0100 (Sat, 21 Nov 2020) $
// by                :   $Author: erdi19 $                  			
//------------------------------------------------------------


module fetch_mem_ctrller(
				input [31:0]		pc_addr,    		//PC_next from Branch Unit
				input [31:0]		pc_addr_reg,		//pc_addr from fetcher									
				input [31:0]		pram_r_data, 		//from program memory	
				output reg [15:0] 	f_pram_addr,		//to program memory
				output  		f_bus_en,		//to bus and PRAM
				output reg [15:0]	f_bus_addr,		//to bus
				output [31:0]		inst_data		//to decoder 
			);


	assign f_bus_en	=(pc_addr[14] || pc_addr[15] ||pc_addr[16]); 

	always@ ( * )begin  			
		f_pram_addr   = pc_addr_reg;		
		f_bus_addr    = 16'd0;
		if(!f_bus_en)begin
	 		f_pram_addr   = pc_addr; 
		end
		else begin
		 	f_bus_addr     = pc_addr;		
		end
	end

	assign inst_data =  pram_r_data;

endmodule