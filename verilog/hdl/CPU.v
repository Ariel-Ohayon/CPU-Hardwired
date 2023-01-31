module CPU (
	input	reset,
	input	clk,
	input	Write,
	input Read);
	
	wire	[2:0]		selector;
	
	wire	[11:0]	AR_out;
	wire	[11:0]	PC_out;
	wire	[15:0]	DR_out;
	wire	[15:0]	AC_out;
	wire	[15:0]	IR_out;
	wire	[15:0]	TR_out;
	wire	[15:0]	MEM_out;
	
	wire	LD_AR;
	wire	LD_PC;
	wire	LD_DR;
	wire	LD_AC;
	wire	LD_IR;
	wire	LD_TR;
	
	wire	INC_AR;
	wire	INC_PC;
	wire	INC_DR;
	wire	INC_AC;
	wire	INC_IR;
	wire	INC_TR;
	
	wire	CLR_AR;
	wire	CLR_PC;
	wire	CLR_DR;
	wire	CLR_AC;
	wire	CLR_IR;
	wire	CLR_TR;

	wire [15:0]	Bus;
	
	wire	[7:0]	x;

	MuxBus	U1 (
		.selector	(selector),
		.ar			({4'd0,AR_out}),
		.pc			({4'd0,PC_out}),
		.dr			(DR_out),
		.ac			(AC_out),
		.ir				(IR_out),
		.tr				(TR_out),
		.mem		(MEM_out),
		.Bus			(Bus));
	
	Memory	U2 (
		.clk			(clk),
		.Write		(Write),
		.Read		(Read),
		.address	(AR_out),
		.data_in	(Bus),
		.data_out	(MEM_out));
		
	//ControlUnit	U3 (
	//	
	//);
	
	Encoder	U4 (
		.x				(x),
		.selector	(selector));
	
	Reg #(12)	AR (
		.clk				(clk),
		.in					(Bus),
		.Load			(LD_AR),
		.Increment	(INC_AR),
		.Clear			(CLR_AR),
		.out				(AR_out));
		
	Reg #(12)	PC (
		.clk				(clk),
		.in					(Bus),
		.Load			(LD_AR),
		.Increment	(INC_AR),
		.Clear			(CLR_AR),
		.out				(PC_out));
	
	Reg #(16)	DR (
		.clk				(clk),
		.in					(Bus),
		.Load			(LD_AR),
		.Increment	(INC_AR),
		.Clear			(CLR_AR),
		.out				(DR_out));

	Reg #(16)	AC (
		.clk				(clk),
		.in					(Bus),
		.Load			(LD_AR),
		.Increment	(INC_AR),
		.Clear			(CLR_AR),
		.out				(AC_out));
	
	Reg #(16)	IR (
		.clk				(clk),
		.in					(Bus),
		.Load			(LD_AR),
		.Increment	(INC_AR),
		.Clear			(CLR_AR),
		.out				(IR_out));
	
	Reg #(16)	TR (
		.clk				(clk),
		.in					(Bus),
		.Load			(LD_AR),
		.Increment	(INC_AR),
		.Clear			(CLR_AR),
		.out				(TR_out));
	
endmodule