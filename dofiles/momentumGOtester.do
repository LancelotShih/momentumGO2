# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog momentumGo.v
# vlog vgaAdapter/vga_adapter.v
# vlog vgaAdapter/vga_address_translator.v
# vlog vgaAdapter/vga_controller.v
# vlog vgaAdapter/vga_pll.v
# vlog vgaAdapter/vgaAdap.v

#load simulation using mux as the top level simulation module
vsim -L altera_mf_ver drawer
vsim momentumGO

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}
add wave {/momentumGO/redPlayer/*}
add wave {/momentumGO/drawRed/*}

radix -unsigned
force {CLOCK_50} 0 0ns, 1 5ns -repeat 10ns;

force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 1
force {KEY[0]} 1

run 20 ns

force {KEY[0]} 0

run 1600 ns


force {KEY[0]} 1
run 200 ns
force {KEY[1]} 0
run 20000 ns
force {KEY[1]} 1
run 200 ns


run 200000 ns