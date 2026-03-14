`default_nettype none

module HackDFF(
	input clk,
	input d,
	output reg q = 1'b0
);

	always @(posedge clk) q <= d;

endmodule
