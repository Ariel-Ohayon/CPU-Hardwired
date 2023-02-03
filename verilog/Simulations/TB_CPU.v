`timescale 100ps/10ps
// 100[ps] = 0.1[ns]

module TB_CPU();

	reg				T_reset;
	reg				T_clk;
	reg		[15:0]	T_INPR_Register;
	wire	[15:0]	T_OUTR_Register;
	
	CPU	DUT (
		.reset			(T_reset),
		.clk			(T_clk),
		.INPR_Register	(T_INPR_Register),
		.OUTR_Register	(T_OUTR_Register));
		
	always
	begin
		T_clk = 1'b1;
		#1;
		T_clk = 1'b0;
		#1;
	end
		
	initial
	begin
		T_INPR_Register = 16'd0;
		T_reset = 1'b1;
		#2.2;
		T_reset = 1'b0;
		#25.8;
	end
endmodule

// run 2.8ns = 2800ps
