`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2019 12:01:44 AM
// Design Name: 
// Module Name: FALC56_DMA_ENGINE
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


module FALC56_DMA_ENGINE(


	input  [7:0] F56_DMA_BADD_I,
	output [7:0] F56_DMA_BADD_O,
	input   F56_BADD_DMA_DIR_I,

	input F56_DMA_ALE_I,
	input F56_DMA_RDn_I,
	input F56_DMA_WRn_I,
	input [1:0] F56_DMA_CSn_I,
	
	//HPRAM INTERFACE
	
	input [31:0] HPRAM_DATA_I,
	output reg [31:0] HPRAM_DATA_O = 0,
	output reg [11:0] HPRAM_ADD_O = 0,
	output reg  HPRAM_WEN_O = 0,
	
	output reg DMA_BUS_REQ_O = 0,
	input  DMA_BUS_GNT_I,
	output reg DMA_OUTPUT_EN_O = 0,
	
	
	input [12:0] DMA_SRC_ADD_I,
	input [12:0] DMA_DST_ADD_I,
	input        DMA_DATA_DIR_I,
	input [7:0]  DMA_CMD_I,
	output reg   [7:0] DMA_STATE_O,
	output reg   DMA_INT_REQ_O
	
	
	
    );
endmodule
