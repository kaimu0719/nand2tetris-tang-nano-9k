`ifndef DMUX4WAY_V
`define DMUX4WAY_V
`default_nettype none

`include "DMux.v"

module DMux4Way(
	input in,
	input [1:0] sel,
	output a,
	output b,
	output c,
	output d
);

	wire a_or_b, c_or_d;
	DMux DMUX_HIGH(.in(in), .sel(sel[1]), .a(a_or_b), .b(c_or_d));
	DMux DMUX_LOW0(.in(a_or_b), .sel(sel[0]), .a(a), .b(b));
	DMux DMUX_LOW1(.in(c_or_d), .sel(sel[0]), .a(c), .b(d));

endmodule
`endif
