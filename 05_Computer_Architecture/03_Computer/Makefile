ASM = ruby ../../tools/Assembler/main.rb

# Assemble, simulate, and print results
sim: ROM.hack
	iverilog -o Computer_tb.out Include.v Computer_tb.v && vvp Computer_tb.out

# Open waveform viewer
wave: Computer_tb.vcd
	gtkwave Computer_tb.vcd Computer_tb.gtkw &

# Assemble .asm -> ROM.hack
%.hack: ../../04_Machine_Language/%.asm
	$(ASM) $< && mv ../../04_Machine_Language/$@ .

# Convenience targets
leds: leds.hack
	cp leds.hack ROM.hack
	$(MAKE) sim

mult: mult.hack
	cp mult.hack ROM.hack
	$(MAKE) sim

clean:
	rm -f *.out *.vcd *.hack

.PHONY: sim wave leds mult clean
