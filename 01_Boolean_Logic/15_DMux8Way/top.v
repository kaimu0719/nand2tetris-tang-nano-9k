`default_nettype none

`include "../DMux8Way.v"

module top(
  input clk,
  output [5:0] led
);

  reg [2:0]  sel = 0;
  reg [23:0] cnt = 0;
  always @(posedge clk) begin
      cnt <= cnt + 1;
      if (cnt == 0) sel <= sel + 1;
  end

  wire a, b, c, d, e, f, g, h;
  DMux8Way DMUX8WAY(
    .in(1'b1),
    .sel(sel),
    .a(a), .b(b), .c(c), .d(d),
    .e(e), .f(f), .g(g), .h(h)
  );

  assign led[0] = ~a;
  assign led[1] = ~b;
  assign led[2] = ~c;
  assign led[3] = ~d;
  assign led[4] = ~e;
  assign led[5] = ~f;

endmodule
