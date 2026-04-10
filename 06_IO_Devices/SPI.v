/**
 * SPI マスターコントローラ（Mode 0: CPOL=0, CPHA=0）
 *
 * load=1 のとき in[7:0] の送信を開始する。
 * in[8] が CSX の値（0=CS アサート／転送開始、1=CS ネゲート）。
 * 送信中は out[15]=1（busy）、送信完了後に out[7:0] に受信バイトが入る。
 *
 * SCK = clk/2（クロックを1サイクルごとにトグル）
 * ビット順: MSBファースト（D7, D6, ..., D0）
 * SDO: SCK=Low のときにセットアップ
 * SDI: SCK=High のとき（立ち上がりエッジ）でサンプリング
 */
`default_nettype none

module SPI(
  input         clk,
  input         load,
  input  [15:0] in,
  output [15:0] out,
  output        CSX,
  output        SDO,
  input         SDI,
  output        SCK
);
  reg [7:0] shift   = 8'h00;
  reg [4:0] bits    = 0;      // 0=アイドル, 1..16=転送中（16ハーフサイクル=8ビット）
  reg       csx_reg = 1;
  reg       sdi_r   = 0;      // SDI の1クロック遅延（サンプリング用）

  wire busy = |bits;          // bits > 0 のとき転送中

  assign CSX = csx_reg;
  assign SCK = busy & ~bits[0]; // 偶数ビット(2,4..16)のとき High
  assign SDO = shift[7];        // MSB を常に出力
  assign out = {busy, 7'b0, shift};

  always @(posedge clk) begin
    sdi_r <= SDI; // SDI を1クロック遅延させてメタスタビリティを緩和

    if (load) begin
      csx_reg <= in[8];
      if (!in[8]) begin
        // CSX=0: 転送開始
        shift <= in[7:0];
        bits  <= 1;
      end
    end else if (busy) begin
      if (bits == 16) begin
        shift <= {shift[6:0], sdi_r}; // 最後のビットをサンプリング
        bits  <= 0;                   // 転送完了
      end else begin
        bits <= bits + 1;
        // SCK=High（偶数ビット）のとき: SDI をサンプリングして左シフト
        if (!bits[0]) begin
          shift <= {shift[6:0], sdi_r};
        end
      end
    end
  end

endmodule
