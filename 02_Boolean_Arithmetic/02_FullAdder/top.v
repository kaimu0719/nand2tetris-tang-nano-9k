`default_nettype none

module top(
  input btn1,
  input btn2,
  output [1:0] led
);

  wire sum, carry;
  // FullAdder FA(.a(~btn1), .b(~btn2), .c(1'b0), .sum(sum), .carry(carry));
  FullAdder FA2(.a(~btn1), .b(~btn2), .c(1'b1), .sum(sum), .carry(carry));
  assign led[0] = ~sum;
  assign led[1] = ~carry;

endmodule
