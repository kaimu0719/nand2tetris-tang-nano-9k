`default_nettype none

module CPU(
  input clk,
  input [15:0] inM,
  input [15:0] instruction,
  input reset,
  output [15:0] outM,
  output writeM,
  output [14:0] addressM,
  output [14:0] pc
);

  wire is_c = instruction[15];

  // --- A-register ---
  wire [15:0] alu_out;
  wire [15:0] a_in   = is_c ? alu_out : instruction;
  wire a_load = !is_c || (is_c && instruction[5]);
  wire [15:0] a_out;
  Register A_REG(.clk(clk), .in(a_in), .load(a_load), .out(a_out));

  // --- D-register ---
  wire d_load = is_c && instruction[4];
  wire [15:0] d_out;
  Register D_REG(.clk(clk), .in(alu_out), .load(d_load), .out(d_out));

  // --- ALU ---
  // x = D, y = A (bit12=0) or M (bit12=1)
  wire [15:0] alu_y = instruction[12] ? inM : a_out;
  wire zr, ng;
  HackALU ALU(
    .x(d_out), .y(alu_y),
    .zx(instruction[11]), .nx(instruction[10]),
    .zy(instruction[9]), .ny(instruction[8]),
    .f(instruction[7]), .no(instruction[6]),
    .out(alu_out), .zr(zr), .ng(ng)
  );

    // --- Jump logic ---
    // j1=JLT(bit2), j2=JEQ(bit1), j3=JGT(bit0)
    wire positive  = !ng && !zr;
    wire jump = is_c && (
      (instruction[2] & ng) | // JLT: out < 0
      (instruction[1] & zr) | // JEQ: out == 0
      (instruction[0] & positive) // JGT: out > 0
    );

    // --- PC ---
    wire [15:0] pc_out;
    PC PC1(
      .clk(clk),
      .in({1'b0, a_out[14:0]}),
      .load(jump),
      .inc(1'b1),
      .reset(reset),
      .out(pc_out)
    );

    // --- Outputs ---
    assign outM     = alu_out;
    assign writeM   = is_c && instruction[3];  // dest M (bit3)
    assign addressM = a_out[14:0];
    assign pc = pc_out[14:0];

endmodule
