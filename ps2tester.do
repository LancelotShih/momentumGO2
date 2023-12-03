# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ps2driver.v

#load simulation using mux as the top level simulation module
#vsim -L altera_mf_ver topLevel
vsim PS2Input

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

radix -unsigned
force {CLOCK_50} 0 0ns, 1 5ns -repeat 10ns;
force {PS2_CLK} 1

# tests data input of 00111000111 (w is pressed 71 shown)

######################

run 100 ns

######################

#0
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#1
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#2
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#3
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#4
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#5
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#6
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#7
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#8
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#9
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#10
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1

######################

run 100 ns

######################

# tests data input of 00001111101 00111000001 (w is released 1F 71 shown)
#0
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#1
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#2
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#3
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#4
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#5
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#6
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#7
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#8
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#9
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#10
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1

#11
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#12
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#13
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#14
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#15
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#16
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#17
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#18
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#19
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#20
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#21
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1

######################

run 100 ns

######################

# tests data input of 00111000001 (a is pressed 70 shown)

#0
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#1
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#2
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#3
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#4
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#5
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#6
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#7
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#8
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#9
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#10
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1

######################

run 100 ns

######################

#0
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#1
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#2
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#3
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#4
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#5
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#6
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#7
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#8
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#9
run 20 ns
force {PS2_DAT} 0
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1
#10
run 20 ns
force {PS2_DAT} 1
force {PS2_CLK} 0
run 20 ns
force {PS2_CLK} 1

run 50 ns