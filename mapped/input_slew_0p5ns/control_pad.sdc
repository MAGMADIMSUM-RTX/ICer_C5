###################################################################

# Created by write_sdc on Thu Nov 19 13:13:39 2026

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_load -pin_load 0.06366 [get_ports rd]
set_load -pin_load 0.06366 [get_ports wr]
set_load -pin_load 0.06366 [get_ports ld_ir]
set_load -pin_load 0.06366 [get_ports ld_ac]
set_load -pin_load 0.06366 [get_ports ld_pc]
set_load -pin_load 0.06366 [get_ports inc_pc]
set_load -pin_load 0.06366 [get_ports halt]
set_load -pin_load 0.06366 [get_ports data_e]
set_load -pin_load 0.06366 [get_ports sel]
create_clock [get_ports clk]  -period 20  -waveform {0 10}
set_clock_uncertainty 0.2  [get_clocks clk]
set_input_delay -clock clk  -max 0.1  [get_ports rst_]
set_input_delay -clock clk  -max 0.1  [get_ports zero]
set_input_delay -clock clk  -max 0.1  [get_ports {opcode[2]}]
set_input_delay -clock clk  -max 0.1  [get_ports {opcode[1]}]
set_input_delay -clock clk  -max 0.1  [get_ports {opcode[0]}]
set_output_delay -clock clk  -max 1  [get_ports rd]
set_output_delay -clock clk  -max 1  [get_ports wr]
set_output_delay -clock clk  -max 1  [get_ports ld_ir]
set_output_delay -clock clk  -max 1  [get_ports ld_ac]
set_output_delay -clock clk  -max 1  [get_ports ld_pc]
set_output_delay -clock clk  -max 1  [get_ports inc_pc]
set_output_delay -clock clk  -max 1  [get_ports halt]
set_output_delay -clock clk  -max 1  [get_ports data_e]
set_output_delay -clock clk  -max 1  [get_ports sel]
set_input_transition -max 0.5  [get_ports rst_]
set_input_transition -min 0.5  [get_ports rst_]
set_input_transition -max 0.5  [get_ports zero]
set_input_transition -min 0.5  [get_ports zero]
set_input_transition -max 0.5  [get_ports {opcode[2]}]
set_input_transition -min 0.5  [get_ports {opcode[2]}]
set_input_transition -max 0.5  [get_ports {opcode[1]}]
set_input_transition -min 0.5  [get_ports {opcode[1]}]
set_input_transition -max 0.5  [get_ports {opcode[0]}]
set_input_transition -min 0.5  [get_ports {opcode[0]}]
