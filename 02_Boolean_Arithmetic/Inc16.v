`default_nettype none

module Inc16(
	input [15:0] in,
	output [15:0] out
);

	Add16 ADD16(.a(in), .b(16'h0001), .out(out));

endmodule
