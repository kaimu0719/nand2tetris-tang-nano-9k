`default_nettype none

module top(
  input clk,
  input btn1,
  output led
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

  wire q;
  HackDFF dff(.clk(slow_clk), .d(~btn1), .q(q));
  assign led = ~q;

endmodule
