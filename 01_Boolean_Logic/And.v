`default_nettype none

module And(
	input a,
	input b,
	output out
);

	wire nand_out;
	nand(nand_out, a, b);
	not(out, nand_out);

endmodule
