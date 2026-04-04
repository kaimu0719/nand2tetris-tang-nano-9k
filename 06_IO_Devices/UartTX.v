/**
 * UartTX: UART送信モジュール（8N1、115200 baud @ 27MHz）
 *
 * load=1 のとき in[7:0] の送信を開始する。
 * 送信中は out[15]=1（busy）。送信完了後に out[15]=0（ready）。
 * busy 中に load=1 を受け取っても無視する。
 *
 * ビット順: スタートビット(0), D0..D7（LSBファースト）, ストップビット(1)
 *
 * BAUD_DIV = クロック周波数 / ボーレート
 *   例: 27MHz / 115200 ≈ 234
 */
`default_nettype none

module UartTX #(
  parameter BAUD_DIV = 234
)(
  input         clk,
  input         load,
  input  [15:0] in,
  output        TX,
  output [15:0] out
);
  // シフトレジスタ: [stop=1, D7..D0, start=0] の10ビット
  // TX = shift[0] を1ビットずつ送り出す
  reg [9:0] shift    = 10'b1111111111; // アイドル時は全1 (TX=1)
  reg [7:0] baud_cnt = 0; // ボーレートカウンタ
  reg [3:0] bit_cnt  = 0; // 送信ビット番号 (0=start .. 9=stop)
  reg       busy     = 0;

  assign TX  = shift[0];
  assign out = {busy, 15'b0};

  always @(posedge clk) begin
    // 送信開始
    if (!busy) begin
      // load=1 で送信開始。busy=1 になる。
      if (load) begin
        // [stop=1, D7..D0, start=0] をシフトレジスタにセット
        shift    <= {1'b1, in[7:0], 1'b0};
        baud_cnt <= 0;
        bit_cnt  <= 0;
        busy     <= 1;
      end
    end else begin
      // 送信中
      if (baud_cnt == BAUD_DIV - 1) begin
        // 1ビット分の時間が経過 → 右シフト（上位は1で埋める）
        baud_cnt <= 0;
        shift    <= {1'b1, shift[9:1]};
        if (bit_cnt == 9)
          busy <= 0;      // ストップビット送信完了
        else
          bit_cnt <= bit_cnt + 1;
      end else begin
        baud_cnt <= baud_cnt + 1;
      end
    end
  end

endmodule
