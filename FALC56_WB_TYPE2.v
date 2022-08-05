`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2019 10:57:37 PM
// Design Name: 
// Module Name: FALC56_WB_TYPE2
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


module FALC56_WB_TYPE2(
	input PHY_CLK33_I,
	input PHY_RSTn_I,
	
	
	input      [31:0]  WB_ADD_I,
	output reg [31:0]  WB_DATA_O = 0,
	input      [31:0]  WB_DATA_I,
	
	output reg WB_ACK_O = 0,
	output reg WB_VALID_O = 0,
	
	input WB_STB_I,
	input WB_WE_I,
	
	output reg F56_WB_REQ_O = 0,
	input      F56_WB_GNT_I,
	
	input       [7:0] F56_BADD_I,
	output reg  [7:0] F56_BADD_O = 0,
	output reg        F56_BADD_DIR_O = 0,

	output reg 		  F56_ALE_O = 0,
	output reg 		  F56_RDn_O = 1,
	output reg 		  F56_WRn_O = 1,
	output reg 	[1:0] F56_CSn_O = 2'b11,
	output reg		  F56_RSTn_O = 1,
	input       [1:0] F56_INT_I 
    );
	
	reg WRITE_FLAG = 0;
	reg READ_FLAG  = 0;
	reg WRITE_END = 0;
	reg READ_END = 0;
	
	reg [7:0]  REG_ADD = 0;

	reg [1:0] CHIP_SEL = 0;
	
	reg [7:0] REG_READ_DATA = 0;
	
	reg [7:0] REG_WRITE_DATA = 0;
	reg DEBUG_MODE = 0;
	
	localparam START_T2 = 0;
	localparam WAITE_T2 = 1;
	localparam END_T2   = 2;
	
	reg [1:0] WB_TYPE2_STATE = START_T2;
	
	reg [31:0] GNT_CAPTURE = 0;
	reg [31:0] REQ_CAPTURE = 0;
	reg [31:0] ALE_CAPTURE = 0;
	reg [31:0] BADD_DIR_CAPTURE = 0;
	reg [31:0] RDn_CAPTURE = 0;
	reg [31:0] WRn_CAPTURE = 0;
	reg [31:0] Csn0_CAPTURE = 0;
	reg [31:0] Csn1_CAPTURE = 0;
	reg [7:0] DATA_CAP[31:0];
	reg [4:0] readVector = 0;
	
always @(posedge PHY_CLK33_I)
		begin
			if(PHY_RSTn_I == 0)
				begin
					WB_DATA_O =      0;
					WB_ACK_O =       0;
					WB_VALID_O =     0;
				    WRITE_FLAG =     0;
				    READ_FLAG  =     0;
					CHIP_SEL =       0;
					REG_WRITE_DATA = 0;
					WB_TYPE2_STATE = START_T2;
				end
			else if (WB_STB_I == 0)
				begin
					WB_DATA_O =      0;
					WB_ACK_O =       0;
					WB_VALID_O =     0;
					WRITE_FLAG =     0;
					READ_FLAG  =     0;
					REG_WRITE_DATA = 0; 
					CHIP_SEL =       0;
					WB_TYPE2_STATE = START_T2;
				end
			else 
				begin
					READ_FLAG =  0;
					WRITE_FLAG = 0;
					DEBUG_MODE = WB_ADD_I[11]; 
					if (DEBUG_MODE == 0)
						begin
							if (WB_WE_I == 0)
								begin
									case (WB_TYPE2_STATE)
										START_T2 : 
											begin
											 REG_ADD[7:0] = WB_ADD_I[9:2];
											 READ_FLAG = 1;
											 if (WB_ADD_I[10] == 0)
												CHIP_SEL[0] = 1;
											 else
												CHIP_SEL[1] = 1;
											  
											 WB_TYPE2_STATE = WAITE_T2;
											end
										WAITE_T2 :
											begin
												if (READ_END == 1)
													begin
														WB_DATA_O[7:0] = REG_READ_DATA[7:0];
														WB_DATA_O[31:8] = 0;
														WB_TYPE2_STATE = END_T2;
														WB_VALID_O = 1;
													end
												/*else
													begin
														WB_DATA_O[7:0] = 8'haa;
														WB_DATA_O[31:8] = 24'hBBCCDD;
														WB_VALID_O = 1;
													end*/
											end
										END_T2 : 
											;
									endcase
								end
							else
								begin
									case(WB_TYPE2_STATE)
									START_T2 : 
										begin
											REG_ADD[7:0] = WB_ADD_I[9:2];
											WRITE_FLAG = 1;
											if (WB_ADD_I[10] == 0)
												CHIP_SEL[0] = 1;
											else
												CHIP_SEL[1] = 1;
											REG_WRITE_DATA[7:0] = WB_DATA_I[7:0];
											WB_TYPE2_STATE = WAITE_T2;
										end
									WAITE_T2 :
										begin
											if (WRITE_END == 1)
												begin
													WB_ACK_O = 1;
													WB_TYPE2_STATE = END_T2;
												end
										end
									END_T2 : 
										;
									endcase
								end
							end
						else
							begin
								if (WB_WE_I == 0)
									begin
										case (WB_ADD_I[10:2])
											1 :
												WB_DATA_O = GNT_CAPTURE;
											2:
												WB_DATA_O = REQ_CAPTURE;
											3 : 
												WB_DATA_O = ALE_CAPTURE;
											4 :
												WB_DATA_O = BADD_DIR_CAPTURE;
											5 :
												WB_DATA_O = RDn_CAPTURE;
											6 :
												WB_DATA_O = WRn_CAPTURE;
											7 :
												WB_DATA_O = Csn0_CAPTURE;
											8:
												WB_DATA_O = Csn1_CAPTURE;
																
											9 :
												begin
													WB_DATA_O = DATA_CAP[readVector];
													readVector = readVector + 1;
												end
											10 : 
													WB_DATA_O = readVector;
											11 : //Test data
												WB_DATA_O = 32'haabb_cc_dd;
											default :
													WB_DATA_O = 0;
										endcase
										WB_VALID_O = 1;
									end
								else
									begin
										case (WB_ADD_I[10:2])
										/*0 :
										
										*/
										10 :
											begin
												readVector = WB_DATA_I;
											end
										endcase
										WB_ACK_O = 1;
									end							
							end
				end
			end
				
		localparam IDLE = 0;
		localparam RAED_BUS_WAIT = 1;
	    localparam WRITE_BUS_WAIT = 2;
		localparam RAED_ADD_LATCH = 3;
		localparam WRITE_ADD_LATCH = 4;
		localparam READ_REG = 5;
		localparam WRITE_REG = 6;
		localparam WAIT = 7;
		
		localparam ADD_MAX_WAIT = 2; //30ns req -- 60mhz clk = 16.6ns -- 30ns pci clk
		localparam ADD_MAX_RW    = 2; //80ns req -- 60mhz clk = 16.6ns -- 30ns pci clk
		
		reg [3:0]  F56_TYPE2_STATE = IDLE;
		
		reg [2:0] ADD_WAIT = 0;
		reg [2:0] READ_WAIT = 0;
		reg [2:0] WRITE_WAIT = 0;
	
	
		
		
		/*
		CMD_COMMAND { cmd[7:0] ,add[7:0],data[15:0]};
			CMD :
			[7] falcReset        = 1
			[6] chipselect 0 = cs0 1 = cs1
			[5] reserved for other chip
			[4] reserved for other chip
			[3] read = 0 / write = 1
			[2] address re latch = 1
			[1] reserved
			[0] reserved
			
			*/
			
		always @(posedge PHY_CLK33_I)
			if (PHY_RSTn_I == 0)
				begin
		
					F56_BADD_O     = 0;
					F56_BADD_DIR_O = 0;
					F56_ALE_O = 0;
					F56_RDn_O = 1;
					F56_WRn_O = 1;
					F56_CSn_O = 2'b11;
					F56_RSTn_O = 1;
					
					WRITE_END = 0;
					READ_END = 0;
					
					F56_WB_REQ_O = 0;
					F56_TYPE2_STATE = IDLE; 
				end
			else
				begin
					if (WB_STB_I == 0)
						F56_TYPE2_STATE = IDLE;
					case (F56_TYPE2_STATE) 
						IDLE :
							begin
								F56_BADD_O     = 0;
								F56_BADD_DIR_O = 0;
								F56_ALE_O = 0;
								F56_RDn_O = 1;
								F56_WRn_O = 1;
								F56_CSn_O = 2'b11;
								
								
								
								ADD_WAIT = 0;
								READ_WAIT = 0;
								WRITE_WAIT = 0;
								
								WRITE_END = 0;
								READ_END = 0;
								
								F56_WB_REQ_O = 0;
								
								if (READ_FLAG == 1)
									begin
										F56_TYPE2_STATE = RAED_BUS_WAIT;
										F56_BADD_DIR_O = 1;
										F56_BADD_O = REG_ADD;
										F56_WB_REQ_O = 1;
										
									end
								else if (WRITE_FLAG == 1)
									begin
										F56_TYPE2_STATE = WRITE_BUS_WAIT;
										F56_BADD_DIR_O = 1;
										F56_BADD_O = REG_ADD;
										F56_WB_REQ_O = 1;
										
									end
							end
						RAED_BUS_WAIT :
							begin
								if (F56_WB_GNT_I == 1)
									F56_TYPE2_STATE = RAED_ADD_LATCH;
							end
						RAED_ADD_LATCH :
							begin
								F56_ALE_O = 1;
								if (ADD_WAIT == ADD_MAX_WAIT)
									begin
										F56_ALE_O = 0;
										if (CHIP_SEL[0] == 1)
											F56_CSn_O[0] = 0;
										else if (CHIP_SEL[1] == 1)
											F56_CSn_O[1] = 0;
										F56_TYPE2_STATE = READ_REG ;
										F56_BADD_DIR_O = 0;
									end
								
								ADD_WAIT = ADD_WAIT + 1;
							end
						READ_REG :
							begin
								F56_RDn_O = 0;
								if (READ_WAIT == ADD_MAX_RW)
										begin
											REG_READ_DATA[7:0] = F56_BADD_I[7:0];
											READ_END = 1;
											F56_TYPE2_STATE = IDLE;
											F56_RDn_O = 1;
										end
								READ_WAIT = READ_WAIT + 1;
							end
						WRITE_BUS_WAIT :
							begin
								if (F56_WB_GNT_I == 1)
									F56_TYPE2_STATE = WRITE_ADD_LATCH;
							end
						WRITE_ADD_LATCH :
							begin
								if(ADD_WAIT == 0)
									F56_ALE_O = 1;
								if (ADD_WAIT == ADD_MAX_WAIT)
									F56_ALE_O = 0;
								if (ADD_WAIT == ADD_MAX_WAIT+1)
									begin
										F56_BADD_O[7:0] = REG_WRITE_DATA[7:0];
										F56_TYPE2_STATE = WRITE_REG ;
									end
								ADD_WAIT = ADD_WAIT + 1;
							end
						WRITE_REG :
							begin
								F56_WRn_O = 0;
								if (WRITE_WAIT == 0)
									begin
										if (CHIP_SEL[0] == 1)
												F56_CSn_O[0] = 0;
										else if (CHIP_SEL[1] == 1)
												F56_CSn_O[1] = 0;
									end
								if (WRITE_WAIT == ADD_MAX_RW + 2)
									begin
										F56_TYPE2_STATE = IDLE;
										F56_CSn_O = 2'b11;
										WRITE_END = 1;
										F56_WRn_O = 1;
									end
								WRITE_WAIT = WRITE_WAIT + 1;
							end
						
					endcase
					
				end
				
		reg [5:0] reg_counter = 0;
		always @(posedge PHY_CLK33_I)
				begin
					if (PHY_RSTn_I == 0)
						begin
						    GNT_CAPTURE			= 0;
						    REQ_CAPTURE         = 0;
							ALE_CAPTURE      = 0;
			                BADD_DIR_CAPTURE = 0;
			                RDn_CAPTURE      = 0;
			                WRn_CAPTURE      = 0;
							Csn0_CAPTURE 	 = 0;
							Csn1_CAPTURE     = 0;
							reg_counter      = 0;
							
							
						end
					else
						begin
						   if (F56_TYPE2_STATE == IDLE && (READ_FLAG == 1 || WRITE_FLAG == 1))
								begin
									reg_counter = 0;
								end	
						   else if (reg_counter < 32)
								begin
									GNT_CAPTURE[reg_counter] =  F56_WB_GNT_I;
									REQ_CAPTURE[reg_counter] =  F56_WB_REQ_O;
									ALE_CAPTURE[reg_counter] =  F56_ALE_O;  
									BADD_DIR_CAPTURE[reg_counter] = F56_BADD_DIR_O; // 16
									RDn_CAPTURE[reg_counter] =      F56_RDn_O;  // 20
									WRn_CAPTURE[reg_counter] =      F56_WRn_O;
									Csn0_CAPTURE[reg_counter] =     F56_CSn_O[0];
									Csn1_CAPTURE[reg_counter] =     F56_CSn_O[1];
									DATA_CAP[reg_counter] = F56_BADD_I;
									reg_counter = reg_counter + 1; 
								end
							else
								reg_counter = reg_counter;
						end
				end         
endmodule
