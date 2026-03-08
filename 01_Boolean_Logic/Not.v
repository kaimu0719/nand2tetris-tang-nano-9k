`default_nettype none

module Not(
	input in,
	output out
);

  nand(out, in, in);
endmodule
