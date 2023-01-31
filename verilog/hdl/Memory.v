module Memory (
	input		clk,
	input		Write,
	input		Read,
	input	[11:0]	address,
	input	[15:0]	data_in,
	output	[15:0]	data_out);

	reg	[15:0]	mem [0:11];

	assign data_out = Read ? mem[address] : 16'bz;

	always @(posedge clk)
	begin
		if (Write)
		begin
			mem[address] = data_in;
		end
	end

endmodule
