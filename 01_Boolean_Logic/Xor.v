`default_nettype none

module Xor(
	input a,
	input b,
	output out
);

	wire not_a, not_b, a_and_not_b, not_a_and_b;
	not(not_a, a);
	not(not_b, b);
	and(a_and_not_b, a, not_b);
	and(not_a_and_b, not_a, b);
	or(out, a_and_not_b, not_a_and_b);

endmodule
