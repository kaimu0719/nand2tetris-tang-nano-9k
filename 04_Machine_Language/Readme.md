# 04 Machine Language

## I/O Memory Map

| Symbol       | Address     | Description                              |
| ------------ | ----------- | ---------------------------------------- |
| R0--R15      | 0--15       | General purpose registers                |
| LED          | 4096        | LED output (bit 1:0)                     |
| BUT          | 4097        | Button input (1=released, 0=pressed)     |
| UART_TX      | 4098        | Send byte over UART                      |
| UART_RX      | 4099        | Receive byte from UART                   |
| SPI          | 4100        | Read/write SPI flash ROM                 |
| SRAM_A       | 4101        | SRAM address for next read/write         |
| SRAM_D       | 4102        | Read/write data from/to SRAM             |
| GO           | 4103        | Switch from BOOT to RUN                  |
| LCD8         | 4104        | Write 8-bit to LCD                       |
| LCD16        | 4105        | Write 16-bit to LCD                      |
| RTP          | 4106        | Read/write 8-bit to RTP                  |
| DEBUG0--DEBUG4 | 4107--4111 | Debug registers (simulation only)       |

## Programs

### leds.asm

Reads button state `BUT[1:0]` and mirrors it to `LED[1:0]` in an infinite loop.

### mult.asm

Calculates `R2 = R0 * R1` by repeated addition.
Verifies the result and shows pass/fail via LED:

| LED | Meaning        |
| --- | -------------- |
| 01  | Calculating    |
| 10  | Correct result |
| 11  | Wrong result   |

## Build & Simulate

```bash
cd 05_Computer_Architecture/04_HACK

make leds   # assemble leds.asm and simulate
make mult   # assemble mult.asm and simulate
make wave   # open waveform viewer (GTKWave)
```
