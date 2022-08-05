`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: SOHEIL NAZARI +989122939002
// 
// Create Date: 12/25/2018 12:22:40 PM
// Design Name: 
// Module Name: PCI_DEFSM_ADD_DECODER
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


module PCI_DEFSM_ADD_DECODER(
	input PHY_CLK33_I,
	input PHY_RSTn_I,
	
	// PARTIAL FSM SIGNAL //
	
	output reg DEFSM_ADD2CFG_O = 0,
	output reg CFG_WR_O = 0,
	input 	   DEFSM_CFG_END_I,
	
	output reg DEFSM_ADD2MEM_O = 0,
	output reg MEM_WR_O = 0,
	input 	   DEFSM_MEM_END_I,
	
	output reg DEFSM_ADD2HPMEM_O = 0,
	output reg HPMEM_WR_O = 0,
	input 	   DEFSM_HPMEM_END_I,
	
	output reg ADD_OUTPUT_EN_O = 0,
	// CFG_REGISTER
	input [31:0] CFG_REG_0x04_I,
	input [31:0] CFG_REG_0x10_I,
	input [31:0] CFG_REG_0x11_I,
	
	// PCI_ADD DECODED
	output reg [23:2] PCI_ADD_O = 0,
	
	//GENERAL SIGNALS 
	input ADD_IDSEL_I,
	
	input  ADD_FRAMEn_I,
	input  ADD_IRDYn_I,
	
	output reg   ADD_TRDYn_O = 1,
	output reg   ADD_TRDYn_DIR_O = 0,
	output reg   ADD_DEVSELn_O = 1,
	output reg   ADD_DEVSELn_DIR_O = 0,
	output reg   ADD_STOPn_O = 1 ,
	output reg   ADD_STOPn_DIR_O = 0,

	input [31:0]  ADD_AD_I,
	input [3:0] ADD_CBEn_I
	
    );
	
	
	/* +-------------------------------------------------------+
	---|					PCI COMMAND                        |
	---+-------------------------------------------------------+ */
	
	localparam CFGREAD  = 4'b1010;
	localparam CFGWRITE = 4'b1011;
	localparam MEMREAD  = 4'b0110;
	localparam MEMWRITE = 4'b0111;
	
	/* +-------------------------------------------------------+
	---|					PARTIAL STATE MACHINES             |
	---+-------------------------------------------------------+ */
	localparam IDLE = 0;
	localparam CFG_ADD_DECODE = 1;
	localparam MEM_ADD_DECODE = 2;
	localparam HPMEM_ADD_DECODE = 3;
	localparam ADD_DECODED = 4;
	localparam ADD_ANALYZE = 5;
	reg [2:0] ADD_STATE = IDLE;
	reg [3:0] BUS_CMD = 0;
	reg [31:0] BUS_ADD = 0;
	reg BUS_IDSEL = 0;
	//wire MEM_ADD_SEL   = (ADD_AD_I[31:14] == CFG_REG_0x11_I[31:14]);
	//wire HPMEM_ADD_SEL = (ADD_AD_I[31:14] == CFG_REG_0x10_I[31:14]);
	reg MEM_ADD_SEL = 0;
	reg HPMEM_ADD_SEL = 0;
	always @(posedge PHY_CLK33_I)
		if ( PHY_RSTn_I == 0)
			begin
				DEFSM_ADD2CFG_O = 0;
				CFG_WR_O = 0;
	
				DEFSM_ADD2MEM_O = 0;
				MEM_WR_O = 0;
				
				DEFSM_ADD2HPMEM_O = 0;
				HPMEM_WR_O = 0;
				
				
				ADD_OUTPUT_EN_O = 0;
				
				
				
				
				PCI_ADD_O = 0;
				ADD_TRDYn_O = 1;
				ADD_TRDYn_DIR_O = 0;
				ADD_DEVSELn_O = 1;
				ADD_DEVSELn_DIR_O = 0;
				ADD_STOPn_O = 1;
				ADD_STOPn_DIR_O = 0;
				
				ADD_STATE = IDLE;
				BUS_CMD = 0;
				MEM_ADD_SEL = 0;
				HPMEM_ADD_SEL = 0;
			end
		else 
			begin
				case (ADD_STATE)
					IDLE :
						begin
							ADD_OUTPUT_EN_O = 1;
							
							ADD_TRDYn_O = 1;
							ADD_TRDYn_DIR_O = 0;
							
							ADD_DEVSELn_O = 1;
							ADD_DEVSELn_DIR_O = 0;
							ADD_STOPn_O = 1;
							ADD_STOPn_DIR_O = 0;	
							
											
							if (ADD_FRAMEn_I == 0)
								begin
									BUS_CMD = ADD_CBEn_I;
									BUS_ADD[31:0] = ADD_AD_I[31:0];
									BUS_IDSEL = ADD_IDSEL_I;
									PCI_ADD_O[23:2] = ADD_AD_I[23:2];
								    ADD_STATE = ADD_ANALYZE;
								//end
						//end
					//ADD_ANALYZE : 
									if (BUS_IDSEL == 1 && BUS_ADD[10:8] == 3'b000 
										&& BUS_ADD[1:0] == 2'b00)
										ADD_STATE = CFG_ADD_DECODE;
									else if (CFG_REG_0x04_I[1] == 1 && BUS_ADD[31:20] == CFG_REG_0x11_I[31:20] )
										ADD_STATE = MEM_ADD_DECODE;
									else if (CFG_REG_0x04_I[1] == 1 && BUS_ADD[31:20] == CFG_REG_0x10_I[31:20])
										
										/* begin
											if (BUS_CMD == MEMREAD)
												begin
													ADD_DEVSELn_DIR_O = 1;
													ADD_DEVSELn_O = 0;
													ADD_TRDYn_DIR_O = 1;
													ADD_STOPn_DIR_O = 1;
													
													DEFSM_ADD2HPMEM_O = 1;
													ADD_STATE = ADD_DECODED;
													HPMEM_WR_O = 0;
												end
											else if (BUS_CMD == MEMWRITE)
												begin
													ADD_DEVSELn_DIR_O = 1;
													ADD_DEVSELn_O = 0;
													ADD_TRDYn_DIR_O = 1;
													ADD_STOPn_DIR_O = 1;
													
													DEFSM_ADD2HPMEM_O = 1;
													ADD_STATE = ADD_DECODED;
													HPMEM_WR_O = 1;
												end
											else 
												ADD_STATE = IDLE;
										end */
										ADD_STATE = HPMEM_ADD_DECODE;
									else 
										ADD_STATE = IDLE;
							end
						end
					CFG_ADD_DECODE :
						begin
							if (BUS_CMD == CFGREAD)
								begin
									ADD_DEVSELn_DIR_O = 1;
									ADD_DEVSELn_O = 0;
									ADD_TRDYn_DIR_O = 1;
									ADD_STOPn_DIR_O = 1;
									
									ADD_STATE = ADD_DECODED;
									DEFSM_ADD2CFG_O = 1;
									CFG_WR_O = 0;
								end
							else if (BUS_CMD == CFGWRITE)
								begin
									ADD_DEVSELn_DIR_O = 1;
									ADD_DEVSELn_O = 0;
									ADD_TRDYn_DIR_O = 1;
									ADD_STOPn_DIR_O = 1;
									
									DEFSM_ADD2CFG_O = 1;
									ADD_STATE = ADD_DECODED;
									CFG_WR_O = 1;
								end
							else 
								ADD_STATE = IDLE;
						end
					MEM_ADD_DECODE :
						begin
							if (BUS_CMD == MEMREAD)
								begin
									ADD_DEVSELn_DIR_O = 1;
									ADD_DEVSELn_O = 0;
									ADD_TRDYn_DIR_O = 1;
									ADD_STOPn_DIR_O = 1;
									
									DEFSM_ADD2MEM_O = 1;
									ADD_STATE = ADD_DECODED;
									MEM_WR_O = 0;
								end
							else if (BUS_CMD == MEMWRITE)
								begin
									ADD_DEVSELn_DIR_O = 1;
									ADD_DEVSELn_O = 0;
									ADD_TRDYn_DIR_O = 1;
									ADD_STOPn_DIR_O = 1;
									
									DEFSM_ADD2MEM_O = 1;
									ADD_STATE = ADD_DECODED;
									MEM_WR_O = 1;
								end
							else 
								ADD_STATE = IDLE;
						end
					HPMEM_ADD_DECODE :
						begin
							/*if (ADD_IRDYn_I == 0)
								begin
									ADD_TRDYn_O = 0;
									ADD_TRDYn_DIR_O = 1;
									
								end
							if (ADD_FRAMEn_I == 1)
								ADD_STATE = IDLE;*/
							if (BUS_CMD == MEMREAD)
								begin
									ADD_DEVSELn_DIR_O = 1;
									ADD_DEVSELn_O = 0;
									ADD_TRDYn_DIR_O = 1;
									ADD_STOPn_DIR_O = 1;
									
									DEFSM_ADD2HPMEM_O = 1;
									ADD_STATE = ADD_DECODED;
									HPMEM_WR_O = 0;
								end
							else if (BUS_CMD == MEMWRITE)
								begin
									ADD_DEVSELn_DIR_O = 1;
									ADD_DEVSELn_O = 0;
									ADD_TRDYn_DIR_O = 1;
									ADD_STOPn_DIR_O = 1;
									
									DEFSM_ADD2HPMEM_O = 1;
									ADD_STATE = ADD_DECODED;
									HPMEM_WR_O = 1;
								end
							else 
								ADD_STATE = IDLE;
						end
					ADD_DECODED :
						begin
							ADD_OUTPUT_EN_O = 0; //grant bus - clock lag must be check
							DEFSM_ADD2CFG_O = 0;
							DEFSM_ADD2MEM_O = 0 ;
							DEFSM_ADD2HPMEM_O = 0;
							if (DEFSM_CFG_END_I == 1 || DEFSM_MEM_END_I == 1 || DEFSM_HPMEM_END_I == 1)
								begin
									ADD_STATE = IDLE;
									ADD_OUTPUT_EN_O = 1;
							
									ADD_TRDYn_O = 1;
									ADD_TRDYn_DIR_O = 0;
									ADD_DEVSELn_O = 1;
									ADD_DEVSELn_DIR_O = 0;
									ADD_STOPn_O = 1;
									ADD_STOPn_DIR_O = 0;	
								end
						end
				endcase
			end
endmodule
