/**
 * Hack Data Memory for Tang Nano 9K (Hybrid design)
 *
 * RAM and Screen are implemented internally (BSRAM).
 * I/O devices are connected externally via the I/O bus.
 *
 * Address map (15-bit):
 *   0x0000 - 0x0FFF : RAM    (4K words)
 *   0x1000 - 0x100F : I/O    (16 devices, external)
 *   0x4000 - 0x5FFF : Screen (8K words, 512x256 1bpp)
 *   0x6000          : Keyboard (external, read-only)
 *
 * I/O bus:
 *   io_load         : write strobe (combinational)
 *   io_addr[3:0]    : device select (0x0=LED, 0x1=BUT, ...)
 *   io_out[15:0]    : write data (= in)
 *   io_in[15:0]     : read data from selected device (combinational MUX outside)
 */

`default_nettype none

module Memory #(
  parameter RAM_DEPTH = 4096,
  parameter RAM_ADDR_BITS = 12,
  parameter SCR_DEPTH = 8192,
  parameter SCR_ADDR_BITS = 13
)(
  input clk,
  input [15:0] in,
  input load,
  input [14:0] address,

  // I/O bus (to/from external device modules)
  output io_load, // write enable for I/O device
  output [3:0] io_addr, // device index (address[3:0])
  output [15:0] io_out, // write data (= in)
  input  [15:0] io_in, // read data from currently selected device

  // Keyboard (0x6000, read-only, separate from I/O bus)
  input [15:0] keyboard,

  output reg [15:0] out,

  // Screen dual-port: CPU writes, display controller reads independently
  input [SCR_ADDR_BITS-1:0] screen_raddr,
  output reg [15:0] screen_rdata
);

  // ---- Address decode ----
  wire ram_sel = (address[14:12] == 3'b000); // 0x0000-0x0FFF
  wire io_sel = (address[14:4]  == 11'b001_0000_0000); // 0x1000-0x100F
  wire screen_sel = (address[14] && !address[13]); // 0x4000-0x5FFF
  wire kbd_sel = (address[14:12] == 3'b110); // 0x6000-0x6FFF

  // ---- I/O bus (combinational) ----
  assign io_load = load && io_sel;
  assign io_addr = address[3:0];
  assign io_out = in;

  // ---- RAM ----
  reg [15:0] ram [0:RAM_DEPTH-1];

  // ---- Screen ----
  reg [15:0] screen [0:SCR_DEPTH-1];

  always @(posedge clk) begin

    // --- Writes ---
    if (load && ram_sel)
      ram[address[RAM_ADDR_BITS-1:0]] <= in;

    if (load && screen_sel)
      screen[address[SCR_ADDR_BITS-1:0]] <= in;

    // I/O writes are handled by external device modules via io_load/io_addr/io_out

    // --- CPU read (1-cycle latency for BSRAM) ---
    if      (ram_sel)    out <= ram[address[RAM_ADDR_BITS-1:0]];
    else if (screen_sel) out <= screen[address[SCR_ADDR_BITS-1:0]];
    else if (io_sel)     out <= io_in;
    else if (kbd_sel)    out <= keyboard;
    else                 out <= 16'h0000;

    // --- Display controller read ---
    screen_rdata <= screen[screen_raddr];

  end

endmodule