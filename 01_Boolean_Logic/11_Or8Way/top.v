`default_nettype none

`include "../Or8Way.v"

module top(
    input clk,
    output led
);

  wire out;
  // Or8Way OR8WAY(.in(8'b0000_0001), .out(out));
  Or8Way OR8WAY(.in(8'b0000_0000), .out(out));
  assign led = ~out;

endmodule
