`default_nettype none

module top(
    input clk,
    input btn1,
    input btn2,
    output [5:0] led
);

  reg [15:0] a = 16'd0;
  reg [15:0] b = 16'd0;
  wire [15:0] out;

  reg btn1_prev = 1'b1;
  reg btn2_prev = 1'b1;

  Add16 adder(.a(a), .b(b), .out(out));

  always @(posedge clk) begin
    btn1_prev <= btn1;
    btn2_prev <= btn2;

    if (btn1_prev && !btn1) a <= a + 1;
    if (btn2_prev && !btn2) b <= b + 2;
  end

  assign led = ~out[5:0];

endmodule
