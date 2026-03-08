`default_nettype none

`include "../Or16.v"

module top(
  input clk,
  output [5:0] led
);

  wire [15:0] out;
  Or16 OR16(.a(16'b0000_0000_0011_1111), .b(16'b0000_0000_0000_1111), .out(out));
  // Or16 OR16(.a(16'b0000_0000_0000_1111), .b(16'b0000_0000_0000_0000), .out(out));
  assign led = ~out[5:0];

endmodule
