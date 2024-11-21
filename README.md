PCI-FPGA: PCI Interface Implementation on FPGA
==============================================

Overview
--------

The PCI-FPGA project provides an open-source hardware design written in Verilog, implementing a Peripheral Component Interconnect (PCI) interface on an FPGA. This design facilitates communication between an FPGA and a host system via the PCI bus, enabling the development of custom PCI-based hardware solutions.

Features
--------

-   **PCI Interface**: Implements a standard PCI interface for seamless integration with host systems.
-   **Wishbone Bus Integration**: Utilizes the Wishbone bus architecture for internal communication within the FPGA.
-   **Modular Design**: Comprises various modules, including DMA engines, memory managers, and interrupt controllers, allowing for flexible customization.
-   **High-Performance Operation**: Designed to operate at 133 MHz on a Xilinx XC3S400 FPGA, ensuring efficient data transfer rates.

Repository Structure
--------------------

-   `FALC54_DEFSM.v`: Defines the state machine for the FALC54 module.
-   `FALC54_PHY.v`: Implements the physical layer for the FALC54 module.
-   `FALC56_DCM.v`: Contains the Digital Clock Manager for the FALC56 module.
-   `FALC56_DECODER.v`: Provides the decoder logic for the FALC56 module.
-   `FALC56_DMA_ENGINE.v`: Implements the DMA engine for the FALC56 module.
-   `FALC56_ENCODER.v`: Contains the encoder logic for the FALC56 module.
-   `FALC56_WB_INT.v`: Manages Wishbone bus interrupts for the FALC56 module.
-   `FALC56_WB_TYPE2.v`: Defines Type 2 Wishbone bus interface for the FALC56 module.
-   `FLAC56_WB.v`: Implements the Wishbone bus interface for the FLAC56 module.
-   `MEM_BANK_MNG.v`: Manages memory banks within the FPGA.
-   `PCI_DEFSM_ADD_DECODER.v`: Decodes addresses for the PCI state machine.
-   `PCI_DEFSM_CFG_MNG.v`: Manages configuration for the PCI state machine.
-   `PCI_DEFSM_HPMEM_MNG.v`: Manages high-performance memory for the PCI state machine.
-   `PCI_DEFSM_INT_MNG.v`: Manages interrupts for the PCI state machine.
-   `PCI_DEFSM_MEM_MNG.v`: Manages memory for the PCI state machine.
-   `PCI_DEFSM_PAR.v`: Handles parity for the PCI state machine.
-   `PCI_IN_DECODER.v`: Decodes incoming PCI signals.
-   `PCI_OUT_ENCODER.v`: Encodes outgoing PCI signals.
-   `PCI_TPHY.v`: Implements the physical layer for the PCI interface.
-   `PCI_WB_DeFSM.v`: Defines the state machine for the PCI Wishbone interface.
-   `TOP.v`: Top-level module integrating all components.
-   `WB_DEBUG_SLAVE.v`: Implements a debug interface for the Wishbone bus.
-   `WB_INTERN.v`: Manages internal Wishbone bus operations.
-   `WB_LED_SLAVE.v`: Controls LEDs via the Wishbone bus.

Getting Started
---------------

1.  **Prerequisites**:

    -   Xilinx ISE or Vivado development environment.
    -   Xilinx XC3S400 FPGA or compatible hardware.
2.  **Cloning the Repository**:
3.  
    `git clone https://github.com/NazTechs/PCI-FPGA.git`

4.  **Building the Project**:

    -   Open the project in your Xilinx development environment.
    -   Synthesize and implement the design.
    -   Generate the bitstream file.
5.  **Programming the FPGA**:

    -   Use the generated bitstream to program your FPGA device.

Contributing
------------

Contributions are welcome! Feel free to submit issues or pull requests to enhance the functionality or documentation of this project.

License
-------

This project is licensed under the MIT License. See the LICENSE file for details.

Acknowledgments
---------------

Special thanks to the open-source community for providing valuable resources and support in the development of this project.
