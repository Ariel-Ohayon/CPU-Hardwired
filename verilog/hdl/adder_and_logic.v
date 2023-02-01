module Single_Stage_Add_Logic (
	input	clk,
	input	dr,
	input	ld,
	input	logic_and,
	input	arith_add,
	input	dr_instr,
	input	inpr,
	input	inp,
	input	com,
	input	shr,
	input	shl,
	input	nac,
	input	pac,
	input	ci,

	output	ac,
	output	co);
	
	wire		sum;
	wire		j,k;

	wire	[6:0]	and_gate;
	reg		or_gate;

	integer i;

	assign and_gate[0] = logic_and & ac & dr;
	assign and_gate[1] = arith_add & sum;
	assign and_gate[2] = dr_instr  & dr;
	assign and_gate[3] = inpr      & inp;
	assign and_gate[4] = com       & ~ac;
	assign and_gate[5] = shr       & nac;
	assign and_gate[6] = shl       & pac;

	//assign or_gate = and_gate[0] | and_gate[1] | and_gate[2] |
	//		 and_gate[3] | and_gate[4] | and_gate[5] |
	//		 and_gate[6];

	always @(and_gate)
	begin
		or_gate = 1'b0;
		for (i = 0; i < 7; i = i + 1)
		begin
			or_gate = and_gate[i] | or_gate;
		end
	end

	assign j = ld &   or_gate;
	assign k = ld & (~or_gate);
	
	jk_ff		U1 (
		.clk	(clk),
		.j	(j),
		.k	(k),
		.Q	(ac));

	Full_Adder	U2(
		.A	(ac),
		.B	(dr),
		.Cin	(ci),
		.Sum	(sum),
		.Cout	(co));
	
endmodule


module Full_Adder (
	input	A,B,Cin,
	output	Sum,Cout);
	
	assign Sum  = A^B^Cin;
	assign Cout = (A & B) | (A & Cin) | (B & Cin);
	
endmodule

module jk_ff (
	input		clk,
	input		j,k,
	output reg	Q);
	always @(posedge clk)
	begin
		if (j)		//j = '1'
		begin
			if (k)	//k = '1'  -  complement
				Q <= ~Q;
			else	//k = '0'  -  set
				Q <= 1'b1;
		end
		else		//j = '0'
		begin
			if (k)	//k = '1'  -  reset
				Q <= 1'b0;
		end
	end
endmodule


module adder_and_logic #(parameter n = 4) (
	input					clk,
	input		[n-1:0]	AC,
	input		[n-1:0]	DR,
	input		[n-1:0]	INP,
	input		[7:0]		ControlSig,
	input					Eout_ff,
	output				Ein_ff,
	output	[n-1:0]	out);
	
	genvar i;
	
	wire		logic_and;
	wire		arith_add;
	wire		dr;
	wire		inpr;
	wire		com;
	wire		shr;
	wire		shl;
	
	wire		ld;
	
	wire	[n+1:0]	carry;
	
	wire	[n:0]	result;
	
	assign result = {Eout_ff,AC};
	
	assign logic_and = ControlSig[0];
	assign arith_add = ControlSig[1];
	assign dr		  = ControlSig[2];
	assign inpr		  = ControlSig[3];
	assign com		  = ControlSig[4];
	assign shr		  = ControlSig[5];
	assign shl		  = ControlSig[6];
	assign ld		  = ControlSig[7];

	generate
		for (i = 1; i < n; i = i + 1)
		begin: Multi_Stage
			Single_Stage_Add_Logic Ui (
				.clk			(clk),
				.dr			(DR[i]),
				.ld			(ld),
				.logic_and	(logic_and),
				.arith_add	(arith_add),
				.dr_instr	(dr),
				.inpr			(inpr),
				.inp			(INP[i]),
				.com			(com),
				.shr			(shr),
				.shl			(shl),
				.nac			(result[i]),
				.pac			(result[i-1]),
				.ci			(carry[i]),
		
				.ac			(out[i-1]),
				.co			(carry[i+1]));
		end
	endgenerate
	
	Single_Stage_Add_Logic Un (
				.clk			(clk),
				.dr			(DR[n-1]),
				.ld			(ld),
				.logic_and	(logic_and),
				.arith_add	(arith_add),
				.dr_instr	(dr),
				.inpr			(inpr),
				.inp			(INP[n-1]),
				.com			(com),
				.shr			(shr),
				.shl			(shl),
				.nac			(result[n]),
				.pac			(result[n-1]),
				.ci			(carry[n]),
		
				.ac			(out[n-1]),
				.co			(carry[n+1]));

endmodule