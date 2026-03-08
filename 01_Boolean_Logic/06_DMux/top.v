`default_nettype none

`include "../DMux.v"

module top(
    input clk,
    input btn1,
    input btn2,
    output [1:0] led
);

wire a_out, b_out;
DMux DMUX(.in(~btn1), .sel(~btn2), .a(a_out), .b(b_out));

assign led[0] = ~a_out;
assign led[1] = ~b_out;

endmodule
