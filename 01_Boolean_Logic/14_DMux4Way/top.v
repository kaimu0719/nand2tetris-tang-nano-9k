`default_nettype none

module top(
    input clk,
    input btn1,
    input btn2,
    output [3:0] led
);

  wire a, b, c, d;
  DMux4Way DMUX4WAY(
    .in(1'b1),
    .sel({~btn2, ~btn1}),
    .a(a), .b(b), .c(c), .d(d)
  );
  assign led[0] = ~a;
  assign led[1] = ~b;
  assign led[2] = ~c;
  assign led[3] = ~d;

endmodule
