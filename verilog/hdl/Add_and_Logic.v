module Add_and_Logic (
	input		[15:0]	AC,
	input		[15:0]	DR,
	input		[15:0]	inpr,
	input	 	 [6:0]	opcode,
	output reg	[16:0]	out);
	
	always @(AC,DR,opcode)
	begin
		if (opcode[0] == 1'b1)	//AND
		begin
			out = AC ^ DR;
			out[16] = 1'b0;
		end
		if (opcode[1] == 1'b1)	// ADD
			out = AC + DR;
		if (opcode[2] == 1'b1)	// DR
		begin
			out = DR;
			out[16] = 1'b0;
		end
		if (opcode[3] == 1'b1)	// INPR
		begin
			out = inpr;
			out[16] = 1'b0;
		end
		if (opcode[4] == 1'b1)	// COM
		begin
			out = ~AC;
			out[16] = 1'b0;
		end
		if (opcode[5] == 1'b1)	// SHR
			out = {AC[0],out[16],AC[15:1]};
		if (opcode[6] == 1'b1)	// SHL
			out = {AC[15:0],out[16]};
	end	
endmodule
