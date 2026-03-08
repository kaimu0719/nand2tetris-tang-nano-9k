`default_nettype none

`include "../Mux8Way16.v"

module top(
  input clk,
  input btn1,
  input btn2,
  output [5:0] led
);

  reg [2:0]  sel = 0;
  reg [23:0] cnt = 0;
  always @(posedge clk) begin
      cnt <= cnt + 1;
      if (cnt == 0) sel <= sel + 1;
  end

  wire [15:0] out;
  Mux8Way16 MUX8WAY16(
    .a(16'b0000_0000_0000_0001),
    .b(16'b0000_0000_0000_0011),
    .c(16'b0000_0000_0000_0111),
    .d(16'b0000_0000_0000_1111),
    .e(16'b0000_0000_0001_1111),
    .f(16'b0000_0000_0011_1111),
    .g(16'b0000_0000_0010_1010),
    .h(16'b0000_0000_0001_0101),
    .sel(sel),
    .out(out)
  );
  assign led = ~out[5:0];

endmodule
