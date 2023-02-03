module MuxBus #(parameter Bits = 16) (
	input		[2:0]		selector,

	input		[11:0]		ar,
	input		[11:0]		pc,

	input		[Bits-1:0]	dr,
	input		[Bits-1:0]	ac,
	input		[Bits-1:0]	ir,
	input		[Bits-1:0]	tr,
	input		[Bits-1:0]	mem,

	output reg	[Bits-1:0]	Bus);

	always @(selector, ar,pc,dr,ac,ir,tr,mem)
	begin
		case(selector)
			3'd0:   Bus = 0;
			3'd1:	Bus = ar;
			3'd2:	Bus = pc;
			3'd3:	Bus = dr;
			3'd4:	Bus = ac;
			3'd5:	Bus = ir;
			3'd6:	Bus = tr;
			3'd7:	Bus = mem;
		endcase
	end
endmodule
