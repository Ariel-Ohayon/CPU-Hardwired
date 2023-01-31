module Reg #(parameter Size = 16) (

	input				clk,
	
	input		[Size-1:0]	in,
	
	input				Load,
	input				Increment,
	input				Clear,

	output reg	[Size-1:0]	out);

	always @(posedge clk)
	begin
		if (Clear)
			out <= 0;
		else if (Load)
			out <= in;
		else if (Increment)
			out <= out + 1;
	end

endmodule
