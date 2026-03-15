`default_nettype none

module top(
  input clk,
  input btn1,
  input btn2,
  output [5:0] led
);

  reg [23:0] counter = 0;
  reg slow_clk = 0;

  always @(posedge clk) begin
    if (counter == 24'd13_500_000) begin
      counter <= 0;
      slow_clk <= ~slow_clk;
    end else begin
      counter <= counter + 1;
    end
  end

  wire [15:0] out;

  PC pc(
    .clk(slow_clk),
    .in(16'd10),
    .load(~btn2),
    .inc(1'b1),
    .reset(~btn1),
    .out(out)
  );

  assign led = ~out[5:0];

endmodule