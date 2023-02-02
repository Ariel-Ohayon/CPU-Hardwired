module CPU (
	input			reset,
	input			clk,
	input	[15:0]	INPR_Register,
	output	[15:0]	OUTR_Register);
	
	wire	[2:0]		selector;
	
	wire	[11:0]	AR_out;
	wire	[11:0]	PC_out;
	wire	[15:0]	DR_out;
	wire	[15:0]	AC_out;
	wire	[15:0]	IR_out;
	wire	[15:0]	MEM_out;
	
	wire	[15:0]	INPR_out;
	wire	[15:0]	OUTR_out;
	wire	[15:0]	INPR_in;
	
	wire	LD_AR;
	wire	LD_PC;
	wire	LD_DR;
	wire	LD_AC;
	wire	LD_IR;
	
	wire LD_OUTR;
	
	wire	INR_AR;
	wire	INR_PC;
	wire	INR_DR;
	wire	INR_AC;
	
	wire	CLR_AR;
	wire	CLR_PC;
	wire	CLR_DR;
	wire	CLR_AC;

	wire [15:0]	Bus;
	
	wire	[16:0]	AC_in;
	//wire Ein,Eout;
	
	wire	[7:0]	x;

	wire Read,Write;
	
	wire op_and;
	wire op_add;
	wire op_dr;
	wire op_inpr;
	wire op_com;
	wire op_shr;
	wire op_shl;
	
	wire op_ld;
	
	MuxBus	U1 (
		.selector	(selector),
		.ar			({4'd0,AR_out}),
		.pc			({4'd0,PC_out}),
		.dr			(DR_out),
		.ac			(AC_out),
		.ir			(IR_out),
		.tr			(16'd0),
		.mem		(MEM_out),
		.Bus		(Bus));
	
	Memory	U2 (
		.clk		(clk),
		.Write		(Write),
		.Read		(Read),
		.address	(AR_out),
		.data_in	(Bus),
		.data_out	(MEM_out));
		
	ControlUnit	U3 (
		.reset		(reset),
		.clk		(clk),
		.ir			(IR_out),
		.AC_in		(AC_in),
		.AC_out		(AC_out),
		.DR_out		(DR_out),
		.op_and		(op_and),
		.op_add		(op_add),
		.op_dr		(op_dr),
		.op_inpr	(op_inpr),
		.op_com		(op_com),
		.op_shr		(op_shr),
		.op_shl		(op_shl),
		.op_ld		(op_ld),
		.ld			({LD_AR,  LD_PC,  LD_DR,  LD_AC, LD_IR}),
		.inr		({INR_AR, INR_PC, INR_DR, INR_AC}),
		.clr		({CLR_AR, CLR_PC, CLR_DR, CLR_AC}),
		.Read		(Read),
		.Write		(Write),
		.x			(x));
	
	Encoder	U4 (
		.x			(x),
		.selector	(selector));
		
	//adder_and_logic #(16)	U5 (
	//	.clk		(clk),
	//	.AC			(AC_out),
	//	.DR			(DR_out),
	//	.INP		(INPR_out),
	//	.ControlSig	({op_ld,op_shl,op_shr,op_com,op_inpr,op_dr,op_add,op_and}),
	//	.Eout_ff	(Eout),
	//	.Ein_ff		(Ein),
	//	.out		(AC_in));
	
	Add_and_Logic	U5 (
		.AC		(AC_out),
		.DR		(DR_out),
		.inpr	(INPR_out),
		.opcode	({op_shl,op_shr,op_com,op_inpr,op_dr,op_add,op_and}),
		.out	(AC_in));
	
	Reg #(12)	AR (
		.clk		(clk),
		.in			(Bus[11:0]),
		.Load		(LD_AR),
		.Increment	(INR_AR),
		.Clear		(CLR_AR | reset),
		.out		(AR_out));
		
	Reg #(12)	PC (
		.clk		(clk),
		.in			(Bus[11:0]),
		.Load		(LD_PC),
		.Increment	(INR_PC),
		.Clear		(CLR_PC | reset),
		.out		(PC_out));
	
	Reg #(16)	DR (
		.clk		(clk),
		.in			(Bus),
		.Load		(LD_DR),
		.Increment	(INR_DR),
		.Clear		(CLR_DR | reset),
		.out		(DR_out));

	Reg #(16)	AC (
		.clk		(clk),
		.in			(AC_in),
		.Load		(LD_AC),
		.Increment	(INR_AC),
		.Clear		(CLR_AC | reset),
		.out		(AC_out));
	
	Reg #(16)	IR (
		.clk		(clk),
		.in			(Bus),
		.Load		(LD_IR),
		.Increment	(1'b0),
		.Clear		(reset),
		.out		(IR_out));
		
	Reg #(16)	INPR (
		.clk		(clk),
		.in			(INPR_in),
		.Load		(1'b1),
		.Increment	(1'b0),
		.Clear		(reset),
		.out		(INPR_out));
	assign INPR_in = INPR_Register;
	
	Reg #(16)	OUTR (
		.clk		(clk),
		.in			(Bus),
		.Load		(LD_OUTR),
		.Increment	(1'b0),
		.Clear		(reset),
		.out		(OUTR_out));
	assign OUTR_Register = OUTR_out;
endmodule
