`timescale 10ns/1ns
`default_nettype none

module UartRX_tb();

    // シミュレーション用に BAUD_DIV を小さくする（実機は234）
    localparam BAUD_DIV = 8;

    reg         clk   = 0;
    reg         clear = 0;
    reg         RX    = 1; // アイドル時は High
    wire [15:0] out;

    always #0.5 clk = ~clk;

    UartRX #(.BAUD_DIV(BAUD_DIV)) dut(
        .clk(clk),
        .clear(clear),
        .RX(RX),
        .out(out)
    );

    reg fail = 0;

    // 1バイトを8N1フォーマットで RX ラインに送出するタスク
    // 各ビットを BAUD_DIV クロック保持する
    task uart_send;
        input [7:0] data;
        integer i;
        begin
            @(posedge clk); #1;
            RX = 0;                             // スタートビット
            repeat(BAUD_DIV) @(posedge clk); #1;
            for (i = 0; i < 8; i = i + 1) begin
                RX = data[i];                   // データビット（LSBファースト）
                repeat(BAUD_DIV) @(posedge clk); #1;
            end
            RX = 1;                             // ストップビット
            repeat(BAUD_DIV) @(posedge clk); #1;
        end
    endtask

    // 1バイト送信し、受信データを検証するタスク
    task send_and_verify;
        input [7:0] data;
        begin
            // クリアして受信待ちにする
            clear = 1; @(posedge clk); #1;
            clear = 0; @(posedge clk); #1;
            if (out[15] !== 1'b1) begin
                $display("FAIL [ready]: data=0x%02x out[15] not set after clear", data);
                fail = 1;
            end

            // バイトを送信
            uart_send(data);

            // 受信完了まで最大 BAUD_DIV*12 サイクル待つ
            repeat(BAUD_DIV * 4) @(posedge clk); #1;

            // 受信完了チェック
            if (out[15] !== 1'b0) begin
                $display("FAIL [done]: data=0x%02x out[15] still 1 (not received)", data);
                fail = 1;
            end else if (out[7:0] !== data) begin
                $display("FAIL [data]: expected=0x%02x got=0x%02x", data, out[7:0]);
                fail = 1;
            end
        end
    endtask

    initial begin
        $dumpfile("UartRX_tb.vcd");
        $dumpvars(0, UartRX_tb);

        $display("------------------------");
        $display("Testbench: UartRX");

        send_and_verify(8'h41); // 'A' = 01000001
        send_and_verify(8'h69); // 'i' = 01101001
        send_and_verify(8'hFF); // 全ビット1
        send_and_verify(8'h00); // 全ビット0
        send_and_verify(8'h55); // 01010101（交互）
        send_and_verify(8'hAA); // 10101010（交互）

        if (fail == 0) $display("passed");
        $display("------------------------");
        $finish;
    end

endmodule
