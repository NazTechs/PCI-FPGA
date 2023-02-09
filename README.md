# PCI-FPGA WISHBONE BUS XILINX XC3S400 @133MHZ
The "PCI-FPGA WISHBONE BUS XILINX XC3S400 @133MHZ in verilog" is a module for communication between the Peripheral Component Interconnect (PCI) bus and Field-Programmable Gate Array (FPGA) circuits. The code was created on December 15th, 2018 and written in Verilog.

This module provides an interface between the PCI bus and the FALC56 bus. The PCI bus is responsible for communication between the FPGA and other peripherals or devices connected to the computer. The FALC56 bus is an interface that allows communication between the FPGA and other digital circuits.

The module takes in inputs such as PCI_RSTn_I, PCI_CLK_I, and PCI_IDEL_I and also outputs signals like PCI_INTAn, and wb_led. The inout signals of the module include PCI_FRAMEn_IO, PCI_IRDYn_IO, PCI_TRDYn_IO, and more. These signals allow for the exchange of data and control information between the PCI bus and the FPGA.

The code instantiates the PCI_TPHY module to perform the physical layer operations for the PCI bus. This module handles the communication between the PCI bus and the FPGA, including the generation and detection of the PCI signals and control of the data transfer.

In conclusion, the "PCI-FPGA WISHBONE BUS XILINX XC3S400 @133MHZ in verilog" provides an interface between the PCI bus and the FALC56 bus in an FPGA environment. This code can be used as a starting point for designing systems that require communication between the PCI bus and FPGA.
