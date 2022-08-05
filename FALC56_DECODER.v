`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2019 07:06:56 PM
// Design Name: 
// Module Name: FALC56_DECODER
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

// CROSS CLK
module FALC56_DECODER(
	input FALC56_DCM_CLK0_I,
	input PHY_RSTn_I, 
	input PHY_CLK33_I,
	

	//Wishbone Register
	
	input      [31:0]  WB_ADD_I,
	output reg [31:0]  WB_DATA_O = 0,
	input      [31:0]  WB_DATA_I,
	
	output reg WB_ACK_O = 0,
	output reg WB_VALID_O = 0,
	
	input WB_STB_I,
	input WB_WE_I,
	
	
	input  [7:0] F56_DEFSM_BADD_I,
	input  [1:0] F56_DEFSM_INT_I,
	//Wishbone Register
	input      [31:0]  WB_ADD_I,
	input      [31:0]  WB_DATA_I,
	
	input WB_STB_I,
	input WB_WE_I,
	


	output      [31:0]  F56_WB_ADD_O,
	output      [31:0]  F56_WB_DATA_O,
	
	output F56_WB_STB_O,
	output F56_WB_WE_O,
	// F56 BUS
	output  	   [7:0] F56_WB_BADD_O
	
	
	
    );
	
	always @(*)
		begin
			F56_WB_ADD_O = WB_ADD_I;
			F56_WB_DATA_O = WB_DATA_I;
			
			F56_WB_STB_O = WB_STB_I;
			F56_WB_WE_O = WB_WE_I;
			
			
			F56_WB_BADD_O = F56_DEFSM_BADD_I;
		
		end
	
endmodule
