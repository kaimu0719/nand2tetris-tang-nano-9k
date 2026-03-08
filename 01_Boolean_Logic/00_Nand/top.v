`default_nettype none

`include "../Nand.v"

module top(
  input clk,
  input btn1,
  input btn2,
  output [5:0] led
);

wire out;
Nand NAND(.a(~btn1), .b(~btn2), .out(out));
assign led[0] = ~out;
assign led[5:1] = 5'b11111;

endmodule
