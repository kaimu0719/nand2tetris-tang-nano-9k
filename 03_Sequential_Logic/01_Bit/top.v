`default_nettype none

module top(
  input clk,
  input btn1,
  input btn2,
  output led
);

  wire q;
  Bit bit(.clk(clk), .in(~btn1), .load(~btn2), .out(q));
  assign led = ~q;

endmodule
