sim:
	iverilog -o UartTX_tb.out Include.v UartTX_tb.v && vvp UartTX_tb.out

wave: UartTX_tb.vcd
	gtkwave UartTX_tb.vcd &

clean:
	rm -f *.out *.vcd

.PHONY: sim wave clean
