# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files

vlog november28printtest.v

#load simulation using mux as the top level simulation module
vsim topLevel

#log all signals and add some signals to waveform window
log -r {/*}
add wave {/*}
add wave {/topLevel/B1/b1/*} 
add wave {/topLevel/B1/*} 
add wave {/topLevel/D1/*}


radix -unsigned
force {CLOCK_50} 0 0ns, 1 10ns -repeat 20ns;
force {KEY[0]} {0}
run 40 ns
force {KEY[0]} {1}

run 30 ns

force {KEY[1]} {0}
run 30 ns
force {KEY[1]} {1}
run 50 ns

run 3 ms