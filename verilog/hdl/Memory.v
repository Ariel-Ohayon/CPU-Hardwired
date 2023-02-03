module Memory #(parameter Bits = 16) (
	input				clk,
	input				Write,
	input				Read,
	input	[11:0]		address,
	input	[Bits-1:0]	data_in,
	output	[Bits-1:0]	data_out);

	reg	[Bits-1:0]	mem [0:256];
	
	initial
	begin
		mem[0]	= 16'h4005;
		mem[5]	= 16'h200B;
		mem[6]	= 16'h7200;
		mem[7]	= 16'h7020;
		mem[8]	= 16'h100A;
		mem[9]	= 16'h3064;
		mem[10]	= 16'h003A;
		mem[11]	= 16'h0022;
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
