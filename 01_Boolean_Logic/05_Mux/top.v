`default_nettype none

module top(
    input clk,
    input btn1,
    input btn2,
    output led
);

  wire out;
  Mux MUX(.a(~btn1), .b(~btn2), .sel(1'b1), .out(out));
  // Mux MUX(.a(~btn1), .b(~btn2), .sel(1'b0), .out(out));
  assign led = ~out;

endmodule
