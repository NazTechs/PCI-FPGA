`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2019 06:13:23 PM
// Design Name: 
// Module Name: PCI_DEFSM_INT_MNG
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


module PCI_DEFSM_INT_MNG(

	input PHY_CLK33_I,
	input PHY_RSTn_I,
	
	output reg DEFSM_INTMNG_END_O = 0,
	input      DEFSM_ADD2INTMNG_I,
	output reg INTMNG_OUTPUT_EN_O = 0,
	
	input CFG_REG_0x04_INT_DIS_I,
	output reg CFG_REG_0x04_INT_STAT = 0,
	
	input  INT_FRAMEn_I,
	input  INT_IRDYn_I,
	
	output reg   INT_TRDYn_O = 1,
	output reg   INT_TRDYn_DIR_O = 0,
	output reg   INT_DEVSELn_O = 1,
	output reg   INT_DEVSELn_DIR_O = 0,
	output reg   INT_STOPn_O = 1 ,
	output reg   INT_STOPn_DIR_O = 0,
	
	output reg  [31:0]  CFG_AD_O = 0,
	output reg          CFG_AD_DIR_O = 0,
	input [31:0]        CFG_AD_I,
	
	input [3:0]         CFG_CBEn_I
	
	
    );
endmodule
