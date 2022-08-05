`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2019 07:06:56 PM
// Design Name: 
// Module Name: FALC56_ENCODER
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
	//round roubin section
module FALC56_ENCODER(

	input FALC56_DCM_CLK0_I,
	input PHY_RSTn_I, 

	input PHY_CLK33_I,
	
	output reg [7:0] F56_DEFSM_BADD_O = 0,
	output reg  	 F56_BADD_DEFSM_DIR_O = 0,

	output reg 		 F56_DEFSM_ALE_O = 0,
	output reg 		 F56_DEFSM_RDn_O = 0,
	output reg 		 F56_DEFSM_WRn_O = 0,
	output reg [1:0] F56_DEFSM_CSn_O = 0,
	

	// CONTROL BUS TYPE2 
	input       F56_WB_T2_REQ_I,
	output reg  F56_WB_T2_GNT_O = 0,
	
	// CONTROL BUS 
	input       F56_WB_REQ_I,
	output reg  F56_WB_GNT_O = 0,
	
	
	// CONTROL BUS DMA
	
	input       F56_DMA0_REQ_I,
	output reg  F56_DMA0_GNT_O = 0,
	
	// F56 BUS

	input [7:0] F56_WB_BADD_I,
	input       F56_WB_BADD_DIR_I,

	input F56_WB_ALE_I, 
	input F56_WB_RDn_I,
	input F56_WB_WRn_I,
	input [1:0] F56_WB_CSn_I,
	
		// F56 T2 BUS

	input [7:0] F56_WB_T2_BADD_I,
	input       F56_WB_T2_BADD_DIR_I,

	input F56_WB_T2_ALE_I, 
	input F56_WB_T2_RDn_I,
	input F56_WB_T2_WRn_I,
	input [1:0] F56_WB_T2_CSn_I,
	
	// DMA BUS

	input [7:0] F56_DMA0_BADD_I,
	input       F56_DMA0_BADD_DIR_I,

	input F56_DMA0_ALE_I, 
	input F56_DMA0_RDn_I,
	input F56_DMA0_WRn_I,
	input [1:0] F56_DMA0_CSn_I

    );
	
	localparam IDLE        = 0;
	localparam WISHBONE_T2 = 1;
	localparam WISHBONE0   = 2;
	localparam DMA0        = 3;
	
	reg [1:0] FALC56_ENCODER_STATE = 0;
	
	
	always @(posedge PHY_CLK33_I)
		if (PHY_RSTn_I == 0)
			begin	
				FALC56_ENCODER_STATE = IDLE;

			end
		else 
			begin
				case (FALC56_ENCODER_STATE)
					IDLE :
						begin
							F56_WB_GNT_O = 0;
							F56_WB_T2_GNT_O = 0;
							F56_DMA0_GNT_O = 0;
							if (F56_WB_T2_REQ_I == 1)
								begin
									F56_WB_T2_GNT_O = 1;
									FALC56_ENCODER_STATE = WISHBONE_T2;
								end
							else if (F56_WB_REQ_I == 1)
								begin
									F56_WB_GNT_O = 1;
									FALC56_ENCODER_STATE = WISHBONE0;
								end
							else if (F56_DMA0_REQ_I == 1)
								begin
									F56_DMA0_GNT_O = 1;
									FALC56_ENCODER_STATE = DMA0;
								end
						end
					WISHBONE_T2 : 
						begin
							if (F56_WB_T2_REQ_I == 0)
								begin
									FALC56_ENCODER_STATE = IDLE;
									F56_WB_T2_GNT_O = 0;
								end
						end
					WISHBONE0 :
						begin
							if (F56_WB_T2_REQ_I == 1)
								begin
									F56_WB_GNT_O = 0;
									if (F56_WB_REQ_I == 0)
										begin
											FALC56_ENCODER_STATE = WISHBONE_T2;
											F56_WB_T2_GNT_O = 1;
										end
								end
							else if (F56_WB_REQ_I == 0)
								begin
									FALC56_ENCODER_STATE = IDLE;
									F56_WB_GNT_O = 0;
								end
						end
					DMA0 :
						begin
							if (F56_WB_T2_REQ_I == 1)
								begin
									F56_DMA0_GNT_O = 0;
									if (F56_DMA0_REQ_I == 0)
										begin
											FALC56_ENCODER_STATE = WISHBONE_T2;
											F56_WB_T2_GNT_O = 1;
										end
								end
							else if (F56_WB_REQ_I == 1)
								begin
									F56_DMA0_GNT_O = 0;
									if (F56_DMA0_REQ_I == 0)
										begin
											FALC56_ENCODER_STATE = WISHBONE0;
											F56_WB_GNT_O = 1;
										end
								end
							else if (F56_DMA0_REQ_I == 0)
								begin
									FALC56_ENCODER_STATE = IDLE;
									F56_DMA0_GNT_O = 0;
								end
						end
				endcase
				
			end
		always @(*)
			case (FALC56_ENCODER_STATE)
				IDLE :
					begin
						F56_DEFSM_BADD_O 	 = 0;
						F56_BADD_DEFSM_DIR_O = 0;
						
						F56_DEFSM_ALE_O      = 0;
						F56_DEFSM_RDn_O 	 = 1;
						F56_DEFSM_WRn_O 	 = 1;
						F56_DEFSM_CSn_O 	 = 2'b11;
						
					
					end
				WISHBONE_T2 :
					begin
						F56_DEFSM_BADD_O 	 = F56_WB_T2_BADD_I;
						F56_BADD_DEFSM_DIR_O = F56_WB_T2_BADD_DIR_I;
						
						F56_DEFSM_ALE_O      = F56_WB_T2_ALE_I;
						F56_DEFSM_RDn_O 	 = F56_WB_T2_RDn_I;
						F56_DEFSM_WRn_O 	 = F56_WB_T2_WRn_I;
						F56_DEFSM_CSn_O 	 = F56_WB_T2_CSn_I;
					end
				WISHBONE0 :
					begin
						F56_DEFSM_BADD_O 	 = F56_WB_BADD_I;
						F56_BADD_DEFSM_DIR_O = F56_WB_BADD_DIR_I;
						
						F56_DEFSM_ALE_O      = F56_WB_ALE_I;
						F56_DEFSM_RDn_O 	 = F56_WB_RDn_I;
						F56_DEFSM_WRn_O 	 = F56_WB_WRn_I;
						F56_DEFSM_CSn_O 	 = F56_WB_CSn_I;
					
					end
				DMA0 :
					begin
						F56_DEFSM_BADD_O 	 = F56_DMA0_BADD_I;
						F56_BADD_DEFSM_DIR_O = F56_DMA0_BADD_DIR_I;
						
						F56_DEFSM_ALE_O      = F56_DMA0_ALE_I;
						F56_DEFSM_RDn_O 	 = F56_DMA0_RDn_I;
						F56_DEFSM_WRn_O 	 = F56_DMA0_WRn_I;
						F56_DEFSM_CSn_O 	 = F56_DMA0_CSn_I;

					end
			endcase
		
	
	
endmodule
