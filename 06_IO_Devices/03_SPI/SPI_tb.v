`timescale 10ns/1ns
`default_nettype none

module SPI_tb();

    reg         clk  = 0;
    reg         load = 0;
    reg  [15:0] in   = 0;
    wire [15:0] out;
    wire        CSX;
    wire        SDO;
    reg         SDI  = 0;
    wire        SCK;

    always #1 clk = ~clk; // 周期=2、#1 は半周期（安全なサンプリング点）

    SPI dut(
        .clk(clk), .load(load), .in(in),
        .out(out), .CSX(CSX), .SDO(SDO),
        .SDI(SDI), .SCK(SCK)
    );

    reg fail = 0;

    // 1バイトを転送して SDO ビット列と受信データを検証するタスク
    //
    // mosi: マスター→スレーブのデータ（SDO に出る）
    // miso: スレーブ→マスターのデータ（SDI に入れる、out[7:0] に出る）
    task spi_transfer;
        input [7:0] mosi;
        input [7:0] miso;
        reg [7:0] sdo_captured;
        integer i;
        begin
            SDI = 0;
            sdo_captured = 0;

            // 転送開始: in[8]=0 で CSX=0、in[7:0]=mosi
            in   = {8'b0, mosi};  // in[8]=0
            load = 1;
            @(posedge clk); #1;
            load = 0;

            // load 後の次サイクル: bits=1, SCK=Low, SDO=mosi[7], busy=1
            if (out[15] !== 1'b1) begin
                $display("FAIL [busy]: mosi=0x%02x busy not set", mosi);
                fail = 1;
            end

            // 8ビット分（16ハーフサイクル）を検証
            // bits=1: SCK=0, SDO=mosi[7]
            // bits=2: SCK=1, SDI サンプリング → shift
            // ...
            for (i = 7; i >= 0; i = i - 1) begin
                // SCK=Low のタイミング（奇数 bits）: SDO を確認
                if (SDO !== mosi[i]) begin
                    $display("FAIL [SDO bit%0d]: mosi=0x%02x got=%b expected=%b",
                             i, mosi, SDO, mosi[i]);
                    fail = 1;
                end
                if (SCK !== 1'b0) begin
                    $display("FAIL [SCK]: expected Low before sampling");
                    fail = 1;
                end
                // SDI に次に受信させたいビットをセット（MSBファースト）
                SDI = miso[i];
                @(posedge clk); #1; // SCK=High へ

                // SCK=High のタイミング（偶数 bits）: SDI サンプリング
                if (SCK !== 1'b1) begin
                    $display("FAIL [SCK]: expected High during sampling");
                    fail = 1;
                end
                @(posedge clk); #1; // 次のビットへ
            end

            // 転送完了後: busy=0、受信データ確認
            if (out[15] !== 1'b0) begin
                $display("FAIL [done]: mosi=0x%02x busy not cleared", mosi);
                fail = 1;
            end
            if (out[7:0] !== miso) begin
                $display("FAIL [miso]: expected=0x%02x got=0x%02x", miso, out[7:0]);
                fail = 1;
            end
        end
    endtask

    initial begin
        $dumpfile("SPI_tb.vcd");
        $dumpvars(0, SPI_tb);

        $display("------------------------");
        $display("Testbench: SPI");

        // 各種バイトを転送（各 spi_transfer 内で CSX=0 にアサートされる）
        spi_transfer(8'hA5, 8'h5A); // 10100101 ↔ 01011010
        spi_transfer(8'hFF, 8'h00); // 全1 → 全0
        spi_transfer(8'h00, 8'hFF); // 全0 → 全1
        spi_transfer(8'h55, 8'hAA); // 交互

        // CSX をネゲート（in[8]=1）
        in = 16'h0100; load = 1; @(posedge clk); #1; load = 0;
        @(posedge clk); #1;
        if (CSX !== 1'b1) begin
            $display("FAIL [CSX]: expected High after in[8]=1");
            fail = 1;
        end

        if (fail == 0) $display("passed");
        $display("------------------------");
        $finish;
    end

endmodule
