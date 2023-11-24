# RESET
set_property IOSTANDARD LVCMOS25 [get_ports reset_poweron]
set_property PACKAGE_PIN T18 [get_ports reset_poweron]

# CLK_100M
set_property IOSTANDARD LVCMOS25 [get_ports clk_100mhz]
set_property PACKAGE_PIN Y9 [get_ports clk_100mhz]

# Button ют╥б
set_property IOSTANDARD LVCMOS25 [get_ports {btn[*]}]
set_property PACKAGE_PIN P16 [get_ports {btn[0]}]
set_property PACKAGE_PIN N15 [get_ports {btn[1]}]

# KEYPAD
set_property IOSTANDARD LVCMOS25 [get_ports {key_io[*]}]
set_property PACKAGE_PIN AB7 	[get_ports {key_io[0]}]
set_property PACKAGE_PIN AB6 	[get_ports {key_io[1]}]
set_property PACKAGE_PIN Y4 	[get_ports {key_io[2]}]
set_property PACKAGE_PIN AA4 	[get_ports {key_io[3]}]
set_property PACKAGE_PIN R6	[get_ports {key_io[4]}]
set_property PACKAGE_PIN T6	[get_ports {key_io[5]}]
set_property PACKAGE_PIN T4 	[get_ports {key_io[6]}]
set_property PACKAGE_PIN U4 	[get_ports {key_io[7]}]

# VGA
set_property IOSTANDARD LVCMOS33 [get_ports {red[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue[*]}]

set_property PACKAGE_PIN V20 	[get_ports {red[0]}]
set_property PACKAGE_PIN U20 	[get_ports {red[1]}]
set_property PACKAGE_PIN V19 	[get_ports {red[2]}]
set_property PACKAGE_PIN V18 	[get_ports {red[3]}]
set_property PACKAGE_PIN AB22 [get_ports {green[0]}]
set_property PACKAGE_PIN AA22 [get_ports {green[1]}]
set_property PACKAGE_PIN AB21 [get_ports {green[2]}]
set_property PACKAGE_PIN AA21 [get_ports {green[3]}]
set_property PACKAGE_PIN Y21 	[get_ports {blue[0]}]
set_property PACKAGE_PIN Y20 	[get_ports {blue[1]}]
set_property PACKAGE_PIN AB20 [get_ports {blue[2]}]
set_property PACKAGE_PIN AB19 [get_ports {blue[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {hsync}]
set_property PACKAGE_PIN AA19 [get_ports {hsync}]
set_property IOSTANDARD LVCMOS33 [get_ports {vsync}]
set_property PACKAGE_PIN Y19	[get_ports {vsync}]
