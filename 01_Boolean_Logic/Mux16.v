`ifndef MUX16_V
`define MUX16_V
`default_nettype none

`include "Mux.v"

module Mux16(
	input [15:0] a,
	input [15:0] b,
	input sel,
	output [15:0] out
);

  Mux MUX_0(.a(a[0]), .b(b[0]), .sel(sel), .out(out[0]));
  Mux MUX_1(.a(a[1]), .b(b[1]), .sel(sel), .out(out[1]));
  Mux MUX_2(.a(a[2]), .b(b[2]), .sel(sel), .out(out[2]));
  Mux MUX_3(.a(a[3]), .b(b[3]), .sel(sel), .out(out[3]));
  Mux MUX_4(.a(a[4]), .b(b[4]), .sel(sel), .out(out[4]));
  Mux MUX_5(.a(a[5]), .b(b[5]), .sel(sel), .out(out[5]));
  Mux MUX_6(.a(a[6]), .b(b[6]), .sel(sel), .out(out[6]));
  Mux MUX_7(.a(a[7]), .b(b[7]), .sel(sel), .out(out[7]));
  Mux MUX_8(.a(a[8]), .b(b[8]), .sel(sel), .out(out[8]));
  Mux MUX_9(.a(a[9]), .b(b[9]), .sel(sel), .out(out[9]));
  Mux MUX_10(.a(a[10]), .b(b[10]), .sel(sel), .out(out[10]));
  Mux MUX_11(.a(a[11]), .b(b[11]), .sel(sel), .out(out[11]));
  Mux MUX_12(.a(a[12]), .b(b[12]), .sel(sel), .out(out[12]));
  Mux MUX_13(.a(a[13]), .b(b[13]), .sel(sel), .out(out[13]));
  Mux MUX_14(.a(a[14]), .b(b[14]), .sel(sel), .out(out[14]));
  Mux MUX_15(.a(a[15]), .b(b[15]), .sel(sel), .out(out[15]));

endmodule
`endif
