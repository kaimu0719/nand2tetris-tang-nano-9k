/**
 * Hack Computer for Tang Nano 9K:
 *   ROM      : instruction memory (up to 4K instructions)
 *   CPU      : Hack CPU
 *   Memory   : data memory (RAM 4K + Screen 8K, hybrid I/O bus)
 *
 * The computer runs the program stored in ROM.
 * Reset sets PC=0 to restart execution from the beginning.
 *
 * I/O devices (LED, BUT, UART, ...) are connected externally via the I/O bus.
 * The top module is responsible for:
 *   - Driving io_in with the currently selected device's output
 *   - Connecting io_load / io_addr / io_out to each device
 */

`default_nettype none

module Computer #(
  parameter ROM_FILE = "",
  parameter RAM_DEPTH = 4096,
  parameter RAM_ADDR_BITS = 12,
  parameter SCR_DEPTH = 8192,
  parameter SCR_ADDR_BITS = 13
)(
  input clk,
  input reset,

  // I/O bus (to/from external device modules)
  output io_load, // write enable for I/O device
  output [3:0] io_addr, // device index (0x0=LED, 0x1=BUT, ...)
  output [15:0] io_out, // write data to I/O device
  input [15:0] io_in, // read data from selected I/O device

  // Keyboard (0x6000, read-only)
  input [15:0] keyboard,

  // Screen memory read port for display controller
  input [SCR_ADDR_BITS-1:0] screen_raddr,
  output [15:0] screen_rdata
);

  // --- ROM (Instruction Memory) ---
  reg [15:0] rom [0:4095];
  initial if (ROM_FILE != "") $readmemb(ROM_FILE, rom);

  wire [14:0] pc;
  wire [15:0] instruction = rom[pc[11:0]];  // 12-bit ROM address

  // --- CPU ---
  wire [15:0] inM;
  wire [15:0] outM;
  wire writeM;
  wire [14:0] addressM;

  CPU CPU(
    .clk(clk),
    .inM(inM),
    .instruction(instruction),
    .reset(reset),
    .outM(outM),
    .writeM(writeM),
    .addressM(addressM),
    .pc(pc)
  );

  // --- Data Memory ---
  Memory #(
    .RAM_DEPTH(RAM_DEPTH),
    .RAM_ADDR_BITS(RAM_ADDR_BITS),
    .SCR_DEPTH(SCR_DEPTH),
    .SCR_ADDR_BITS(SCR_ADDR_BITS)
  ) MEMORY(
    .clk(clk),
    .in(outM),
    .load(writeM),
    .address(addressM),
    .io_load(io_load),
    .io_addr(io_addr),
    .io_out(io_out),
    .io_in(io_in),
    .keyboard(keyboard),
    .out(inM),
    .screen_raddr(screen_raddr),
    .screen_rdata(screen_rdata)
  );

endmodule
