`default_nettype none

module top(
  input clk,
  input btn1,
  input btn2,
  output led
);

wire out;
And AND(.a(~btn1), .b(~btn2), .out(out));
assign led = ~out;

endmodule
