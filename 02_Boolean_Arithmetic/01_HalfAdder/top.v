`default_nettype none

module top(
    input btn1,
    input btn2,
    output [1:0] led
);

wire sum, carry;

HalfAdder HA(.a(~btn1), .b(~btn2), .sum(sum), .carry(carry));

assign led[0] = ~sum;
assign led[1] = ~carry;

endmodule
