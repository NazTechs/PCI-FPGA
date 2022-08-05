`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2019 10:22:02 AM
// Design Name: 
// Module Name: FALC56_PHY
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


module FALC56_PHY(
	inout [7:0] FALC56_BADD_IO,
	inout FALC56_ALE_IO,
	inout FALC56_RDn_IO,
	inout FALC56_WRn_IO,
	inout [1:0] FALC56_CSn_IO,
	inout [1:0] FALC56_INT_IO,
	
	input  [7:0] F56_BADD_I,
	output [7:0] F56_BADD_O,
	input   F56_BADD_DIR_I,

	input F56_ALE_I,
	input F56_RDn_I,
	input F56_WRn_I,
	input [1:0] F56_CSn_I,
	output[1:0] F56_INT_O
    );
	
	assign FALC56_BADD_IO = (F56_BADD_DIR_I == 1) ? F56_BADD_I : 8'hz;
	assign F56_BADD_O     = FALC56_BADD_IO;
	assign FALC56_ALE_IO = 1 ? F56_ALE_I : 1'bz;
	assign FALC56_RDn_IO = 1 ? F56_RDn_I : 1'bz;
	assign FALC56_WRn_IO = 1 ? F56_WRn_I : 1'bz;
	assign FALC56_CSn_IO = 1 ? F56_CSn_I : 1'bz;
	assign F56_INT_O     = FALC56_INT_IO;
	
	
	
	
endmodule
