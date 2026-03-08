`default_nettype none

module Or(
	input a,
	input b,
	output out
);

	wire not_a, not_b;
	not(not_a, a);
	not(not_b, b);
	nand(out, not_a, not_b);

endmodule
