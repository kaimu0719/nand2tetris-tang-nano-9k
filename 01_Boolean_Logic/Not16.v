`default_nettype none

module Not16(
	input  [15:0] in,
	output [15:0] out
);

  not(out[0], in[0]);
  not(out[1], in[1]);
  not(out[2], in[2]);
  not(out[3], in[3]);
  not(out[4], in[4]);
  not(out[5], in[5]);
  not(out[6], in[6]);
  not(out[7], in[7]);
  not(out[8], in[8]);
  not(out[9], in[9]);
  not(out[10], in[10]);
  not(out[11], in[11]);
  not(out[12], in[12]);
  not(out[13], in[13]);
  not(out[14], in[14]);
  not(out[15], in[15]);

endmodule
