`default_nettype none

`include "../And16.v"

module top(
    input clk,
    output [5:0] led
);

  wire [15:0] out;
  And16 AND16(.a(16'b0000_0000_0011_1111), .b(16'b0000_0000_0000_1111), .out(out));
  // And16 AND16(.a(16'b0000_0000_0011_1111), .b(16'b0000_0000_0000_0000), .out(out));
  assign led = ~out[5:0];

endmodule
