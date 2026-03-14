`default_nettype none

module HackALU(
	input [15:0] x,
	input [15:0] y,
	input zx,
	input nx,
	input zy,
	input ny,
	input f,
	input no,
	output [15:0] out,
	output zr,
	output ng
);

	// if zx then x = 0
	wire [15:0] x1;
	Mux16 MUX_ZX(.a(x), .b(16'h0000), .sel(zx), .out(x1));

	// if nx then x = !x
	wire [15:0] not_x1, x2;
	Not16 NOT_X(.in(x1), .out(not_x1));
	Mux16 MUX_NX(.a(x1), .b(not_x1), .sel(nx), .out(x2));

	// if zy then y = 0
	wire [15:0] y1;
	Mux16 MUX_ZY(.a(y), .b(16'h0000), .sel(zy), .out(y1));

	// if ny then y = !y
	wire [15:0] not_y1, y2;
	Not16 NOT_Y(.in(y1), .out(not_y1));
	Mux16 MUX_NY(.a(y1), .b(not_y1), .sel(ny), .out(y2));

	// if f then out = x+y else out = x&y
	wire [15:0] and_out, add_out, f_out;
	And16 AND16(.a(x2), .b(y2), .out(and_out));
	Add16 ADD16(.a(x2), .b(y2), .out(add_out));
	Mux16 MUX_F(.a(and_out), .b(add_out), .sel(f), .out(f_out));

	// if no then out = !out
	wire [15:0] not_f_out;
	Not16 NOT_OUT(.in(f_out), .out(not_f_out));
	Mux16 MUX_NO(.a(f_out), .b(not_f_out), .sel(no), .out(out));

	// zr: out == 0
	wire or_lower, or_upper, or_all;
	Or8Way OR_LOWER(.in(out[7:0]),  .out(or_lower));
	Or8Way OR_UPPER(.in(out[15:8]), .out(or_upper));
	or(or_all, or_lower, or_upper);
	not(zr, or_all);

	// ng: out < 0
	assign ng = out[15];

endmodule
