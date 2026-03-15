`default_nettype none

module RAM8K(
    input clk,
    input [15:0] in,
    input load,
    input [12:0] address,
    output [15:0] out
);

  reg [15:0] ram [8191:0];

  always @(posedge clk) begin
    if (load) ram[address] <= in;
  end

  assign out = ram[address];

endmodule
