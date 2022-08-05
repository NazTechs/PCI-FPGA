`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2018 03:27:03 PM
// Design Name: 
// Module Name: PCI_TPHY
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


module PCI_TPHY(

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
	
	output  PHY_CLK33_O,
	output  PHY_RSTn_O,
	output  IDSEL_O,
	
	output  FRAMEn_O,
	output  IRDYn_O,
	
	input   TRDYn_I,
	input   TRDYn_DIR_I,
	input   DEVSELn_I,
	input   DEVSELn_DIR_I,
	input   STOPn_I,
	input   STOPn_DIR_I,
	output  PAR_O,
	input   PAR_I,
	input   PAR_DIR_I,
	input   PERRn_I,
	input   PERRn_DIR_I,
	input   SERRn_I,
	input   SERRn_DIR_I,
	
	input  [31:0]  AD_I,
	input  AD_DIR_I,
	output [31:0]  AD_O,
	
	output [3:0] CBEn_O,
	
	input INTA_I
	
    );
	 
	 
	 assign PHY_CLK33_O = PCI_CLK_I;
	 assign PHY_RSTn_O = PCI_RSTn_I;
	 assign IDSEL_O = PCI_IDSEL_I;
	 
	 assign PCI_FRAMEn_IO = 1'bz;
	 assign FRAMEn_O = PCI_FRAMEn_IO;
	 
	 assign PCI_IRDYn_IO = 1'bz;
	 assign IRDYn_O = PCI_IRDYn_IO;
	 
	 assign PCI_TRDYn_IO = (TRDYn_DIR_I) ? TRDYn_I : 1'bz;
	  
	 assign PCI_DEVSELn_IO = (DEVSELn_DIR_I) ? DEVSELn_I : 1'bz;

	 assign PCI_STOPn_IO = (STOPn_DIR_I) ? STOPn_I : 1'bz;
	 
	 assign PCI_PAR_IO = (PAR_DIR_I) ? PAR_I : 1'bz;
	 assign PAR_O = PCI_PAR_IO;
	 
	 assign PCI_PERRn_IO = (PERRn_DIR_I) ? PERRn_I : 1'bz;
	 
	 assign PCI_SERRn_IO = (SERRn_DIR_I) ? SERRn_I : 1'bz;
	 
	 assign PCI_AD_IO = (AD_DIR_I) ? AD_I : 32'hzzzz_zzzz;
	 assign AD_O = PCI_AD_IO;
	 
	 assign PCI_CBE_IO = 4'bzzzz;
	 assign CBEn_O = PCI_CBE_IO;
	
	 assign PCI_INTAn = (INTA_I == 1) ? 1'b0 : 1'bz;
	 
	 assign PCI_REQn_IO = 1'bz;
	 assign PCI_GNTn_IO = 1'bz;
	 
endmodule
