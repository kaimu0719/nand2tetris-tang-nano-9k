`default_nettype none

module top(
  output [5:0] led
);

  reg [15:0] a = 16'b0000_0000_0001_1111;
  reg [15:0] b = 16'b0000_0000_0001_0010;
  wire zr, ng;
  wire [15:0] out;

  // zx = 1, nx = 0, zy = 1, ny = 0, f = 1, no = 0: out = 0
  HackALU ALU(.x(a), .y(b), .zx(1'b1), .nx(1'b0), .zy(1'b1), .ny(1'b0), .f(1'b1), .no(1'b0), .out(out), .zr(zr), .ng(ng));

  // zx = 1, nx = 1, zy = 1, ny = 1, f = 1, no = 1: out = 1
  // HackALU ALU(.x(a), .y(b), .zx(1'b1), .nx(1'b1), .zy(1'b1), .ny(1'b1), .f(1'b1), .no(1'b1), .out(out), .zr(zr), .ng(ng));

  // zx = 1, nx = 1, zy = 1, ny = 0, f = 1 no = 0: out = -1
  // HackALU ALU(.x(a), .y(b), .zx(1'b1), .nx(1'b1), .zy(1'b1), .ny(1'b0), .f(1'b1), .no(1'b0), .out(out), .zr(zr), .ng(ng));

  // zx = 0, nx = 0, zy = 1, ny = 1, f = 0 no = 0: out = x
  // HackALU ALU(.x(a), .y(b), .zx(1'b0), .nx(1'b0), .zy(1'b1), .ny(1'b1), .f(1'b0), .no(1'b0), .out(out), .zr(zr), .ng(ng));

  // zx = 1, nx = 1, zy = 0, ny = 0, f = 0 no = 0: out = y
  // HackALU ALU(.x(a), .y(b), .zx(1'b1), .nx(1'b1), .zy(1'b0), .ny(1'b0), .f(1'b0), .no(1'b0), .out(out), .zr(zr), .ng(ng));

  // zx = 0, nx = 0, zy = 1, ny = 1, f = 0 no = 1: out = !x
  // HackALU ALU(.x(a), .y(b), .zx(1'b0), .nx(1'b0), .zy(1'b1), .ny(1'b1), .f(1'b0), .no(1'b1), .out(out), .zr(zr), .ng(ng));

  // zx = 1, nx = 1, zy = 0, ny = 0, f = 0 no = 1: out = !y
  // HackALU ALU(.x(a), .y(b), .zx(1'b1), .nx(1'b1), .zy(1'b0), .ny(1'b0), .f(1'b0), .no(1'b1), .out(out), .zr(zr), .ng(ng));

  // zx = 0, nx = 0, zy = 1, ny = 1, f = 1 no = 1: out = -x
  // HackALU ALU(.x(a), .y(b), .zx(1'b0), .nx(1'b0), .zy(1'b1), .ny(1'b1), .f(1'b1), .no(1'b1), .out(out), .zr(zr), .ng(ng));

  // zx = 1, nx = 1, zy = 0, ny = 0, f = 1 no = 1: out = -y
  // HackALU ALU(.x(a), .y(b), .zx(1'b1), .nx(1'b1), .zy(1'b0), .ny(1'b0), .f(1'b1), .no(1'b1), .out(out), .zr(zr), .ng(ng));

  // zx = 0, nx = 1, zy = 1, ny = 1, f = 1 no = 1: out = x+1
  // HackALU ALU(.x(a), .y(b), .zx(1'b0), .nx(1'b1), .zy(1'b1), .ny(1'b1), .f(1'b1), .no(1'b1), .out(out), .zr(zr), .ng(ng));

  // zx = 1, nx = 1, zy = 0, ny = 1, f = 1 no = 1: out = y+1
  // HackALU ALU(.x(a), .y(b), .zx(1'b1), .nx(1'b1), .zy(1'b0), .ny(1'b1), .f(1'b1), .no(1'b1), .out(out), .zr(zr), .ng(ng));

  // zx = 0, nx = 0, zy = 1, ny = 1, f = 1 no = 0: out = x-1
  // HackALU ALU(.x(a), .y(b), .zx(1'b0), .nx(1'b0), .zy(1'b1), .ny(1'b1), .f(1'b1), .no(1'b0), .out(out), .zr(zr), .ng(ng));

  // zx = 1, nx = 1, zy = 0, ny = 0, f = 1 no = 0: out = y-1
  // HackALU ALU(.x(a), .y(b), .zx(1'b1), .nx(1'b1), .zy(1'b0), .ny(1'b0), .f(1'b1), .no(1'b0), .out(out), .zr(zr), .ng(ng));

  // zx = 0, nx = 0, zy = 0, ny = 0, f = 1 no = 0: out = x+y
  // HackALU ALU(.x(a), .y(b), .zx(1'b0), .nx(1'b0), .zy(1'b0), .ny(1'b0), .f(1'b1), .no(1'b0), .out(out), .zr(zr), .ng(ng));

  // zx = 0, nx = 1, zy = 0, ny = 0, f = 1 no = 1: out = x-y
  // HackALU ALU(.x(a), .y(b), .zx(1'b0), .nx(1'b1), .zy(1'b0), .ny(1'b0), .f(1'b1), .no(1'b1), .out(out), .zr(zr), .ng(ng));

  // zx = 0, nx = 0, zy = 0, ny = 1, f = 1 no = 1: out = y-x
  // HackALU ALU(.x(a), .y(b), .zx(1'b0), .nx(1'b0), .zy(1'b0), .ny(1'b1), .f(1'b1), .no(1'b1), .out(out), .zr(zr), .ng(ng));

  // zx = 0, nx = 0, zy = 0, ny = 0, f = 0 no = 0: out = x&y
  // HackALU ALU(.x(a), .y(b), .zx(1'b0), .nx(1'b0), .zy(1'b0), .ny(1'b0), .f(1'b0), .no(1'b0), .out(out), .zr(zr), .ng(ng));

  // zx = 0, nx = 1, zy = 0, ny = 1, f = 0 no = 1: out = x|y
  // HackALU ALU(.x(a), .y(b), .zx(1'b0), .nx(1'b1), .zy(1'b0), .ny(1'b1), .f(1'b0), .no(1'b1), .out(out), .zr(zr), .ng(ng));

  assign led = ~out[5:0];

  // assign led[3:0] = ~1'b0;
  // assign led[4] = ~ng;
  // assign led[5] = ~zr;

endmodule
