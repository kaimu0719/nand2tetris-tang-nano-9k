`timescale 10ns/1ns
`default_nettype none

module UartTX_tb();

    // シミュレーション用に BAUD_DIV を小さくする（実機は234）
    localparam BAUD_DIV = 8;

    reg         clk  = 0;
    reg         load = 0;
    reg  [15:0] in   = 0;
    wire        TX;
    wire [15:0] out;

    always #0.5 clk = ~clk;

    UartTX #(.BAUD_DIV(BAUD_DIV)) dut(
        .clk(clk),
        .load(load),
        .in(in),
        .TX(TX),
        .out(out)
    );

    reg fail = 0;

    // 1バイト送信して TX ビット列と busy 信号を検証する
    //
    // 送信順: start(0), D0, D1, D2, D3, D4, D5, D6, D7, stop(1)
    // expected = {stop=1, D7..D0, start=0} → expected[0]=start, [1]=D0, ..., [9]=stop
    //
    // タイミング:
    //   load=1 を1クロック入力後、2クロック待つと TX がスタートビットに変わる。
    //   以降 BAUD_DIV クロックごとに次のビットに進む。
    task send_and_check;
        input [7:0] data;
        reg [9:0] expected;
        integer i;
        begin
            expected = {1'b1, data[7:0], 1'b0};

            // load を1クロック入力
            in   = {8'b0, data};
            load = 1;
            @(posedge clk); #1;
            load = 0;

            // 2クロック後に TX = スタートビット、busy = 1
            repeat(2) @(posedge clk); #1;
            if (out[15] !== 1'b1) begin
                $display("FAIL [busy]: data=0x%02x busy not set", data);
                fail = 1;
            end

            // 各ビットを1ビット周期(BAUD_DIV)ごとにサンプリング
            for (i = 0; i < 10; i = i + 1) begin
                if (TX !== expected[i]) begin
                    $display("FAIL [bit%0d]: data=0x%02x got=%b expected=%b",
                             i, data, TX, expected[i]);
                    fail = 1;
                end
                if (i < 9) begin
                    repeat(BAUD_DIV) @(posedge clk); #1;
                end
            end

            // ストップビット送信完了後、busy = 0 を確認
            repeat(BAUD_DIV) @(posedge clk); #1;
            if (out[15] !== 1'b0) begin
                $display("FAIL [busy]: data=0x%02x busy not cleared", data);
                fail = 1;
            end
        end
    endtask

    initial begin
        $dumpfile("UartTX_tb.vcd");
        $dumpvars(0, UartTX_tb);

        $display("------------------------");
        $display("Testbench: UartTX");

        send_and_check(8'h41); // 'A' = 01000001
        send_and_check(8'h69); // 'i' = 01101001
        send_and_check(8'hFF); // 全ビット1
        send_and_check(8'h00); // 全ビット0
        send_and_check(8'h55); // 01010101（交互）
        send_and_check(8'hAA); // 10101010（交互）

        if (fail == 0) $display("passed");
        $display("------------------------");
        $finish;
    end

endmodule
