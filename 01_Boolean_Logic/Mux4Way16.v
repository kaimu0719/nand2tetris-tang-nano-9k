`default_nettype none

module Mux4Way16(
	input [15:0] a,
	input [15:0] b,
	input [15:0] c,
	input [15:0] d,
	input [1:0] sel,
	output [15:0] out
);

	wire [15:0] ab, cd;
	Mux16 MUX_AB(.a(a), .b(b), .sel(sel[0]), .out(ab));
	Mux16 MUX_CD(.a(c), .b(d), .sel(sel[0]), .out(cd));
	Mux16 MUX_OUT(.a(ab), .b(cd), .sel(sel[1]), .out(out));

endmodule
