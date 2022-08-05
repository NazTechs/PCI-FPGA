`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: SOHEIL NAZARI +989122939002
// 
// Create Date: 12/26/2018 06:46:46 AM
// Design Name: 
// Module Name: PCI_DEFSM_PAR
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


module PCI_DEFSM_PAR(
	input PHY_CLK33_I,
	input PHY_RSTn_I,
	
	input  	     PGEN_PAR_I,
	output reg   PGEN_PAR_O = 0,
	output reg   PGEN_PAR_DIR_O = 0,
	
	input [31:0] PGEN_AD_I,
	input [3:0]  PGEN_CBEn_I,
	
	input MEM_PAR_REQ_I,
	input HPMEM_PAR_REQ_I,
	input CFG_PAR_REQ_I
    );
	
	wire PAR_REQ = (MEM_PAR_REQ_I == 1 || HPMEM_PAR_REQ_I == 1 || CFG_PAR_REQ_I == 1);
	
	always @(negedge PHY_CLK33_I)
		if (PHY_RSTn_I == 0)
			begin
				PGEN_PAR_DIR_O = 0;
				PGEN_PAR_O = 0;
				
			end
		else
			begin
				if (PAR_REQ == 1)
					begin
						PGEN_PAR_DIR_O = 1;
						PGEN_PAR_O =
						  ((  PGEN_AD_I[31] ^ PGEN_AD_I[30] ^ PGEN_AD_I[29] ^ PGEN_AD_I[28] ) ^
							( PGEN_AD_I[27] ^ PGEN_AD_I[26] ^ PGEN_AD_I[25] ^ PGEN_AD_I[24] ) ^
							( PGEN_AD_I[23] ^ PGEN_AD_I[22] ^ PGEN_AD_I[21] ^ PGEN_AD_I[20] ) ^
							( PGEN_AD_I[19] ^ PGEN_AD_I[18] ^ PGEN_AD_I[17] ^ PGEN_AD_I[16] ) ^
							( PGEN_AD_I[15] ^ PGEN_AD_I[14] ^ PGEN_AD_I[13] ^ PGEN_AD_I[12] ) ^
							( PGEN_AD_I[11] ^ PGEN_AD_I[10] ^ PGEN_AD_I[9]  ^ PGEN_AD_I[8]  ) ^
							( PGEN_AD_I[7]  ^ PGEN_AD_I[6]  ^ PGEN_AD_I[5]  ^ PGEN_AD_I[4]  ) ^
							( PGEN_AD_I[3]  ^ PGEN_AD_I[2]  ^ PGEN_AD_I[1]  ^ PGEN_AD_I[0]  ) ^
							( PGEN_CBEn_I[3] ^ PGEN_CBEn_I[2] ^ PGEN_CBEn_I[1] ^ PGEN_CBEn_I[0] ));
					end
				else
					begin
						PGEN_PAR_DIR_O = 0;
						PGEN_PAR_O  = 0;
					end
			end		
endmodule
