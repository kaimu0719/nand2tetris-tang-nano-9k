`timescale 10ns/1ns
`default_nettype none

module Computer_tb();

  // -------------------------------------------------------
  // Clock & Reset
  // -------------------------------------------------------
  reg clk   = 0;
  reg reset = 0;
  always #0.5 clk = ~clk;

  // -------------------------------------------------------
  // I/O bus (driven by Computer, handled externally here)
  // -------------------------------------------------------
  wire        io_load;   // Computer → write enable
  wire [3:0]  io_addr;   // Computer → device index
  wire [15:0] io_out;    // Computer → write data

  reg  [15:0] io_in = 0; // external devices → Computer (combinational)

  // -------------------------------------------------------
  // External I/O devices
  // -------------------------------------------------------
  reg [1:0] buttons = 2'b01; // BUT: bit0=1(released), bit1=0
  reg [1:0] led_reg = 0;     // LED register (written by CPU)

  // io_in: combinational MUX of device outputs
  always @(*) begin
    case (io_addr)
      4'h0: io_in = {14'b0, led_reg}; // LED readback
      4'h1: io_in = {14'b0, buttons}; // BUT
      default: io_in = 16'h0000;
    endcase
  end

  // Capture LED writes from CPU
  always @(posedge clk) begin
    if (io_load && io_addr == 4'h0)
      led_reg <= io_out[1:0];
  end

  // -------------------------------------------------------
  // Computer instance (ROM loaded from ROM.hack)
  // -------------------------------------------------------
  Computer #(.ROM_FILE("ROM.hack")) HACK (
    .clk(clk),
    .reset(reset),
    .io_load(io_load),
    .io_addr(io_addr),
    .io_out(io_out),
    .io_in(io_in),
    .keyboard(16'h0000),
    .screen_raddr(13'b0),
    .screen_rdata()
  );

  // -------------------------------------------------------
  // Cycle counter
  // -------------------------------------------------------
  integer cycle = 0;
  always @(posedge clk) cycle = cycle + 1;

  // -------------------------------------------------------
  // Print I/O events
  // -------------------------------------------------------
  always @(posedge clk) begin
    if (io_load && !reset)
      $display("[cycle %0d] IO[0x%01x] <= %0d", cycle, io_addr, io_out);
  end

  // -------------------------------------------------------
  // Test sequence
  // -------------------------------------------------------
  initial begin
    $dumpfile("Computer_tb.vcd");
    $dumpvars(0, Computer_tb);

    // Reset for 2 cycles
    reset = 1; #2; reset = 0;

    // Run simulation
    #4000;

    $display("=== Results ===");
    $display("LED = %0d (expect: 2=correct, 3=wrong for mult)", led_reg);
    $display("cycles = %0d", cycle);
    $display("===============");
    $finish;
  end

endmodule
