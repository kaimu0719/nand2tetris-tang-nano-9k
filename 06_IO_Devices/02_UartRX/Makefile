sim:
	iverilog -o UartRX_tb.out Include.v UartRX_tb.v && vvp UartRX_tb.out

wave: UartRX_tb.vcd
	gtkwave UartRX_tb.vcd &

clean:
	rm -f *.out *.vcd

.PHONY: sim wave clean
