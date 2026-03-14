`default_nettype none

module top(
    input clk,
    input btn1,
    output led
);

wire out;
Not NOT(.in(~btn1), .out(out));
assign led = ~out;
endmodule
