# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog bombFSM.v

#load simulation using mux as the top level simulation module
#vsim -L altera_mf_ver topLevel
vsim bombFSM

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}
add wave {/bombFSM/R1/*}
add wave {/bombFSM/B1/*}

radix -unsigned
force {clk} 0 0ns, 1 5ns -repeat 10ns;

force RbombPosX 1000
force RbombPosY 1000
force RbombButton 0

force BbombPosX 1111
force BbombPosY 1111
force BbombButton 0

force redPosX 1000
force redPosY 1000

force bluePosX 1111
force bluePosY 1111

run 40 ns

force RbombButton 1
run 100 ns
force RbombButton 0

run 30000ns

force BbombButton 1
run 100 ns
force BbombButton 0

run 30000ns

force RbombButton 1
run 100 ns
force RbombButton 0

run 30000ns