`default_nettype none

module top(
    input clk,
    input btn1,
    input btn2,
    output [5:0] led
);

  wire [15:0] out;
  Mux4Way16 MUX4WAY16(
    .a(16'b0000_0000_0000_0011),
    .b(16'b0000_0000_0000_0110),
    .c(16'b0000_0000_0000_1100),
    .d(16'b0000_0000_0001_1000),
    .sel({~btn2, ~btn1}),
    .out(out)
  );
  assign led = ~out[5:0];

endmodule
