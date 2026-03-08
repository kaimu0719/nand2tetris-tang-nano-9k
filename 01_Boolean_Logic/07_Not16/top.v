`default_nettype none

`include "../Not16.v"

module top(
    input clk,
    output [5:0] led
);

  wire [15:0] out;
  Not16 NOT16(.in(16'b0000_0000_0011_1111), .out(out));
  // Not16 NOT16(.in(16'b0000_0000_0000_0000), .out(out));
  assign led = ~out[5:0];

endmodule
