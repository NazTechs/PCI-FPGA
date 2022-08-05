`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2018 11:47:36 AM
// Design Name: 
// Module Name: PCI_IN_DECODER
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


module PCI_IN_DECODER(

	input PHY_CLK33_I,
	input PHY_RSTn_I,
	
	input IDSEL_I,
	input  FRAMEn_I,
	input  IRDYn_I,
	input [31:0]  AD_I,
	input [3:0] CBEn_I,
	input PAR_I,
	
	output   reg   ADD_IDSEL_O ,
	output   reg   ADD_FRAMEn_O ,
	output   reg   ADD_IRDYn_O ,
	output   reg   [31:0]  ADD_AD_O ,
	output   reg   [3:0] ADD_CBEn_O ,
	
	output   reg  CFG_FRAMEn_O,
	output   reg  CFG_IRDYn_O,
	output   reg [31:0]  CFG_AD_O ,
	output   reg [3:0] CFG_CBEn_O ,
	
	output   reg  MEM_FRAMEn_O,
	output   reg  MEM_IRDYn_O,
	output   reg [31:0]  MEM_AD_O ,
	output   reg [3:0] MEM_CBEn_O ,
	
	
	output   reg  HPMEM_FRAMEn_O,
	output   reg  HPMEM_IRDYn_O,
	output   reg [31:0]  HPMEM_AD_O ,
	output   reg [3:0] HPMEM_CBEn_O ,
	
    output  reg PGEN_PAR_O, 
    output  reg [31:0]  PGEN_AD_O, 
    output  reg [3:0]   PGEN_CBEn_O
	
    );
	
	always @(*)
		begin
			ADD_IDSEL_O <= IDSEL_I;
			ADD_FRAMEn_O <= FRAMEn_I;
			ADD_IRDYn_O <= IRDYn_I;
			ADD_AD_O <= AD_I;
			ADD_CBEn_O <= CBEn_I;
			
			CFG_FRAMEn_O <= FRAMEn_I;
			CFG_IRDYn_O  <= IRDYn_I;
			CFG_AD_O     <= AD_I;
			CFG_CBEn_O   <= CBEn_I;
			
			MEM_FRAMEn_O <= FRAMEn_I;
			MEM_IRDYn_O  <= IRDYn_I;
			MEM_AD_O     <= AD_I;
			MEM_CBEn_O   <= CBEn_I;
			
			HPMEM_FRAMEn_O <= FRAMEn_I;
			HPMEM_IRDYn_O  <= IRDYn_I;
			HPMEM_AD_O     <= AD_I;
			HPMEM_CBEn_O   <= CBEn_I;
			
			PGEN_PAR_O   <= PAR_I;
			PGEN_AD_O    <= AD_I;
			PGEN_CBEn_O  <= CBEn_I;
		end
endmodule
