`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: SOHEIL NAZARI +989122939002
// 
// Create Date: 12/25/2018 05:38:52 PM
// Design Name: 
// Module Name: PCI_DEFSM_MEM_MNG
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


module PCI_DEFSM_MEM_MNG(
	input PHY_CLK33_I,
	input PHY_RSTn_I,
	

	output reg DEFSM_MEM_END_O = 0,
	input      MEM_WR_I,
	input      DEFSM_ADD2MEM_I,
	output reg MEM_OUTPUT_EN_O = 0,
	
	input [23:2] PCI_ADD_I,
	
	input [31:0] CFG_REG_0x04_I,
	output reg CFG_STATE_MEM_ABORT_O = 0,
	
	output reg MEM_PAR_REQ_O = 0,
	
	input  MEM_FRAMEn_I,
	input  MEM_IRDYn_I,
	
	output reg   MEM_TRDYn_O = 1,
	output reg   MEM_TRDYn_DIR_O = 0,
	output reg   MEM_DEVSELn_O = 1,
	output reg   MEM_DEVSELn_DIR_O = 0,
	output reg   MEM_STOPn_O = 1 ,
	output reg   MEM_STOPn_DIR_O = 0,

	

	output reg  [31:0]  MEM_AD_O = 0,
	output reg          MEM_AD_DIR_O = 0,
	input [31:0]        MEM_AD_I,
	
	input [3:0]         MEM_CBEn_I,
	
	// MASTER WISHBONE SIGNALS
	
	output reg [31:0] WB_DATA_O = 0,
	input [31:0] WB_DATA_I,
		
	input WB_ACK_I,
	input WB_VALID_I,
	
	output reg [31:0] WB_ADD_O = 0,
	output reg WB_STB_O = 0,
	output reg WB_WE_O = 0
	
    );
	
	localparam WB_MAX_LAT          = 4'd13;
	
	localparam READY       = 0;
	localparam MEM_READ_1  = 1;
	localparam MEM_READ_2  = 2;
	localparam MEM_WRITE_1 = 3;
	localparam TERMINATE   = 4;
	
	reg [2:0] MEM_STATE = READY;
	reg [3:0] WISHBONE_WAIT = 0;

	always @(posedge PHY_CLK33_I)
		if (PHY_RSTn_I == 0)
			begin

				MEM_TRDYn_O = 1;
				MEM_TRDYn_DIR_O = 0;
				MEM_DEVSELn_O = 1;
				MEM_DEVSELn_DIR_O = 0;
				MEM_STOPn_O = 1;
				MEM_STOPn_DIR_O = 0;
				
				MEM_AD_O = 0;
				MEM_AD_DIR_O = 0;

				DEFSM_MEM_END_O = 0;
				MEM_OUTPUT_EN_O = 0;
				
				CFG_STATE_MEM_ABORT_O = 0;
				
				MEM_PAR_REQ_O = 0;	
				MEM_STATE = READY;	

				WISHBONE_WAIT = 0;				
			end
		else
			begin
				case (MEM_STATE)
					READY :
						begin
							if (DEFSM_ADD2MEM_I == 1 || MEM_OUTPUT_EN_O == 1)
								begin
									MEM_OUTPUT_EN_O = 1;
									MEM_DEVSELn_O = 0;
									MEM_TRDYn_DIR_O = 1;
									MEM_DEVSELn_DIR_O = 1;
									MEM_STOPn_DIR_O = 1;
									
									if (MEM_WR_I == 0) //read cycle
										begin
											if (MEM_IRDYn_I == 0)
												MEM_AD_DIR_O = 1; //bus turn around
												WB_ADD_O [19:2] = PCI_ADD_I[19:2];
												WB_ADD_O[1:0] = 0;
												WB_ADD_O[31:20] = 0;
												
												WB_STB_O = 1;
												WB_WE_O = 0;
												MEM_STATE = MEM_READ_1;
												WISHBONE_WAIT = 0;
										
										
										end
									else	//WRITE CYCLE
										begin
												WB_ADD_O [19:2] = PCI_ADD_I[19:2];
												WB_ADD_O[1:0] = 0;
												WB_ADD_O[31:20] = 0;
												WB_DATA_O = MEM_AD_I;
												WB_STB_O = 1;
												WB_WE_O = 1;
												
												WISHBONE_WAIT = 0;
												MEM_STATE = MEM_WRITE_1;
										end
								end
						end
					MEM_WRITE_1 :
						begin
							if(WB_ACK_I == 1)
								begin
									WB_ADD_O = 0;
									WB_STB_O = 0;
									WB_WE_O = 0;
									WB_DATA_O = 0;
									
									MEM_TRDYn_O = 0;
									MEM_STOPn_O = 0;
									
									DEFSM_MEM_END_O = 1;
									
									MEM_STATE = TERMINATE;
								end
							else if (WISHBONE_WAIT == WB_MAX_LAT)
								begin
									WB_ADD_O = 0;
									WB_STB_O = 0;
									WB_WE_O  = 0;
									
									MEM_DEVSELn_O = 1;
									MEM_STOPn_O = 0;
									
									CFG_STATE_MEM_ABORT_O = 1;
									DEFSM_MEM_END_O = 1;
									MEM_STATE = TERMINATE;
								end
							else 
									WISHBONE_WAIT = WISHBONE_WAIT + 1;
						end
					MEM_READ_1 :
						begin
							if (WB_VALID_I == 1)
								begin
									WB_ADD_O = 0; 
									WB_STB_O = 0;
									WB_WE_O  = 0;
									MEM_TRDYn_O = 0;
									MEM_STOPn_O = 0;
									MEM_AD_O = WB_DATA_I;
									MEM_PAR_REQ_O = 1;
									DEFSM_MEM_END_O = 1;
									MEM_STATE = TERMINATE;
									
								end
							else if(WISHBONE_WAIT == WB_MAX_LAT) //TARGET ABORT
								begin
									WB_ADD_O = 0;
									WB_STB_O = 0;
									WB_WE_O  = 0;
									
									MEM_DEVSELn_O = 1;
									MEM_STOPn_O = 0;
									
									CFG_STATE_MEM_ABORT_O = 1;
									DEFSM_MEM_END_O = 1;
									MEM_STATE = TERMINATE;
								
								end
							else
								WISHBONE_WAIT = WISHBONE_WAIT + 1;
						end

					TERMINATE :
						begin
							WISHBONE_WAIT = 0;
							MEM_OUTPUT_EN_O = 0;
							CFG_STATE_MEM_ABORT_O = 0;
							MEM_STATE = READY;
							MEM_DEVSELn_O = 1;
							MEM_DEVSELn_DIR_O = 0;
							MEM_TRDYn_O = 1;
							MEM_AD_DIR_O = 0;
							MEM_STOPn_O = 1;
							MEM_STOPn_DIR_O = 0;
							MEM_PAR_REQ_O = 0;
							DEFSM_MEM_END_O = 0;
						end

				endcase			
			end
endmodule
