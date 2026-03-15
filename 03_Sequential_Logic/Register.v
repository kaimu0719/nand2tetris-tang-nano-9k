`default_nettype none

module Register(
  input clk,
  input [15:0] in,
  input load,
  output [15:0] out
);

  Bit BIT0 (.clk(clk), .in(in[0]), .load(load), .out(out[0]));
  Bit BIT1 (.clk(clk), .in(in[1]), .load(load), .out(out[1]));
  Bit BIT2 (.clk(clk), .in(in[2]), .load(load), .out(out[2]));
  Bit BIT3 (.clk(clk), .in(in[3]), .load(load), .out(out[3]));
  Bit BIT4 (.clk(clk), .in(in[4]), .load(load), .out(out[4]));
  Bit BIT5 (.clk(clk), .in(in[5]), .load(load), .out(out[5]));
  Bit BIT6 (.clk(clk), .in(in[6]), .load(load), .out(out[6]));
  Bit BIT7 (.clk(clk), .in(in[7]), .load(load), .out(out[7]));
  Bit BIT8 (.clk(clk), .in(in[8]), .load(load), .out(out[8]));
  Bit BIT9 (.clk(clk), .in(in[9]), .load(load), .out(out[9]));
  Bit BIT10(.clk(clk), .in(in[10]), .load(load), .out(out[10]));
  Bit BIT11(.clk(clk), .in(in[11]), .load(load), .out(out[11]));
  Bit BIT12(.clk(clk), .in(in[12]), .load(load), .out(out[12]));
  Bit BIT13(.clk(clk), .in(in[13]), .load(load), .out(out[13]));
  Bit BIT14(.clk(clk), .in(in[14]), .load(load), .out(out[14]));
  Bit BIT15(.clk(clk), .in(in[15]), .load(load), .out(out[15]));

endmodule
