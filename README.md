# PCI-FPGA WISHBONE BUS XILINX XC3S400 @133MHZ
The GitHub project "PCI-FPGA" is an open-source hardware design written in Verilog that implements a PCI (Peripheral Component Interconnect) interface on an FPGA (Field-Programmable Gate Array). The project targets Xilinx XC3S400 FPGA devices and uses a 133 MHz clock speed.

The design, named "TOP," provides an interface between a PCI bus and a Wishbone bus, which is a widely used standard for connecting digital components in an FPGA. The design contains a module "PCI_TPHY" that implements the physical layer of the PCI interface, and a module "WISHBONE" that implements the Wishbone bus interface.

The design has several inputs and outputs, including PCI signals such as PCI_RSTn_I, PCI_CLK_I, PCI_IDEL_I, and PCI_AD_IO. It also includes outputs for the FALC45 bus and the Wishbone bus, such as CLK_20MEG_FALC56_I and wb_led.

The project was created on December 15, 2018, and its latest revision was 0.01. 
In summary, the "PCI-FPGA" project is a hardware design that implements a PCI interface on an FPGA, connecting the PCI bus to a Wishbone bus. The design is written in Verilog and targets Xilinx XC3S400 FPGA devices.
