`default_nettype none

module DMux(
	input  in,
	input  sel,
	output a,
	output b
);

	wire not_sel;
	not(not_sel, sel);
	and(a, in, not_sel);
	and(b, in, sel);

endmodule