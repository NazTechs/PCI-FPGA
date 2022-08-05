`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2019 10:22:02 AM
// Design Name: 
// Module Name: FALC56_DEFSM
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


module FALC56_DEFSM(

	input  CLK_20MEG_FALC56_I,
	
	output 		 F56_RSTn_O ,
	input  [7:0] F56_DEFSM_BADD_I,
	output [7:0] F56_DEFSM_BADD_O,
	output   F56_BADD_DEFSM_DIR_O,

	output F56_DEFSM_ALE_O,
	output F56_DEFSM_RDn_O,
	output F56_DEFSM_WRn_O,
	output [1:0] F56_DEFSM_CSn_O,
	input  [1:0] F56_DEFSM_INT_I,
	
	input PHY_CLK33_I,
	input PHY_RSTn_I,
	
	//Wishbone Register
	
	input      [31:0]  WB0_ADD_I,
	output  [31:0]  WB0_DATA_O ,
	input      [31:0]  WB0_DATA_I,
	
	output  WB0_ACK_O ,
	output  WB0_VALID_O ,
	
	input WB0_STB_I,
	input WB0_WE_I,
	
	
	//Wishbone Register 2
	
	input      [31:0]  WB1_ADD_I,
	output  [31:0]  WB1_DATA_O ,
	input      [31:0]  WB1_DATA_I,
	
	output  WB1_ACK_O ,
	output  WB1_VALID_O ,
	
	input WB1_STB_I,
	input WB1_WE_I,
	

	
	//HPRAM CONTROL REGISTER INTERFACE
	
	input             HPRAM_WENA,
	input	          HPRAM_RENA,
	
	// HPRAM DATA REGISTER
	
		
	input [31:0] HPRAM_DATA_I,
	output reg [31:0] HPRAM_DATA_O = 0,
	output reg [11:0] HPRAM_ADD_O = 0,
	output reg  HPRAM_WEN_O = 0
	
    );
	
	
	// Instantiate the module
	
	//RESET MUST BE RESET SCURCE
FALC56_DCM FALC56_DCM_INS0 (
    .FALC56_DCM_CLK_I(CLK_20MEG_FALC56_I), 
    .FALC56_DCM_RST_I(~PHY_RSTn_I), 
    .FALC56_DCM_CLKFX_O(FALC56_DCM_CLKFX_O), 
    .FALC56_DCM_CLKIN_IBUF_O(FALC56_DCM_CLKIN_IBUF_O), 
    .FALC56_DCM_CLK0_O(FALC56_DCM_CLK0), 
    .FALC56_DCM_LOCKED_O(FALC56_DCM_LOCKED_O)
    );


	wire [7:0]  F56_WB_TYPE2_BADD_O;
	wire [1:0]  F56_WB_TYPE2_CSn;
	
	wire [7:0]  F56_WB0_BADD_O;
	wire [1:0]  F56_WB0_CSn;
	



// Instantiate the module
FALC56_WB_TYPE2 FALC56_WB_TYPE2_INS0 (
    .PHY_CLK33_I(PHY_CLK33_I), 
    .PHY_RSTn_I(PHY_RSTn_I),
	
    .WB_ADD_I(WB1_ADD_I), 
    .WB_DATA_O(WB1_DATA_O), 
    .WB_DATA_I(WB1_DATA_I), 
    .WB_ACK_O(WB1_ACK_O), 
    .WB_VALID_O(WB1_VALID_O), 
    .WB_STB_I(WB1_STB_I), 
    .WB_WE_I(WB1_WE_I), 
	
		
    .F56_WB_REQ_O(F56_WB_T2_REQ),
	.F56_WB_GNT_I(F56_WB_T2_GNT),
	
    .F56_BADD_I(F56_DEFSM_BADD_I), 
    .F56_BADD_O(F56_WB_TYPE2_BADD_O), 
    .F56_BADD_DIR_O(F56_WB_TYPE2_BADD_DIR), 
    .F56_ALE_O(F56_WB_TYPE2_ALE), 
    .F56_RDn_O(F56_WB_TYPE2_RDn), 
    .F56_WRn_O(F56_WB_TYPE2_WRn), 
    .F56_CSn_O(F56_WB_TYPE2_CSn)
    );
	
	
	// Instantiate the module
FLAC56_WB FLAC56_WB0 (
    .PHY_CLK33_I(PHY_CLK33_I), 
    .PHY_RSTn_I(PHY_RSTn_I),
	
    .WB_ADD_I(WB0_ADD_I), 
    .WB_DATA_O(WB0_DATA_O), 
    .WB_DATA_I(WB0_DATA_I), 
    .WB_ACK_O(WB0_ACK_O), 
    .WB_VALID_O(WB0_VALID_O), 
    .WB_STB_I(WB0_STB_I), 
    .WB_WE_I(WB0_WE_I), 
	
    .F56_WB_REQ_O(F56_WB0_REQ),
	.F56_WB_GNT_I(F56_WB0_GNT),
	
    .F56_BADD_I(F56_DEFSM_BADD_I), 
    .F56_BADD_O(F56_WB0_BADD_O), 
    .F56_BADD_DIR_O(F56_BADD_WB0_DIR), 
    .F56_ALE_O(F56_WB0_ALE), 
    .F56_RDn_O(F56_WB0_RDn), 
    .F56_WRn_O(F56_WB0_WRn), 
    .F56_CSn_O(F56_WB0_CSn), 
	
	.F56_RSTn_O(F56_RSTn_O),
    .F56_INT_I(F56_DEFSM_INT_I)
    );
	
	
	
	// Instantiate the module
FALC56_ENCODER FALC56_ENCODER0 (
    .FALC56_DCM_CLK0_I(FALC56_DCM_CLK0), 
	
    .PHY_RSTn_I(PHY_RSTn_I), 
    .PHY_CLK33_I(PHY_CLK33_I), 
	
    .F56_DEFSM_BADD_O(F56_DEFSM_BADD_O), 
    .F56_BADD_DEFSM_DIR_O(F56_BADD_DEFSM_DIR_O), 
    .F56_DEFSM_ALE_O(F56_DEFSM_ALE_O), 
    .F56_DEFSM_RDn_O(F56_DEFSM_RDn_O), 
    .F56_DEFSM_WRn_O(F56_DEFSM_WRn_O), 
    .F56_DEFSM_CSn_O(F56_DEFSM_CSn_O), 
	
    .F56_WB_T2_REQ_I(F56_WB_T2_REQ), 
    .F56_WB_T2_GNT_O(F56_WB_T2_GNT), 
	
    .F56_WB_REQ_I(F56_WB0_REQ), 
    .F56_WB_GNT_O(F56_WB0_GNT), 
	
    .F56_DMA0_REQ_I(), 
    .F56_DMA0_GNT_O(), 
	
    .F56_WB_BADD_I(F56_WB0_BADD_O), 
    .F56_WB_BADD_DIR_I(F56_BADD_WB0_DIR), 
    .F56_WB_ALE_I(F56_WB0_ALE), 
    .F56_WB_RDn_I(F56_WB0_RDn), 
    .F56_WB_WRn_I(F56_WB0_WRn), 
    .F56_WB_CSn_I(F56_WB0_CSn), 
	
    .F56_WB_T2_BADD_I(F56_WB_TYPE2_BADD_O), 
    .F56_WB_T2_BADD_DIR_I(F56_WB_TYPE2_BADD_DIR), 
    .F56_WB_T2_ALE_I(F56_WB_TYPE2_ALE), 
    .F56_WB_T2_RDn_I(F56_WB_TYPE2_RDn), 
    .F56_WB_T2_WRn_I(F56_WB_TYPE2_WRn), 
    .F56_WB_T2_CSn_I(F56_WB_TYPE2_CSn), 
	
    .F56_DMA0_BADD_I(), 
    .F56_DMA0_BADD_DIR_I(), 
    .F56_DMA0_ALE_I(), 
    .F56_DMA0_RDn_I(), 
    .F56_DMA0_WRn_I(), 
    .F56_DMA0_CSn_I()
    );




	
endmodule
