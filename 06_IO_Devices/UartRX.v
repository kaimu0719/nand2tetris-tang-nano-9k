/**
 * UartRX: UART受信モジュール（8N1、115200 baud @ 27MHz）
 *
 * clear=1 のとき受信バッファをクリアし、次のバイト受信待ちになる。
 * 受信待ち中は out[15]=1（ready）。
 * 1バイト受信完了後は out[15]=0、out[7:0] に受信データが入る。
 *
 * ビット順: スタートビット(0), D0..D7（LSBファースト）, ストップビット(1)
 *
 * サンプリング戦略:
 *   スタートビット検出後、半ボー周期待ってから各ビットの中央でサンプリング。
 *   2段同期器の遅延（2クロック）を補正済み。
 */
`default_nettype none

module UartRX #(
  parameter BAUD_DIV = 234
)(
  input         clk,
  input         clear,
  input         RX,
  output [15:0] out
);
  reg [7:0] data  = 8'h00;
  reg       ready = 1;      // 1=受信待ち, 0=データ受信済み

  assign out = ready ? 16'h8000 : {8'b0, data};

  // 2段同期器（メタスタビリティ対策）
  reg rx0 = 1, rx1 = 1;
  always @(posedge clk) begin
    rx0 <= RX;
    rx1 <= rx0;
  end

  localparam IDLE     = 2'd0;
  localparam HALFBAUD = 2'd1; // スタートビット中央まで待機
  localparam SAMPLING = 2'd2; // データビット + ストップビットをサンプリング
  localparam DONE     = 2'd3; // 受信完了、clear待ち

  reg [1:0] state    = IDLE;
  reg [7:0] baud_cnt = 0;
  reg [3:0] bit_cnt  = 0;   // 0..7=データビット, 8=ストップビット

  always @(posedge clk) begin
    if (clear) begin
      state <= IDLE;
      ready <= 1;
    end else begin
      case (state)
        IDLE: begin
          if (!rx1) begin
            // スタートビット検出（RXがLowに）
            baud_cnt <= 0;
            state    <= HALFBAUD;
          end
        end

        HALFBAUD: begin
          // スタートビット中央まで待つ（2段同期器の2クロック分を補正）
          // 待機サイクル数 = BAUD_DIV/2 - 2
          if (baud_cnt == BAUD_DIV/2 - 2 - 1) begin
            baud_cnt <= 0;
            bit_cnt  <= 0;
            state    <= SAMPLING;
          end else begin
            baud_cnt <= baud_cnt + 1;
          end
        end

        SAMPLING: begin
          if (baud_cnt == BAUD_DIV - 1) begin
            baud_cnt <= 0;
            if (bit_cnt < 8) begin
              data[bit_cnt] <= rx1;           // LSBファースト
              bit_cnt       <= bit_cnt + 1;
            end else begin
              // ストップビット確認完了 → データ確定
              ready <= 0;
              state <= DONE;
            end
          end else begin
            baud_cnt <= baud_cnt + 1;
          end
        end

        DONE: begin
          // clear=1 を待つ
        end
      endcase
    end
  end

endmodule
