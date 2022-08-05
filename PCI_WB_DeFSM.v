`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: SOHEIL NAZARI +989122939002
// 
// Create Date: 12/25/2018 11:44:23 AM
// Design Name: 
// Module Name: PCI_WB_DeFSM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PCI_WB_DeFSM(

	input  PHY_CLK33_I,
	input  PHY_RSTn_I,
	input  IDSEL_I,
	
	input  FRAMEn_I,
	input  IRDYn_I,
	
	output    TRDYn_O ,
	output    TRDYn_DIR_O,
	output    DEVSELn_O ,
	output    DEVSELn_DIR_O ,
	output    STOPn_O ,
	output    STOPn_DIR_O ,
	input  	     PAR_I,
	output    PAR_O ,
	output    PAR_DIR_O ,
	output    PERRn_O,
	output    PERRn_DIR_O,
	output    SERRn_O,
	output    SERRn_DIR_O ,
	
	output   [31:0]  AD_O ,
	output   AD_DIR_O ,
	input [31:0]  AD_I,
	
	input [3:0] CBEn_I,
	
	output  INTA_O,
	
	
	
	// MASTER WISHBONE SIGNALS
	
	output[31:0] WB_DATA_O ,
	input [31:0] WB_DATA_I,
		
	input WB_ACK_I,
	input WB_VALID_I,
	
	output  [31:0] WB_ADD_O ,
	output  WB_STB_O ,
	output  WB_WE_O ,
	
	
	output HP_MEM_IDLE_O,
	
	input  [31:0] HPRAM_DATA_I,
	output [31:0] HPRAM_DATA_O,
	output [11:0] HPRAM_ADD_O, 
	output [3:0] HPRAM_WEN_O

	
	//output reg [1:0] wb_led = 0


    );
	
	wire [31:0] ADD_AD_O;
	wire [3:0]  ADD_CBEn;
	
	wire [31:0] CFG_AD_O;
	wire [3:0]  CFG_CBEn; 
	
	wire [31:0] MEM_AD_O;
	wire [3:0]  MEM_CBEn; 
	
	wire [31:0] HPMEM_AD_O;
	wire [3:0]  HPMEM_CBEn; 

	wire [31:0] PGEN_AD_O;
	wire [3:0]  PGEN_CBEn; 
	// Instantiate the module
PCI_IN_DECODER PCI_IN_DECODER0 (
    .PHY_CLK33_I(PHY_CLK33_I), 
    .PHY_RSTn_I(PHY_RSTn_I), 
    .IDSEL_I(IDSEL_I), 
    .FRAMEn_I(FRAMEn_I), 
    .IRDYn_I(IRDYn_I), 
    .AD_I(AD_I), 
    .CBEn_I(CBEn_I), 
	
    .ADD_IDSEL_O(ADD_IDSEL), 
    .ADD_FRAMEn_O(ADD_FRAMEn), 
    .ADD_IRDYn_O(ADD_IRDYn), 
    .ADD_AD_O(ADD_AD_O), 
    .ADD_CBEn_O(ADD_CBEn), 
	
    .CFG_FRAMEn_O(CFG_FRAMEn), 
    .CFG_IRDYn_O(CFG_IRDYn), 
    .CFG_AD_O(CFG_AD_O), 
    .CFG_CBEn_O(CFG_CBEn),
	
	
	.MEM_FRAMEn_O(MEM_FRAMEn), 
    .MEM_IRDYn_O(MEM_IRDYn), 
    .MEM_AD_O(MEM_AD_O), 
    .MEM_CBEn_O(MEM_CBEn), 
	
	.HPMEM_FRAMEn_O(HPMEM_FRAMEn), 
    .HPMEM_IRDYn_O(HPMEM_IRDYn), 
    .HPMEM_AD_O(HPMEM_AD_O), 
    .HPMEM_CBEn_O(HPMEM_CBEn), 
	
	
    .PGEN_PAR_O(PGEN_PAR_O), 
    .PGEN_AD_O(PGEN_AD_O), 
    .PGEN_CBEn_O(PGEN_CBEn)
	

    );
	
	wire [31:0] CFG_AD_I;
	wire [31:0] MEM_AD_I;
	wire [31:0] HPMEM_AD_I;
	// Instantiate the module
PCI_OUT_ENCODER PCI_OUT_ENCODER0 (
    .PHY_CLK33_I(PHY_CLK33_I), 
    .PHY_RSTn_I(PHY_RSTn_I), 
    .TRDYn_O(TRDYn_O), 
    .TRDYn_DIR_O(TRDYn_DIR_O), 
    .DEVSELn_O(DEVSELn_O), 
    .DEVSELn_DIR_O(DEVSELn_DIR_O), 
    .STOPn_O(STOPn_O), 
    .STOPn_DIR_O(STOPn_DIR_O), 
    .AD_O(AD_O), 
    .AD_DIR_O(AD_DIR_O), 
    .INTA_O(INTA_O), 
	
    .ADD_TRDYn_I(ADD_TRDYn), 
    .ADD_TRDYn_DIR_I(ADD_TRDYn_DIR), 
    .ADD_DEVSELn_I(ADD_DEVSELn), 
    .ADD_DEVSELn_DIR_I(ADD_DEVSELn_DIR), 
    .ADD_STOPn_I(ADD_STOPn), 
    .ADD_STOPn_DIR_I(ADD_STOPn_DIR), 
	
    .CFG_TRDYn_I(CFG_TRDYn), 
    .CFG_TRDYn_DIR_I(CFG_TRDYn_DIR), 
    .CFG_DEVSELn_I(CFG_DEVSELn), 
    .CFG_DEVSELn_DIR_I(CFG_DEVSELn_DIR), 
    .CFG_STOPn_I(CFG_STOPn), 
    .CFG_STOPn_DIR_I(CFG_STOPn_DIR), 
    .CFG_AD_DIR_I(CFG_AD_DIR), 
    .CFG_AD_I(CFG_AD_I), 
	
	.MEM_TRDYn_I(MEM_TRDYn), 
    .MEM_TRDYn_DIR_I(MEM_TRDYn_DIR), 
    .MEM_DEVSELn_I(MEM_DEVSELn), 
    .MEM_DEVSELn_DIR_I(MEM_DEVSELn_DIR), 
    .MEM_STOPn_I(MEM_STOPn), 
    .MEM_STOPn_DIR_I(MEM_STOPn_DIR), 
    .MEM_AD_DIR_I(MEM_AD_DIR), 
    .MEM_AD_I(MEM_AD_I), 
	
	.HPMEM_TRDYn_I(HPMEM_TRDYn), 
    .HPMEM_TRDYn_DIR_I(HPMEM_TRDYn_DIR), 
    .HPMEM_DEVSELn_I(HPMEM_DEVSELn), 
    .HPMEM_DEVSELn_DIR_I(HPMEM_DEVSELn_DIR), 
    .HPMEM_STOPn_I(HPMEM_STOPn), 
    .HPMEM_STOPn_DIR_I(HPMEM_STOPn_DIR), 
    .HPMEM_AD_DIR_I(HPMEM_AD_DIR), 
    .HPMEM_AD_I(HPMEM_AD_I), 
	
    .ADD_OUTPUT_EN_I(ADD_OUTPUT_EN), 
    .CFG_OUTPUT_EN_I(CFG_OUTPUT_EN),
	.MEM_OUTPUT_EN_I(MEM_OUTPUT_EN),
	.HPMEM_OUTPUT_EN_I(HPMEM_OUTPUT_EN)
    );
	
	wire [23:2] PCI_ADD;
	parameter DEVICE_ID 		  = 16'hBBAA;
	parameter VENDOR_ID 		  = 16'h00AA;
	parameter DEVICE_CLASS 		  = 24'h118000;
	parameter DEVICE_REV  		  = 8'hF7;
	parameter SUBSYSTEM_ID 		  = 16'h0001;
	parameter SUBSYSTEM_VENDOR_ID = 16'h9876;
	
	
	wire [31:0] CFG_REG_0x00 = {DEVICE_ID,VENDOR_ID};
	wire [31:0] CFG_REG_0x08 = {DEVICE_CLASS ,DEVICE_REV};
	wire [31:0] CFG_REG_0x2C = {SUBSYSTEM_ID ,SUBSYSTEM_VENDOR_ID};
	wire [31:0] CFG_REG_0x04;
	wire [31:0] CFG_REG_0x10;
	wire [31:0] CFG_REG_0x11;
	
	// Instantiate the module
PCI_DEFSM_ADD_DECODER PCI_DEFSM_ADD_DECODER0 (
    .PHY_CLK33_I(PHY_CLK33_I), 
    .PHY_RSTn_I(PHY_RSTn_I), 
	
    .DEFSM_ADD2CFG_O(DEFSM_ADD2CFG), 
    .CFG_WR_O(CFG_WR), 
    .DEFSM_CFG_END_I(DEFSM_CFG_END), 
	
    .DEFSM_ADD2MEM_O(DEFSM_ADD2MEM), 
    .MEM_WR_O(MEM_WR), 
    .DEFSM_MEM_END_I(DEFSM_MEM_END), 
	
	
	.DEFSM_ADD2HPMEM_O(DEFSM_ADD2HPMEM), 
    .HPMEM_WR_O(HPMEM_WR), 
    .DEFSM_HPMEM_END_I(DEFSM_HPMEM_END),
	
    .ADD_OUTPUT_EN_O(ADD_OUTPUT_EN), 
	
    .CFG_REG_0x04_I(CFG_REG_0x04), 
    .CFG_REG_0x10_I(CFG_REG_0x10), 
	.CFG_REG_0x11_I(CFG_REG_0x11), 
	
    .PCI_ADD_O(PCI_ADD), 
    .ADD_IDSEL_I(ADD_IDSEL), 
    .ADD_FRAMEn_I(ADD_FRAMEn), 
    .ADD_IRDYn_I(ADD_IRDYn), 
    .ADD_TRDYn_O(ADD_TRDYn), 
    .ADD_TRDYn_DIR_O(ADD_TRDYn_DIR), 
    .ADD_DEVSELn_O(ADD_DEVSELn), 
    .ADD_DEVSELn_DIR_O(ADD_DEVSELn_DIR), 
    .ADD_STOPn_O(ADD_STOPn), 
    .ADD_STOPn_DIR_O(ADD_STOPn_DIR), 
    .ADD_AD_I(ADD_AD_O), 
    .ADD_CBEn_I(ADD_CBEn)
    );
	
	// Instantiate the module
PCI_DEFSM_CFG_MNG PCI_DEFSM_CFG_MNG0 (
    .PHY_CLK33_I(PHY_CLK33_I), 
    .PHY_RSTn_I(PHY_RSTn_I), 
	
    .DEFSM_CFG_END_O(DEFSM_CFG_END), 
    .CFG_WR_I(CFG_WR),
    .DEFSM_ADD2CFG_I(DEFSM_ADD2CFG), 
    .CFG_OUTPUT_EN_O(CFG_OUTPUT_EN), 
	.CFG_STATE_ABORT_I(CFG_STATE_MEM_ABORT || CFG_STATE_HPMEM_ABORT),
    .PCI_ADD_I(PCI_ADD), 
	
    .CFG_REG_0x04_O(CFG_REG_0x04), 
    .CFG_REG_0x10_O(CFG_REG_0x10), 
	.CFG_REG_0x11_O(CFG_REG_0x11),
    .CFG_REG_0x00_I(CFG_REG_0x00), 
    .CFG_REG_0x08_I(CFG_REG_0x08), 
    .CFG_REG_0x2C_I(CFG_REG_0x2C), 
	
    .CFG_PAR_REQ_O(CFG_PAR_REQ), 
    .CFG_FRAMEn_I(CFG_FRAMEn), 
    .CFG_IRDYn_I(CFG_IRDYn), 
    .CFG_TRDYn_O(CFG_TRDYn), 
    .CFG_TRDYn_DIR_O(CFG_TRDYn_DIR), 
    .CFG_DEVSELn_O(CFG_DEVSELn), 
    .CFG_DEVSELn_DIR_O(CFG_DEVSELn_DIR), 
    .CFG_STOPn_O(CFG_STOPn), 
    .CFG_STOPn_DIR_O(CFG_STOPn_DIR), 
    .CFG_AD_O(CFG_AD_I), 
    .CFG_AD_DIR_O(CFG_AD_DIR), 
    .CFG_AD_I(CFG_AD_O), 
    .CFG_CBEn_I(CFG_CBEn)
    );
	
	
	// Instantiate the module
PCI_DEFSM_MEM_MNG PCI_DEFSM_MEM_MNG0 (
    .PHY_CLK33_I(PHY_CLK33_I), 
    .PHY_RSTn_I(PHY_RSTn_I), 
	
    .DEFSM_MEM_END_O(DEFSM_MEM_END), 
    .MEM_WR_I(MEM_WR), 
    .DEFSM_ADD2MEM_I(DEFSM_ADD2MEM), 
    .MEM_OUTPUT_EN_O(MEM_OUTPUT_EN), 
    .PCI_ADD_I(PCI_ADD), 
	
    .CFG_REG_0x04_I(CFG_REG_0x04), 
    .CFG_STATE_MEM_ABORT_O(CFG_STATE_MEM_ABORT), 
	
    .MEM_PAR_REQ_O(MEM_PAR_REQ), 
    .MEM_FRAMEn_I(MEM_FRAMEn), 
    .MEM_IRDYn_I(MEM_IRDYn), 
    .MEM_TRDYn_O(MEM_TRDYn), 
    .MEM_TRDYn_DIR_O(MEM_TRDYn_DIR), 
    .MEM_DEVSELn_O(MEM_DEVSELn), 
    .MEM_DEVSELn_DIR_O(MEM_DEVSELn_DIR), 
    .MEM_STOPn_O(MEM_STOPn), 
    .MEM_STOPn_DIR_O(MEM_STOPn_DIR), 
    .MEM_AD_O(MEM_AD_I), 
    .MEM_AD_DIR_O(MEM_AD_DIR), 
    .MEM_AD_I(MEM_AD_O), 
    .MEM_CBEn_I(MEM_CBEn), 
	
    .WB_DATA_O(WB_DATA_O), 
    .WB_DATA_I(WB_DATA_I), 
    .WB_ACK_I(WB_ACK_I), 
    .WB_VALID_I(WB_VALID_I), 
    .WB_ADD_O(WB_ADD_O), 
    .WB_STB_O(WB_STB_O), 
    .WB_WE_O(WB_WE_O)
    );
	
	

	// Instantiate the module
PCI_DEFSM_HPMEM_MNG PCI_DEFSM_HPMEM_MNG0 (
    .PHY_CLK33_I(PHY_CLK33_I), 
    .PHY_RSTn_I(PHY_RSTn_I), 
	
    .DEFSM_HPMEM_END_O(DEFSM_HPMEM_END), 
    .HPMEM_WR_I(HPMEM_WR), 
    .DEFSM_ADD2HPMEM_I(DEFSM_ADD2HPMEM), 
    .HPMEM_OUTPUT_EN_O(HPMEM_OUTPUT_EN), 
    .PCI_ADD_I(PCI_ADD), 
	
    .CFG_REG_0x04_I(CFG_REG_0x04), 
    .CFG_STATE_HPMEM_ABORT_O(CFG_STATE_HPMEM_ABORT), 
	
    .HPMEM_PAR_REQ_O(HPMEM_PAR_REQ), 
	
    .HPMEM_FRAMEn_I(HPMEM_FRAMEn), 
    .HPMEM_IRDYn_I(HPMEM_IRDYn), 
	
    .HPMEM_TRDYn_O(HPMEM_TRDYn), 
    .HPMEM_TRDYn_DIR_O(HPMEM_TRDYn_DIR), 
    .HPMEM_DEVSELn_O(HPMEM_DEVSELn), 
    .HPMEM_DEVSELn_DIR_O(HPMEM_DEVSELn_DIR), 
    .HPMEM_STOPn_O(HPMEM_STOPn), 
    .HPMEM_STOPn_DIR_O(HPMEM_STOPn_DIR), 
    .HPMEM_AD_O(HPMEM_AD_I), 
    .HPMEM_AD_DIR_O(HPMEM_AD_DIR), 
	
    .HPMEM_AD_I(HPMEM_AD_O), 
    .HPMEM_CBEn_I(HPMEM_CBEn),
	
	
	.HP_MEM_IDLE_O(HP_MEM_IDLE_O),
	.HPRAM_DATA_I(HPRAM_DATA_I),
	.HPRAM_DATA_O(HPRAM_DATA_O),
	.HPRAM_ADD_O(HPRAM_ADD_O),
	.HPRAM_WEN_O(HPRAM_WEN_O)
	
	
    );


	// Instantiate the module
PCI_DEFSM_PAR PCI_DEFSM_PAR0 (
    .PHY_CLK33_I(PHY_CLK33_I), 
    .PHY_RSTn_I(PHY_RSTn_I), 
	
    .PGEN_PAR_I(PGEN_PAR_O), 
    .PGEN_PAR_O(PAR_O), 
    .PGEN_PAR_DIR_O(PAR_DIR_O), 
    .PGEN_AD_I(PGEN_AD_O), 
    .PGEN_CBEn_I(PGEN_CBEn), 
    .MEM_PAR_REQ_I(MEM_PAR_REQ),
    .HPMEM_PAR_REQ_I(HPMEM_PAR_REQ), 	
    .CFG_PAR_REQ_I(CFG_PAR_REQ)
    );

	
endmodule
