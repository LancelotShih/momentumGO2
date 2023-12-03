# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog momentumGo.v

#load simulation using mux as the top level simulation module
#vsim -L altera_mf_ver drawer
vsim drawer

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}
add wave {/drawer/a1/*}

radix -unsigned
force {clk} 0 0ns, 1 5ns -repeat 10ns;

force somethingPressed 1
force initX 60
force initY 50
run 1100ns