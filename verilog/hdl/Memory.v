module Memory (
	input		clk,
	input		Write,
	input		Read,
	input	[11:0]	address,
	input	[15:0]	data_in,
	output	[15:0]	data_out);

	reg	[15:0]	mem [0:11];
	
	initial
	begin
		mem[0] = 16'h3002;
		mem[1] = 16'h1003;
		mem[2] = 16'h0007;
		mem[3] = 16'h0005;
	end
	
	assign data_out = Read ? mem[address] : 16'bz;

	always @(posedge clk)
	begin
		if (Write)
		begin
			mem[address] = data_in;
		end
	end

endmodule
