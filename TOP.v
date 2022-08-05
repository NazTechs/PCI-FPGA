`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2018 05:24:15 PM
// Design Name: 
// Module Name: TOP
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


module TOP(
	
	input PCI_RSTn_I,
	input PCI_CLK_I,
	input PCI_IDSEL_I,
	
	inout PCI_FRAMEn_IO,
	inout PCI_IRDYn_IO,
	inout PCI_TRDYn_IO,
	inout PCI_DEVSELn_IO,
	inout PCI_STOPn_IO,
	inout PCI_PAR_IO,
	inout PCI_PERRn_IO,
	inout PCI_SERRn_IO,
	inout PCI_REQn_IO,
	inout PCI_GNTn_IO,
	
	inout [31:0] PCI_AD_IO ,
	inout [3:0]  PCI_CBE_IO,
	
	inout   PCI_INTAn,
	
	//FALC45 BUS
	
	input CLK_20MEG_FALC56_I,
	
	output F56_RSTn_O,
	inout [7:0] FALC56_BADD_IO,
	inout FALC56_ALE_IO,
	inout FALC56_RDn_IO,
	inout FALC56_WRn_IO,
	inout [1:0] FALC56_CSn_IO,
	inout [1:0] FALC56_INT_IO,
	
	output [1:0] wb_led
	
	
	

    );
	
	wire [31:0] AD_I;
	wire [31:0] AD_O;
	
	wire [3:0] CBEn_O;
	// Instantiate the PCI_TPHY module
	
PCI_TPHY PCI_TPHY0 (
    .PCI_RSTn_I(PCI_RSTn_I), 
    .PCI_CLK_I(PCI_CLK_I), 
    .PCI_IDSEL_I(PCI_IDSEL_I), 
    .PCI_FRAMEn_IO(PCI_FRAMEn_IO), 
    .PCI_IRDYn_IO(PCI_IRDYn_IO), 
    .PCI_TRDYn_IO(PCI_TRDYn_IO), 
    .PCI_DEVSELn_IO(PCI_DEVSELn_IO), 
    .PCI_STOPn_IO(PCI_STOPn_IO), 
    .PCI_PAR_IO(PCI_PAR_IO), 
    .PCI_PERRn_IO(PCI_PERRn_IO), 
    .PCI_SERRn_IO(PCI_SERRn_IO),
	 .PCI_REQn_IO(PCI_REQn_IO),
	 .PCI_GNTn_IO(PCI_GNTn_IO),	 
    .PCI_AD_IO(PCI_AD_IO), 
    .PCI_CBE_IO(PCI_CBE_IO), 
    .PCI_INTAn(PCI_INTAn), 
		
	
    .PHY_CLK33_O(PHY_CLK33_O), 
    .PHY_RSTn_O(PHY_RSTn_O), 
    .IDSEL_O(IDSEL_O), 
    .FRAMEn_O(FRAMEn_O), 
    .IRDYn_O(IRDYn_O), 
    .TRDYn_I(TRDYn_I), 
    .TRDYn_DIR_I(TRDYn_DIR_I), 
    .DEVSELn_I(DEVSELn_I), 
    .DEVSELn_DIR_I(DEVSELn_DIR_I), 
    .STOPn_I(STOPn_I), 
    .STOPn_DIR_I(STOPn_DIR_I), 
    .PAR_O(PAR_O), 
    .PAR_I(PAR_I), 
    .PAR_DIR_I(PAR_DIR_I), 
    .PERRn_I(PERRn_I), 
    .PERRn_DIR_I(PERRn_DIR_I), 
    .SERRn_I(SERRn_I), 
    .SERRn_DIR_I(SERRn_DIR_I), 
    .AD_I(AD_I), 
    .AD_DIR_I(AD_DIR_I), 
    .AD_O(AD_O), 
    .CBEn_O(CBEn_O), 
    .INTA_I(INTA_I)
    );

	wire [31:0] M0_WB_DATA_O;
	wire [31:0] M0_WB_DATA_I;
	wire [31:0] M0_WB_ADD;


	
	wire [11:0] HPRAM_ADD_O;
	wire [31:0] HPRAM_DATA_O;
	wire [31:0] HPRAM_DATA_I;
	wire [3:0]  HPRAM_WEN_O;
// Instantiate the PCI_WB_INTERFACE module 
PCI_WB_DeFSM #(
  .DEVICE_ID 		      ( 16'hBBCC),
  .VENDOR_ID 		      ( 16'h00AA),
  .DEVICE_CLASS 		  ( 24'h118000),
  .DEVICE_REV  		      ( 8'hF8),
  .SUBSYSTEM_ID 		  ( 16'h0001),
  .SUBSYSTEM_VENDOR_ID    ( 16'h9876)
)
 PCI_WB_DeFSM (
    .PHY_CLK33_I(PHY_CLK33_O), 
    .PHY_RSTn_I(PHY_RSTn_O), 
    .IDSEL_I(IDSEL_O), 
    .FRAMEn_I(FRAMEn_O), 
    .IRDYn_I(IRDYn_O), 
    .TRDYn_O(TRDYn_I), 
    .TRDYn_DIR_O(TRDYn_DIR_I), 
    .DEVSELn_O(DEVSELn_I), 
    .DEVSELn_DIR_O(DEVSELn_DIR_I), 
    .STOPn_O(STOPn_I), 
    .STOPn_DIR_O(STOPn_DIR_I), 
    .PAR_I(PAR_O), 
    .PAR_O(PAR_I), 
    .PAR_DIR_O(PAR_DIR_I), 
    .PERRn_O(PERRn_I), 
    .PERRn_DIR_O(PERRn_DIR_I), 
    .SERRn_O(SERRn_I), 
    .SERRn_DIR_O(SERRn_DIR_I), 
    .AD_O(AD_I), 
    .AD_DIR_O(AD_DIR_I), 
    .AD_I(AD_O), 
    .CBEn_I(CBEn_O),
	.INTA_O(INTA_I), 
	
	
		// MASTER WISHBONE SIGNALS
	
    .WB_DATA_O(M0_WB_DATA_O), 
    .WB_DATA_I(M0_WB_DATA_I), 
    .WB_ACK_I(M0_WB_ACK), 
    .WB_VALID_I(M0_WB_VALID), 
    .WB_ADD_O(M0_WB_ADD), 
    .WB_STB_O(M0_WB_STB), 
    .WB_WE_O(M0_WB_WE), 
	
	
		// HPRAM BUS
	.HP_MEM_IDLE_O(HP_MEM_IDLE),
    .HPRAM_DATA_I(HPRAM_DATA_I), 
    .HPRAM_DATA_O(HPRAM_DATA_O), 
    .HPRAM_ADD_O(HPRAM_ADD_O), 
    .HPRAM_WEN_O(HPRAM_WEN_O)
	 
	 //.wb_led(wb_led)
    );

	
	wire [31:0] S0_WB_ADD;
	wire [31:0] S0_WB_DATA_O;
	wire [31:0] S0_WB_DATA_I;
	
	wire [31:0] S1_WB_ADD;
	wire [31:0] S1_WB_DATA_O;
	wire [31:0] S1_WB_DATA_I;
	
	
	wire [31:0] S2_WB_ADD;
	wire [31:0] S2_WB_DATA_O;
	wire [31:0] S2_WB_DATA_I;
	
	
	wire [31:0] S3_WB_ADD;
	wire [31:0] S3_WB_DATA_O;
	wire [31:0] S3_WB_DATA_I;
	
	
	wire [31:0] S4_WB_ADD;
	wire [31:0] S4_WB_DATA_O;
	wire [31:0] S4_WB_DATA_I;
// Instantiate the module WB_INTERN
WB_INTERN WB_INTERN0 (
    .PHY_CLK33_I(PHY_CLK33_O), 
    .PHY_RSTn_I(PHY_RSTn_O), 
	 
    .M0_WB_ADD_I(M0_WB_ADD), 
    .M0_WB_DATA_O(M0_WB_DATA_I), 
    .M0_WB_DATA_I(M0_WB_DATA_O), 
    .M0_WB_ACK_O(M0_WB_ACK), 
    .M0_WB_VALID_O(M0_WB_VALID), 
    .M0_WB_STB_I(M0_WB_STB), 
    .M0_WB_WE_I(M0_WB_WE), 
	 
	 
    .S0_WB_ADD_O(S0_WB_ADD), 
    .S0_WB_DATA_O(S0_WB_DATA_O), 
    .S0_WB_DATA_I(S0_WB_DATA_I), 
    .S0_WB_ACK_I(S0_WB_ACK), 
    .S0_WB_VALID_I(S0_WB_VALID), 
    .S0_WB_STB_O(S0_WB_STB), 
    .S0_WB_WE_O(S0_WB_WE),
	
	.S1_WB_ADD_O(S1_WB_ADD), 
    .S1_WB_DATA_O(S1_WB_DATA_O), 
    .S1_WB_DATA_I(S1_WB_DATA_I), 
    .S1_WB_ACK_I(S1_WB_ACK), 
    .S1_WB_VALID_I(S1_WB_VALID), 
    .S1_WB_STB_O(S1_WB_STB), 
    .S1_WB_WE_O(S1_WB_WE),
	
	.S2_WB_ADD_O(S2_WB_ADD), 
    .S2_WB_DATA_O(S2_WB_DATA_O), 
    .S2_WB_DATA_I(S2_WB_DATA_I), 
    .S2_WB_ACK_I(S2_WB_ACK), 
    .S2_WB_VALID_I(S2_WB_VALID), 
    .S2_WB_STB_O(S2_WB_STB), 
    .S2_WB_WE_O(S2_WB_WE),
	
	.S3_WB_ADD_O(S3_WB_ADD), 
    .S3_WB_DATA_O(S3_WB_DATA_O), 
    .S3_WB_DATA_I(S3_WB_DATA_I), 
    .S3_WB_ACK_I(S3_WB_ACK), 
    .S3_WB_VALID_I(S3_WB_VALID), 
    .S3_WB_STB_O(S3_WB_STB), 
    .S3_WB_WE_O(S3_WB_WE),
	
	.S4_WB_ADD_O(S4_WB_ADD), 
    .S4_WB_DATA_O(S4_WB_DATA_O), 
    .S4_WB_DATA_I(S4_WB_DATA_I), 
    .S4_WB_ACK_I(S4_WB_ACK), 
    .S4_WB_VALID_I(S4_WB_VALID), 
    .S4_WB_STB_O(S4_WB_STB), 
    .S4_WB_WE_O(S4_WB_WE)
    );
	 
	 
	 
// Instantiate the module
WB_LED_SLAVE WB_LED_SLAVE0 (
    .PHY_CLK33_I(PHY_CLK33_O), 
    .PHY_RSTn_I(PHY_RSTn_O),
	 
    .WB_ADD_I(S0_WB_ADD), 
    .WB_DATA_O(S0_WB_DATA_I), 
    .WB_DATA_I(S0_WB_DATA_O), 
    .WB_ACK_O(S0_WB_ACK), 
    .WB_VALID_O(S0_WB_VALID), 
    .WB_STB_I(S0_WB_STB), 
    .WB_WE_I(S0_WB_WE) ,
    .wb_led(wb_led)
    );
	
	
// Instantiate the module
WB_DEBUG_SLAVE WB_DEBUG_SLAVE0 (
    .PHY_CLK33_I(PHY_CLK33_O), 
    .PHY_RSTn_I(PHY_RSTn_O),
	
    .WB_ADD_I(S1_WB_ADD), 
    .WB_DATA_O(S1_WB_DATA_I), 
    .WB_DATA_I(S1_WB_DATA_O), 
    .WB_ACK_O(S1_WB_ACK), 
    .WB_VALID_O(S1_WB_VALID), 
    .WB_STB_I(S1_WB_STB), 
    .WB_WE_I(S1_WB_WE), 
	
    .DBG_PCI_FRAMEn_I(PCI_FRAMEn_IO), 
    .DBG_PCI_IRDYn_I(PCI_IRDYn_IO), 
    .DBG_PCI_TRDYn_I(PCI_TRDYn_IO), 
    .DBG_PCI_DEVSELn_I(PCI_DEVSELn_IO), 
    .DBG_PCI_STOPn_I(PCI_STOPn_IO), 
    .DBG_PCI_PAR_I(PCI_PAR_IO), 
    .DBG_PCI_PERRn_I(PCI_PERRn_IO), 
    .DBG_PCI_SERRn_I(PCI_SERRn_IO), 
    .DBG_PCI_REQn_I(PCI_REQn_IO), 
    .DBG_PCI_GNTn_I(PCI_GNTn_IO), 
    .DBG_PCI_IDSEL_I(PCI_IDSEL_I)
    );

	wire [11:0] F56RAM_ADD_I;
	wire [31:0] F56RAM_DATA_O;
	wire [31:0] F56RAM_DATA_I;
	wire [3:0] 	F56RAM_WEN_I;
	
 

 

 
// Instantiate the module
MEM_BANK_MNG MEM_BANK_MNG0 (
    .PHY_CLK33_I(PHY_CLK33_O), 
    .PHY_RSTn_I(PHY_RSTn_O), 
	
    .WB_ADD_I(S4_WB_ADD), 
    .WB_DATA_O(S4_WB_DATA_I), 
    .WB_DATA_I(S4_WB_DATA_O), 
    .WB_ACK_O(S4_WB_ACK), 
    .WB_VALID_O(S4_WB_VALID), 
    .WB_STB_I(S4_WB_STB), 
    .WB_WE_I(S4_WB_WE), 
	
    .HP_MEM_IDLE_I(HP_MEM_IDLE), 
    .FL56_BRAM_ENABLE_O(), 
	
    .HPRAM_DATA_I(HPRAM_DATA_O), 
    .HPRAM_DATA_O(HPRAM_DATA_I), 
    .HPRAM_ADD_I(HPRAM_ADD_O), 
    .HPRAM_WEN_I(HPRAM_WEN_O),
	
    .F56RAM_DATA_I(F56RAM_DATA_I), 
    .F56RAM_DATA_O(F56RAM_DATA_O), 
    .F56RAM_ADD_I(F56RAM_ADD_I), 
    .F56RAM_WEN_I(F56RAM_WEN_I)
    );

	


	
	wire [7:0] F56_BADD_I;
	wire [7:0] F56_BADD_O;
	wire [1:0] F56_CSn;
	wire [1:0] F56_INT;

	// Instantiate the module
	FALC56_PHY FALC56_PHY0 (
		.FALC56_BADD_IO(FALC56_BADD_IO), 
		.FALC56_ALE_IO(FALC56_ALE_IO), 
		.FALC56_RDn_IO(FALC56_RDn_IO), 
		.FALC56_WRn_IO(FALC56_WRn_IO), 
		.FALC56_CSn_IO(FALC56_CSn_IO), 
		.FALC56_INT_IO(FALC56_INT_IO),
		
		.F56_BADD_I(F56_BADD_I), 
		.F56_BADD_O(F56_BADD_O), 
		.F56_BADD_DIR_I(F56_BADD_DIR), 
		.F56_ALE_I(F56_ALE), 
		.F56_RDn_I(F56_RDn), 
		.F56_WRn_I(F56_WRn), 
		.F56_CSn_I(F56_CSn), 
		.F56_INT_O(F56_INT)
		);
		
	// Instantiate the module
FALC56_DEFSM FALC56_DEFSM_INS0 (
    .CLK_20MEG_FALC56_I(CLK_20MEG_FALC56_I),
	
	.F56_RSTn_O(F56_RSTn_O),
    .F56_DEFSM_BADD_I(F56_BADD_O), 
    .F56_DEFSM_BADD_O(F56_BADD_I), 
    .F56_BADD_DEFSM_DIR_O(F56_BADD_DIR), 
    .F56_DEFSM_ALE_O(F56_ALE), 
    .F56_DEFSM_RDn_O(F56_RDn), 
    .F56_DEFSM_WRn_O(F56_WRn), 
    .F56_DEFSM_CSn_O(F56_CSn), 
    .F56_DEFSM_INT_I(F56_INT), 
	
    .PHY_CLK33_I(PHY_CLK33_O), 
    .PHY_RSTn_I(PHY_RSTn_O), 
	
	
    .WB0_ADD_I(S2_WB_ADD), 
    .WB0_DATA_O(S2_WB_DATA_I), 
    .WB0_DATA_I(S2_WB_DATA_O), 
    .WB0_ACK_O(S2_WB_ACK), 
    .WB0_VALID_O(S2_WB_VALID), 
    .WB0_STB_I(S2_WB_STB), 
    .WB0_WE_I(S2_WB_WE), 
	
	.WB1_ADD_I(S3_WB_ADD), 
    .WB1_DATA_O(S3_WB_DATA_I), 
    .WB1_DATA_I(S3_WB_DATA_O), 
    .WB1_ACK_O(S3_WB_ACK), 
    .WB1_VALID_O(S3_WB_VALID), 
    .WB1_STB_I(S3_WB_STB), 
    .WB1_WE_I(S3_WB_WE), 
	
    .HPRAM_WENA(HPRAM_WENA), 
    .HPRAM_RENA(HPRAM_RENA), 
    .HPRAM_DATA_I(HPRAM_DATA_B_I), 
    .HPRAM_DATA_O(HPRAM_DATA_B_O), 
    .HPRAM_ADD_O(HPRAM_ADD_B_O), 
    .HPRAM_WEN_O(HPRAM_WEN_B_O)
    );

	
endmodule
