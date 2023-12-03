# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog playerFSM.v

#load simulation using mux as the top level simulation module
#vsim -L altera_mf_ver topLevel
vsim playerFSM

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

radix -unsigned
force {clk} 0 0ns, 1 5ns -repeat 10ns;

force directionUP 0
force directionDOWN 0
force directionLEFT 0
force directionRIGHT 0

force directionUP 1
run 20 ns
force directionUP 0
run 20 ns
force directionLEFT 1
run 100 ns
force directionLEFT 0
run 20 ns
force directionRIGHT 1
run 20 ns
force directionRIGHT 0
run 20 ns
force directionLEFT 1
run 100 ns
force directionLEFT 0
run 20 ns
force directionLEFT 1
run 20 ns
force directionLEFT 0
run 150 ns

force directionDOWN 1
run 70 ns
force directionDOWN 0
run 20 ns
force directionDOWN 1
run 70 ns
force directionDOWN 0
run 20 ns
force directionDOWN 1
run 70 ns
force directionDOWN 0
run 20 ns
force directionDOWN 1
run 70 ns

run 100 ns