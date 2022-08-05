`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: SOHEIL NAZARI +989122939002
// 
// Create Date: 12/25/2018 01:59:06 PM
// Design Name: 
// Module Name: PCI_DEFSM_CFG_MNG
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


module PCI_DEFSM_CFG_MNG(
	input PHY_CLK33_I,
	input PHY_RSTn_I,
	

	output reg DEFSM_CFG_END_O = 0,
	input      CFG_WR_I,
	input      DEFSM_ADD2CFG_I,
	output reg CFG_OUTPUT_EN_O = 0,
	input CFG_STATE_ABORT_I,
	
	input [23:2] PCI_ADD_I,
	
	output reg [31:0] CFG_REG_0x04_O = 32'h200000,
	output reg [31:0] CFG_REG_0x10_O = 0,
	output reg [31:0] CFG_REG_0x11_O = 0,
	output reg [31:0] CFG_REG_0x3C_O = 32'h100,
	input [31:0] CFG_REG_0x00_I,
	input [31:0] CFG_REG_0x08_I,
	input [31:0] CFG_REG_0x2C_I,
	
	output reg CFG_PAR_REQ_O = 0,
	
	input  CFG_FRAMEn_I,
	input  CFG_IRDYn_I,
	
	output reg   CFG_TRDYn_O = 1,
	output reg   CFG_TRDYn_DIR_O = 0,
	output reg   CFG_DEVSELn_O = 1,
	output reg   CFG_DEVSELn_DIR_O = 0,
	output reg   CFG_STOPn_O = 1 ,
	output reg   CFG_STOPn_DIR_O = 0,

	

	output reg  [31:0]  CFG_AD_O = 0,
	output reg          CFG_AD_DIR_O = 0,
	input [31:0]        CFG_AD_I,
	
	input [3:0]         CFG_CBEn_I
    );
	
	localparam READY = 0;
	localparam TERMINATE = 2;
	localparam WAITE = 1;


	
	reg [2:0] CFG_STATE = READY;
	always @(posedge PHY_CLK33_I)
		if (PHY_RSTn_I == 0)
			begin
				CFG_TRDYn_O = 1;
				CFG_TRDYn_DIR_O = 1;
				CFG_DEVSELn_O = 0;
				CFG_DEVSELn_DIR_O = 1;
				CFG_STOPn_O = 1;
				CFG_STOPn_DIR_O = 1;
				CFG_AD_O = 0;
				CFG_AD_DIR_O = 0;
				
				CFG_REG_0x04_O = 0;
				CFG_REG_0x04_O[21] = 1;
				CFG_REG_0x10_O = 0;
				CFG_REG_0x11_O = 0;
				CFG_REG_0x3C_O = 0;
				CFG_REG_0x3C_O[8] = 1;
				CFG_STATE = READY;
				CFG_PAR_REQ_O = 0;
				
				CFG_OUTPUT_EN_O = 0;
			end
		else 
			begin
				if (CFG_STATE_ABORT_I == 1)
					CFG_REG_0x04_O[27] = 1;
				case (CFG_STATE)
					READY : 
						begin
		
							if (DEFSM_ADD2CFG_I == 1 || CFG_OUTPUT_EN_O == 1)
								begin
									CFG_OUTPUT_EN_O = 1;
									CFG_DEVSELn_O = 0;
									CFG_TRDYn_DIR_O = 1;
									CFG_DEVSELn_DIR_O = 1;
									CFG_STOPn_DIR_O = 1;
									if (CFG_WR_I == 0) //read cycle
										begin
											if (CFG_IRDYn_I == 0)
												begin
													CFG_AD_DIR_O = 1;
													case (PCI_ADD_I[7:2])
														6'b000000 :
															begin
																CFG_AD_O[31:24] = CFG_CBEn_I[3] == 0 ? CFG_REG_0x00_I[31:24] : 8'h00;
																CFG_AD_O[23:16] = CFG_CBEn_I[2] == 0 ? CFG_REG_0x00_I[23:16] : 8'h00;
																CFG_AD_O[15:8]  = CFG_CBEn_I[1] == 0 ? CFG_REG_0x00_I[15:8]  : 8'h00;
																CFG_AD_O[7:0]   = CFG_CBEn_I[0] == 0 ? CFG_REG_0x00_I[7:0]   : 8'h00;
															end
														6'b000001 : 
															begin
																CFG_AD_O[31:24] = CFG_CBEn_I[3] == 0 ? CFG_REG_0x04_O[31:24] : 8'h00;
																CFG_AD_O[23:16] = CFG_CBEn_I[2] == 0 ? CFG_REG_0x04_O[23:16] : 8'h00;
																CFG_AD_O[15:8]  = CFG_CBEn_I[1] == 0 ? CFG_REG_0x04_O[15:8]  : 8'h00;
																CFG_AD_O[7:0]   = CFG_CBEn_I[0] == 0 ? CFG_REG_0x04_O[7:0]   : 8'h00;
															end
														6'b000010 :
															begin
																CFG_AD_O[31:24] = CFG_CBEn_I[3] == 0 ? CFG_REG_0x08_I[31:24] : 8'h00;
																CFG_AD_O[23:16] = CFG_CBEn_I[2] == 0 ? CFG_REG_0x08_I[23:16] : 8'h00;
																CFG_AD_O[15:8]  = CFG_CBEn_I[1] == 0 ? CFG_REG_0x08_I[15:8]  : 8'h00;
																CFG_AD_O[7:0]   = CFG_CBEn_I[0] == 0 ? CFG_REG_0x08_I[7:0]   : 8'h00;
															end
														6'b000101 :
															begin
																CFG_AD_O[31:24] = CFG_CBEn_I[3] == 0 ? CFG_REG_0x11_O[31:24] : 8'h00;
																CFG_AD_O[23:20] = CFG_CBEn_I[2] == 0 ? CFG_REG_0x11_O[23:20] : 4'h00;
																//CFG_AD_O[15:14] = CFG_CBEn_I[1] == 0 ? CFG_REG_0x11_O[15:14] : 2'b00;
																CFG_AD_O[19:0] = 0;
															end
														6'b000100 :
															begin
																CFG_AD_O[31:24] = CFG_CBEn_I[3] == 0 ? CFG_REG_0x10_O[31:24] : 8'h00;
																CFG_AD_O[23:20] = CFG_CBEn_I[2] == 0 ? CFG_REG_0x10_O[23:20] : 4'h00;
																//CFG_AD_O[15:14] = CFG_CBEn_I[1] == 0 ? CFG_REG_0x10_O[15:14] : 2'b00;
																CFG_AD_O[19:4] = 0;
																CFG_AD_O[3:0] = 0;
																//CFG_AD_O[3] = CFG_CBEn_I[0] == 0 ? 1 : 0;
															end
														6'b001011 : 
															begin
																CFG_AD_O[31:24] = CFG_CBEn_I[3] == 0 ? CFG_REG_0x2C_I[31:24] : 8'h00;
																CFG_AD_O[23:16] = CFG_CBEn_I[2] == 0 ? CFG_REG_0x2C_I[23:16] : 8'h00;
																CFG_AD_O[15:8]  = CFG_CBEn_I[1] == 0 ? CFG_REG_0x2C_I[15:8]  : 8'h00;
																CFG_AD_O[7:0]   = CFG_CBEn_I[0] == 0 ? CFG_REG_0x2C_I[7:0]   : 8'h00;
															end
														6'b001111 : 
															begin
																CFG_AD_O[31:24] = CFG_CBEn_I[3] == 0 ? CFG_REG_0x3C_O[31:24] : 8'h00;
																CFG_AD_O[23:16] = CFG_CBEn_I[2] == 0 ? CFG_REG_0x3C_O[23:16] : 8'h00;
																CFG_AD_O[15:8]  = CFG_CBEn_I[1] == 0 ? CFG_REG_0x3C_O[15:8]  : 8'h00;
																CFG_AD_O[7:0]   = CFG_CBEn_I[0] == 0 ? CFG_REG_0x3C_O[7:0]   : 8'h00;
															end
														default :
															CFG_AD_O = 0;
													endcase	
													CFG_TRDYn_O = 0;
													CFG_STOPn_O = 0;
													CFG_PAR_REQ_O = 1;
													CFG_STATE = WAITE;
													
												end
											end
										else	
											begin
												if (CFG_IRDYn_I == 0)
													begin
														case (PCI_ADD_I[7:2])
															6'b000001 :
																begin
																	if (CFG_CBEn_I[3] == 0 && CFG_AD_I[27] == 1)
																		CFG_REG_0x04_O[27] = 0;
																	
																	if (CFG_CBEn_I[0] == 0)
																		begin
																			CFG_REG_0x04_O[1] = CFG_AD_I[1];
																			CFG_REG_0x04_O[10] = CFG_AD_I[10];
																		
																		end
																end
															6'b000101 :
																begin
																	if (CFG_CBEn_I[3] == 0)
																		CFG_REG_0x11_O[31:24] = CFG_AD_I[31:24];
																	if (CFG_CBEn_I[2] == 0)
																		CFG_REG_0x11_O[23:20] = CFG_AD_I[23:20];
																	/* if (CFG_CBEn_I[1] == 0)
																		CFG_REG_0x11_O[15:14] = CFG_AD_I[15:14]; */
																end
															6'b000100 :
																begin
																	if (CFG_CBEn_I[3] == 0)
																		CFG_REG_0x10_O[31:24] = CFG_AD_I[31:24];
																	if (CFG_CBEn_I[2] == 0)
																		CFG_REG_0x10_O[23:20] = CFG_AD_I[23:20];
																	/* if (CFG_CBEn_I[1] == 0)
																		CFG_REG_0x10_O[15:14] = CFG_AD_I[15:14]; */
																end
															6'b001111 :
																begin
																	if (CFG_CBEn_I[0] == 0)
																		CFG_REG_0x3C_O[7:0] = CFG_AD_I[7:0];
																	
																end
														endcase
														CFG_TRDYn_O = 0;
														CFG_STOPn_O = 0;
														CFG_STATE = WAITE;
														
													end
											end
									end
						end
						WAITE :
							begin
								CFG_STATE = TERMINATE;
								DEFSM_CFG_END_O = 1;
								CFG_PAR_REQ_O = 0;
								CFG_AD_DIR_O = 0;
								CFG_DEVSELn_O = 1;
								CFG_TRDYn_O = 1;
								CFG_STOPn_O = 1;
							end
						TERMINATE :
							begin
								CFG_OUTPUT_EN_O = 0;
								DEFSM_CFG_END_O = 0;
								CFG_STATE = READY;
							end
				endcase
			end
endmodule
