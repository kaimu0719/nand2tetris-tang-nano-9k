sim:
	iverilog -o SPI_tb.out Include.v SPI_tb.v && vvp SPI_tb.out

wave: SPI_tb.vcd
	gtkwave SPI_tb.vcd &

clean:
	rm -f *.out *.vcd

.PHONY: sim wave clean
