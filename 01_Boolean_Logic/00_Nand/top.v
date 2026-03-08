`default_nettype none

`include "../Nand.v"

module top(
  input clk,
  input btn1,
  input btn2,
  output led
);

wire out;
Nand NAND(.a(~btn1), .b(~btn2), .out(out));
assign led = ~out;

endmodule
