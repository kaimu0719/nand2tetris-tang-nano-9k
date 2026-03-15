`default_nettype none

module PC(
    input clk,
    input [15:0] in,
    input load,
    input inc,
    input reset,
    output [15:0] out
);

    wire [15:0] inc_out, after_inc, after_load, after_reset;

    Inc16 INC16(.in(out), .out(inc_out));
    Mux16 MUX_INC(.a(out), .b(inc_out), .sel(inc), .out(after_inc));
    Mux16 MUX_LOAD(.a(after_inc), .b(in), .sel(load), .out(after_load));
    Mux16 MUX_RST(.a(after_load), .b(16'h0000), .sel(reset), .out(after_reset));
    Register REG(.clk(clk), .in(after_reset), .load(1'b1), .out(out));

endmodule
