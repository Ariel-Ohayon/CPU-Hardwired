module ControlUnit (
	input		reset,
	input		clk,

	input	[15:0]	ir,

	output	[7:0]	ld,
	output	[7:0]	inr,
	output	[7:0]	clr);

	wire	[2:0]	in_dec3x8;
	wire	[3:0]	counter;

	wire	[7:0]	D;
	wire	[15:0]	T;

	wire		SC_inr;
	wire		SC_clr;

	assign in_dec3x8 = ir[14:12];
	
	Decoder #(3) U1 (
		.in	(in_dec3x8),
		.out	(D));

	Decoder #(4) U2 (
		.in	(counter),
		.out	(T));

	SequenceCounter	U3 (
		.inr	(SC_inr),
		.clr	(SC_clr),
		.clk	(clk),
		.out	(counter));

endmodule

module Decoder #(parameter Size = 3) (
	input		[Size-1:0]	in,
	output reg	[(2**Size)-1:0]	out);
	
	integer i;
	
	always @(in)
	begin
		out = {{2**Size-1{1'b0}},1'b1} << in;
	end

endmodule

module SequenceCounter(
	input			inr,
	input			clr,
	input			clk,
	output reg	[3:0]	out);

	always @(posedge clk)
	begin
		if (clr)
			out <= 0;
		else if (inr)
			out <= out + 1;
	end

endmodule
