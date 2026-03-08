`default_nettype none

module Or8Way(
	input  [7:0] in,
	output out
);

	wire or01, or23, or45, or67, or0123, or4567;
	or(or01, in[0], in[1]);
	or(or23, in[2], in[3]);
	or(or45, in[4], in[5]);
	or(or67, in[6], in[7]);
	or(or0123, or01, or23);
	or(or4567, or45, or67);
	or(out, or0123, or4567);

endmodule
