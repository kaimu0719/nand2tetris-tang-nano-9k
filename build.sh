#!/bin/bash
source ~/oss-cad-suite/environment

CST=$(pwd)/tangnano9k.cst

yosys -p "read_verilog Include.v top.v; synth_gowin -top top -json output.json -nobram" && \
nextpnr-gowin --json output.json --write output_pnr.json --device GW1NR-LV9QN88PC6/I5 --cst $CST && \
gowin_pack -d GW1N-9C -o output.fs output_pnr.json && \
openFPGALoader -b tangnano9k output.fs
