`default_nettype none

module RAM16K(
    input clk,
    input [15:0] in,
    input load,
    input [13:0] address,
    output [15:0] out
);

  reg [15:0] ram [16383:0];

  always @(posedge clk) begin
    if (load) ram[address] <= in;
  end

  assign out = ram[address];

endmodule
