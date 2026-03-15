`default_nettype none

module top(
  input clk,
  input btn1,
  input btn2,
  output [5:0] led
);

  wire [15:0] in = ~btn1 ? 16'b0000_0000_0001_0101 
                         : 16'b0000_0000_0000_0000;

  wire [15:0] out;
  Register register(.clk(clk), .in(in), .load(~btn2), .out(out));

  assign led = ~out[5:0];

endmodule
