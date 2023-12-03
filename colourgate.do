# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files

vlog back_fore_mux.v

#load simulation using mux as the top level simulation module
vsim colourGate

#log all signals and add some signals to waveform window
log -r {/*}
add wave {/*}

force x1 111111111
force x2 101010101
force backgroundSelect 0
force foregroundSelect 1

force y1 111111111
force y2 101010101


force colour1 101
force colour2 001

force continue 0

run 10 ns
force continue 1 



run 10 ns