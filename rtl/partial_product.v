module partial_product  #(parameter N=32)(ip,seg,op);
input [N-1:0]ip;
input [2:0]seg;
output reg [2*N-1:0]op;

	always@ ( * ) begin
		 case (seg)
		 3'b000 : op = $signed({2*N{1'b0}});
		 3'b011 : op = $signed(ip<<1);
		 3'b100 : op = $signed((~ip+34'd1)<<1);
		 3'b101 : op = $signed(~ip+34'd1);
		 3'b110 : op = $signed(~ip+34'd1);
		 3'b111 : op = $signed({2*N{1'b0}});	
		 default: op = $signed(ip);
		 endcase
	end
endmodule
