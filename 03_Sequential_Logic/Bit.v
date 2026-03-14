`default_nettype none

module Bit(
    input clk,
    input in,
    input load,
    output out
);

    wire mux_out;
    Mux MUX(.a(out), .b(in), .sel(load), .out(mux_out));
    HackDFF DFF(.clk(clk), .d(mux_out), .q(out));

endmodule
