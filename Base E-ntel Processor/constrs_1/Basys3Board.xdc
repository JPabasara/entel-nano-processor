## Clock signal (Basys 3 onboard 100 MHz clock)
set_property PACKAGE_PIN W5 [get_ports Clk]
set_property IOSTANDARD LVCMOS33 [get_ports Clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports Clk]

## LEDs
# LD0 - LD3 = Value_Out
set_property PACKAGE_PIN U16 [get_ports {Value_Out[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Value_Out[0]}]
set_property PACKAGE_PIN E19 [get_ports {Value_Out[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Value_Out[1]}]
set_property PACKAGE_PIN U19 [get_ports {Value_Out[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {Value_Out[2]}]
set_property PACKAGE_PIN V19 [get_ports {Value_Out[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Value_Out[3]}]

# LD13 = Jump
set_property PACKAGE_PIN P1 [get_ports Jump]
set_property IOSTANDARD LVCMOS33 [get_ports Jump]

# LD14 = Zero
set_property PACKAGE_PIN N3 [get_ports Zero]
set_property IOSTANDARD LVCMOS33 [get_ports Zero]

# LD15 = OverFlow
set_property PACKAGE_PIN L1 [get_ports OverFlow]
set_property IOSTANDARD LVCMOS33 [get_ports OverFlow]

## 7-segment display segments
set_property PACKAGE_PIN W7 [get_ports {SEG[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[0]}]
set_property PACKAGE_PIN W6 [get_ports {SEG[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[1]}]
set_property PACKAGE_PIN U8 [get_ports {SEG[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[2]}]
set_property PACKAGE_PIN V8 [get_ports {SEG[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[3]}]
set_property PACKAGE_PIN U5 [get_ports {SEG[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[4]}]
set_property PACKAGE_PIN V5 [get_ports {SEG[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[5]}]
set_property PACKAGE_PIN U7 [get_ports {SEG[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[6]}]

## 7-segment display anodes
set_property PACKAGE_PIN U2 [get_ports {AN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[0]}]
set_property PACKAGE_PIN U4 [get_ports {AN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[1]}]
set_property PACKAGE_PIN V4 [get_ports {AN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[2]}]
set_property PACKAGE_PIN W4 [get_ports {AN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[3]}]

## Button for Reset - BTNC = U18
set_property PACKAGE_PIN U18 [get_ports Reset]
set_property IOSTANDARD LVCMOS33 [get_ports Reset]
