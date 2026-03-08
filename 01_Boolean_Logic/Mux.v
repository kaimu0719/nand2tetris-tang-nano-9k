`default_nettype none

module Mux(
	input a,
	input b,
	input sel,
	output out
);

	wire not_sel, a_and_not_sel, b_and_sel;
	not(not_sel, sel);
	and(a_and_not_sel, a, not_sel);
	and(b_and_sel, b, sel);
	or(out, a_and_not_sel, b_and_sel);

endmodule
