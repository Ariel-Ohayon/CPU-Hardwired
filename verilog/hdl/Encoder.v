module Encoder (
	input			[7:0]	x,
	output reg	[2:0]	selector);
	
	always @(x)
	begin
		case(x)
			8'b00000010:	selector = 3'b001;
			8'b00000100:	selector = 3'b010;
			8'b00001000:	selector = 3'b011;
			8'b00010000:	selector = 3'b100;
			8'b00100000:	selector = 3'b101;
			8'b01000000:	selector = 3'b110;
			8'b10000000:	selector = 3'b111;
		endcase
	end
	
endmodule