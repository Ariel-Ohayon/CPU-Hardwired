module ControlUnit (
	input		reset,
	input		clk,

	input	[15:0]	ir,

	output	[4:0]	ld,
	output	[3:0]	inr,
	output	[3:0]	clr,
	output			Read,
	output			Write,
	output	[7:0]	x); // x - for the encoder

	wire	[2:0]		in_dec3x8;
	wire	[3:0]		counter;

	wire	 [7:0]	D;
	wire	[15:0]	T;

	wire		SC_inr;
	wire		SC_clr;
	
	wire LD_AR;
	wire LD_PC;
	wire LD_DR;
	wire LD_AC;
	wire LD_IR;
	
	wire LD_AC_r;
	
	wire INR_AR;
	wire INR_PC;
	wire INR_DR;
	wire INR_AC;
	
	wire CLR_AR;
	wire CLR_PC;
	wire CLR_DR;
	wire CLR_AC;

	assign in_dec3x8 = ir[14:12];
	
	assign ld  = {LD_AR,  LD_PC,  LD_DR,  LD_AC, LD_IR};
	assign inr = {INR_AR, INR_PC, INR_DR, INR_AC};
	assign clr = {CLR_AR, CLR_PC, CLR_DR, CLR_AC};
	
	Decoder #(3) U1 (
		.in	(in_dec3x8),
		.out	(D));

	Decoder #(4) U2 (
		.in	(counter),
		.out	(T));

	SequenceCounter	U3 (
		.rst	(reset),
		.inr	(1'b1),
		.clr	(SC_clr),
		.clk	(clk),
		.out	(counter));
		
	assign SC_clr = T[3] & (D[7])					   |
					T[4] & (D[3] | D[4])			   |
					T[5] & (D[0] | D[1] | D[2] | D[5]) |
					T[6] & (D[6]);
						 
	// Logic for the encoder
	assign x[0] = 1'b0;
	assign x[1] = (D[5] & T[5]) | (D[4] & T[4]);										// x1 = AR
	assign x[2] = T[0] | (D[5] & T[4]);													// x2 = PC
	assign x[3] = (D[2] & T[5]) | (D[6] & T[6]);										// x3 = DR
	assign x[4] = (D[3] & T[4]);														// x4 = AC
	assign x[5] = (T[2]);																// x5 = IR
	assign x[6] = 1'b0;																	// x6 = TR
	assign x[7] = T[1] | (D[0] & T[4]) | (D[1] & T[4]) | (D[2] & T[4]) | (D[6] & T[4]);	// x7 = MEM
	
	// Logic for AR Register:
	assign LD_AR  = (T[0] | T[2]) & (~reset);
	assign INR_AR = D[5] & T[4];
	assign CLR_AR = 1'b0;
	
	//Logic for PC Register:
	assign LD_PC  = (D[4] & T[4]) | (D[5] & T[5]);
	assign INR_PC = T[1];	// NEED TO COMPLETE THIS SIGNAL
	assign CLR_PC = reset;	//There is no signal for clear the PC
	
	//Logic for DR Register:
	assign LD_DR  = (D[0] & T[4]) | (D[1] & T[4]) | (D[2] & T[4]) | (D[6] & T[4]);
	assign INR_DR = D[6] & T[5];
	assign CLR_DR = 1'b0;
	
	//Logic for AC Register:
	assign LD_AC_r = D[7] & T[3] & (ir[9] | ir[7] | ir[6]);
	assign LD_AC   = (D[0]  & T[5]) | (D[1] & T[5]) | (D[2] & T[5]) | LD_AC_r; //(D[7] & T[3]); - WHEN THERE IS D[7] NEED TO CHECK THE ADDR BITS
	assign INR_AC  = ir[5]  & D[7] & T[3];
	assign CLR_AC  = ir[11] & D[7] & T[3];
	
	//Logic for IR Register:
	assign LD_IR = T[1];
	
	//Logic for Read Memory:
	assign Read  = T[1] | (D[0] & T[4]) | (D[1] & T[4]) | (D[2] & T[4]) | (D[6] & T[4]);
	//Logic for Write Memory:
	assign Write = (D[3] & T[4]) | (D[5] & T[4]) | (D[6] & T[6]);
	
endmodule

module Decoder #(parameter Size = 3) (
	input		[Size-1:0]	in,
	output reg	[(2**Size)-1:0]	out);
	
	always @(in)
	begin
		out = 0;
		out[in] = 1'b1;
	end

endmodule

module SequenceCounter(
	input			rst,
	input			inr,
	input			clr,
	input			clk,
	output reg	[3:0]	out);

	always @(posedge rst,posedge clk)
	begin
		if (rst)
			out <= 0;
		else
			if (clr)
				out <= 0;
			else if (inr)
				out <= out + 1;
	end
endmodule
