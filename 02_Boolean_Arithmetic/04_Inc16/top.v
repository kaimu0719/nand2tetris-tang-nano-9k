`default_nettype none

module top(
    output [5:0] led
);

  reg [15:0] in = 16'b0000_0000_0000_0001;
  wire [15:0] out;

  Inc16 inc(.in(in), .out(out));

  assign led = ~out[5:0];

endmodule
