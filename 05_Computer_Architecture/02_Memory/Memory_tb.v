`default_nettype none
module Memory_tb();

    // Clock
    reg clk = 0;
    always #1 clk = ~clk;

    // Inputs
    reg  [15:0] in       = 0;
    reg         load     = 0;
    reg  [14:0] address  = 0;
    reg  [15:0] keyboard = 0;
    reg  [15:0] io_in    = 0;
    reg  [12:0] screen_raddr = 0;

    // Outputs
    wire        io_load;
    wire [3:0]  io_addr;
    wire [15:0] io_out;
    wire [15:0] out;
    wire [15:0] screen_rdata;

    // DUT
    Memory MEM(
        .clk(clk),
        .in(in),
        .load(load),
        .address(address),
        .io_load(io_load),
        .io_addr(io_addr),
        .io_out(io_out),
        .io_in(io_in),
        .keyboard(keyboard),
        .out(out),
        .screen_raddr(screen_raddr),
        .screen_rdata(screen_rdata)
    );

    // Test utilities
    reg fail = 0;
    integer i;

    task write_mem;
        input [14:0] addr;
        input [15:0] data;
        begin
            address = addr; in = data; load = 1;
            @(posedge clk); #1;
            load = 0;
        end
    endtask

    task read_mem;
        input [14:0] addr;
        begin
            address = addr; load = 0;
            @(posedge clk); #1;
        end
    endtask

    task check;
        input [15:0] got;
        input [15:0] expected;
        input [63:0] label;
        begin
            if (got !== expected) begin
                $display("FAIL [%s]: got=%0d expected=%0d (addr=0x%04x)",
                         label, got, expected, address);
                fail = 1;
            end
        end
    endtask

    initial begin
        $dumpfile("Memory_tb.vcd");
        $dumpvars(0, Memory_tb);

        $display("------------------------");
        $display("Testbench: Memory");

        // ---- 1. RAM read/write (0x0000-0x0FFF) ----
        // Write to several RAM locations
        write_mem(15'h0000, 16'hABCD);
        write_mem(15'h0001, 16'h1234);
        write_mem(15'h0FFE, 16'hDEAD);
        write_mem(15'h0FFF, 16'hBEEF);

        // Read back and verify
        read_mem(15'h0000); check(out, 16'hABCD, "RAM[0]");
        read_mem(15'h0001); check(out, 16'h1234, "RAM[1]");
        read_mem(15'h0FFE); check(out, 16'hDEAD, "RAM[4094]");
        read_mem(15'h0FFF); check(out, 16'hBEEF, "RAM[4095]");

        // ---- 2. I/O bus (0x1000-0x100F) ----
        // Write: check io_load, io_addr, io_out are correct (combinational)
        address = 15'h1000; in = 16'h0003; load = 1; #1;
        if (io_load !== 1'b1)  begin $display("FAIL [io_load]"); fail=1; end
        if (io_addr !== 4'h0)  begin $display("FAIL [io_addr]"); fail=1; end
        if (io_out  !== 16'h0003) begin $display("FAIL [io_out]"); fail=1; end
        @(posedge clk); #1; load = 0;

        address = 15'h1005; in = 16'hFFFF; load = 1; #1;
        if (io_load !== 1'b1)  begin $display("FAIL [io_load addr5]"); fail=1; end
        if (io_addr !== 4'h5)  begin $display("FAIL [io_addr addr5]"); fail=1; end
        @(posedge clk); #1; load = 0;

        // io_load must be 0 when load=0
        address = 15'h1000; load = 0; #1;
        if (io_load !== 1'b0) begin $display("FAIL [io_load=0]"); fail=1; end

        // Read: out should reflect io_in (after 1 cycle)
        io_in = 16'h00FF;
        read_mem(15'h1001); check(out, 16'h00FF, "IO read");

        io_in = 16'hCAFE;
        read_mem(15'h100F); check(out, 16'hCAFE, "IO read F");

        // ---- 3. Screen read/write (0x4000-0x5FFF) ----
        write_mem(15'h4000, 16'hFFFF);
        write_mem(15'h4001, 16'hAAAA);
        write_mem(15'h5FFE, 16'h5555);
        write_mem(15'h5FFF, 16'h0F0F);

        read_mem(15'h4000); check(out, 16'hFFFF, "SCR[0]");
        read_mem(15'h4001); check(out, 16'hAAAA, "SCR[1]");
        read_mem(15'h5FFE); check(out, 16'h5555, "SCR[8190]");
        read_mem(15'h5FFF); check(out, 16'h0F0F, "SCR[8191]");

        // Screen display-port read (screen_raddr → screen_rdata)
        write_mem(15'h4064, 16'h1234);  // screen[100]
        screen_raddr = 13'd100;
        @(posedge clk); #1;
        check(screen_rdata, 16'h1234, "SCR_RDATA");

        // ---- 4. Keyboard read (0x6000) ----
        keyboard = 16'h0041;  // 'A'
        read_mem(15'h6000); check(out, 16'h0041, "KBD");

        keyboard = 16'h0000;
        read_mem(15'h6000); check(out, 16'h0000, "KBD=0");

        // ---- 5. RAM not affected by I/O or Screen writes ----
        read_mem(15'h0000); check(out, 16'hABCD, "RAM isolation");
        read_mem(15'h0001); check(out, 16'h1234, "RAM isolation2");

        if (fail == 0) $display("passed");
        $display("------------------------");
        $finish;
    end

endmodule
