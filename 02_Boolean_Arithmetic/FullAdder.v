`default_nettype none

module FullAdder(
	input  a,
	input  b,
	input  c,
	output sum,
	output carry
);

	wire sum1, carry1, carry2;
	HalfAdder HA1(.a(a),    .b(b), .sum(sum1), .carry(carry1));
	HalfAdder HA2(.a(sum1), .b(c), .sum(sum),  .carry(carry2));
	or(carry, carry1, carry2);

endmodule
