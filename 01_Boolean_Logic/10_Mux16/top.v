`default_nettype none

`include "../Mux16.v"

module top(
    input clk,
    input btn1,
    output [5:0] led
);

  wire [15:0] out;
  Mux16 MUX16(.a(16'b0000_0000_0010_1010), .b(16'b0000_0000_0001_0101), .sel(btn1), .out(out));
  assign led = ~out[5:0];

endmodule
