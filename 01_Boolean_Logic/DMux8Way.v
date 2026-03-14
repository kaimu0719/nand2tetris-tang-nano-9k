`default_nettype none

module DMux8Way(
	input in,
	input [2:0] sel,
	output a,
	output b,
	output c,
	output d,
	output e,
	output f,
	output g,
	output h
);

	wire a_to_d, e_to_h;
	DMux DMUX_HIGH(.in(in), .sel(sel[2]), .a(a_to_d), .b(e_to_h));
	DMux4Way DMUX_LOW0(.in(a_to_d), .sel(sel[1:0]), .a(a), .b(b), .c(c), .d(d));
	DMux4Way DMUX_LOW1(.in(e_to_h), .sel(sel[1:0]), .a(e), .b(f), .c(g), .d(h));

endmodule
