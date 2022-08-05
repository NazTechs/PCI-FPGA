`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2018 11:59:35 AM
// Design Name: 
// Module Name: PCI_OUT_ENCODER
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


module PCI_OUT_ENCODER(
	input PHY_CLK33_I,
	input PHY_RSTn_I,
	
	output reg   TRDYn_O = 1,
	output reg   TRDYn_DIR_O = 0,
	output reg   DEVSELn_O = 1,
	output reg   DEVSELn_DIR_O = 0,
	output reg   STOPn_O = 1 ,
	output reg   STOPn_DIR_O = 0,
	
	output reg  [31:0]  AD_O = 0,
	output reg  AD_DIR_O = 0,
	
	output reg INTA_O = 0,
	
	input   ADD_TRDYn_I,
	input   ADD_TRDYn_DIR_I,
	input   ADD_DEVSELn_I,
	input   ADD_DEVSELn_DIR_I,
	input   ADD_STOPn_I,
	input   ADD_STOPn_DIR_I,
	
	input   CFG_TRDYn_I,
	input   CFG_TRDYn_DIR_I,
	input   CFG_DEVSELn_I,
	input   CFG_DEVSELn_DIR_I,
	input   CFG_STOPn_I,
	input   CFG_STOPn_DIR_I,
	
	input               CFG_AD_DIR_I,
	input [31:0]        CFG_AD_I,
	
	
    input   MEM_TRDYn_I,
	input   MEM_TRDYn_DIR_I,
	input   MEM_DEVSELn_I,
	input   MEM_DEVSELn_DIR_I,
	input   MEM_STOPn_I,
	input   MEM_STOPn_DIR_I,
	
	input               MEM_AD_DIR_I,
	input [31:0]        MEM_AD_I,
	
	
	input   HPMEM_TRDYn_I,
	input   HPMEM_TRDYn_DIR_I,
	input   HPMEM_DEVSELn_I,
	input   HPMEM_DEVSELn_DIR_I,
	input   HPMEM_STOPn_I,
	input   HPMEM_STOPn_DIR_I,
	
	input               HPMEM_AD_DIR_I,
	input [31:0]        HPMEM_AD_I,
	
	input ADD_OUTPUT_EN_I,
	input CFG_OUTPUT_EN_I,
	input MEM_OUTPUT_EN_I,
	input HPMEM_OUTPUT_EN_I
	
    );
	
	wire NO_EN = ~(ADD_OUTPUT_EN_I == 1 || CFG_OUTPUT_EN_I == 1 
	|| MEM_OUTPUT_EN_I == 1 || HPMEM_OUTPUT_EN_I == 1);
	always @(*) //-- ASYNCRONUS DESIGN -- WORKING BUT NOT RECOMMENDE
	//always @( negedge PHY_CLK33_I)
		if (PHY_RSTn_I == 0 || NO_EN == 1)
			begin
				TRDYn_O = 1;
				TRDYn_DIR_O = 0;
				DEVSELn_O = 1;
				DEVSELn_DIR_O = 0;
				STOPn_O = 1 ;
				STOPn_DIR_O = 0;
			    AD_O = 0;
				AD_DIR_O = 0;
				INTA_O = 0;
			end
		else if (ADD_OUTPUT_EN_I == 1)
			begin
				AD_DIR_O = 0;
				TRDYn_O = ADD_TRDYn_I;
				TRDYn_DIR_O = ADD_TRDYn_DIR_I;
				DEVSELn_O = ADD_DEVSELn_I;
				DEVSELn_DIR_O = ADD_DEVSELn_DIR_I;
				STOPn_O = ADD_STOPn_I ;
				STOPn_DIR_O = ADD_STOPn_DIR_I;
			end
		else if (CFG_OUTPUT_EN_I == 1)
			begin
				TRDYn_O = CFG_TRDYn_I;
				TRDYn_DIR_O = CFG_TRDYn_DIR_I;
				DEVSELn_O = CFG_DEVSELn_I;
				DEVSELn_DIR_O = CFG_DEVSELn_DIR_I;
				STOPn_O = CFG_STOPn_I ;
				STOPn_DIR_O = CFG_STOPn_DIR_I;
				AD_O = CFG_AD_I;
				AD_DIR_O = CFG_AD_DIR_I;
			end
		else if (MEM_OUTPUT_EN_I == 1)
			begin
				TRDYn_O = MEM_TRDYn_I;
				TRDYn_DIR_O = MEM_TRDYn_DIR_I;
				DEVSELn_O = MEM_DEVSELn_I;
				DEVSELn_DIR_O = MEM_DEVSELn_DIR_I;
				STOPn_O = MEM_STOPn_I ;
				STOPn_DIR_O = MEM_STOPn_DIR_I;
				AD_O = MEM_AD_I;
				AD_DIR_O = MEM_AD_DIR_I;
			end
		else if (HPMEM_OUTPUT_EN_I == 1)
			begin
				TRDYn_O = HPMEM_TRDYn_I;
				TRDYn_DIR_O = HPMEM_TRDYn_DIR_I;
				DEVSELn_O = HPMEM_DEVSELn_I;
				DEVSELn_DIR_O = HPMEM_DEVSELn_DIR_I;
				STOPn_O = HPMEM_STOPn_I ;
				STOPn_DIR_O = HPMEM_STOPn_DIR_I;
				AD_O = HPMEM_AD_I;
				AD_DIR_O = HPMEM_AD_DIR_I;
			end
		
endmodule
