#**************************************************************
# Create Clock (where ‘Clk’ is the user-defined system clock name) 
#**************************************************************
create_clock -name {CLOCK_50} -period 20ns -waveform {0.000 5.000} [get_ports {CLOCK_50}]

# Constrain the input I/O path
set_input_delay -clock {CLOCK_50} -max 3 [all_inputs]
set_input_delay -clock {CLOCK_50} -min 2 [all_inputs]

# Constrain the output I/O path
set_output_delay -clock {CLOCK_50} 2 [all_outputs]