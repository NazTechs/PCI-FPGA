`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2019 12:23:41 AM
// Design Name: 
// Module Name: FALC56_WB_INT
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


module FALC56_WB_INT(

	input FALC56_DCM_CLK0_I,
	input PHY_RSTn_I, 
	
	input      [31:0]  WB_ADD_I,
	output reg [31:0]  WB_DATA_O,
	input      [31:0]  WB_DATA_I,
	
	output reg WB_ACK_O = 0,
	output reg WB_VALID_O = 0,
	
	input WB_STB_I,
	input WB_WE_I,
	
	// CONTROL BUS 
	output reg F56_WB_EN_O = 0,
	output reg F56_WB_REQ_O = 0,
	input  F56_WB_GNT_I,
	
	
	// F56 BUS
	input  	   [7:0] F56_WB_BADD_I,
	output reg [7:0] F56_WB_BADD_O,
	output reg       F56_WB_BADD_DIR_O = 0,

	output reg F56_WB_ALE_O, 
	output reg F56_WB_RDn_O,
	output reg F56_WB_WRn_O,
	output reg [1:0] F56_WB_CSn_O = 2'b11,
	
	//FALC56ENGINE REGISTERS
	
	input [7:0] F56_ENG_STATE,
	output reg [7:0] F56_ENG_CMD = 0,
	
	//DMA REGISTERS
	output reg [12:0] DMA0_SRC_ADD_O = 0,
	output reg [12:0] DMA0_DST_ADD_O = 0,
	output reg        DMA0_DATA_DIR_O = 0,
	output reg [7:0]  DMA0_CMD_O = 0,
	input   [7:0]     DMA0_STATE_I,
	
	output reg [12:0] DMA1_SRC_ADD_O = 0,
	output reg [12:0] DMA1_DST_ADD_O = 0,
	output reg        DMA1_DATA_DIR_O = 0,
	output reg [7:0]  DMA1_CMD_O = 0,
	input   [7:0]     DMA1_STATE_I
	
	
    );
	
	parameter IDLE = 0;
	parameter DMA0_REG_WRITE = 1;
	parameter DMA0_REG_READ = 2;
	parameter DMA1_REG_WRITE = 3;
	parameter DMA1_REG_READ = 4;
	parameter F56_CMD_READ 	= 5;
	parameter F56_CMD_WRITE = 6;
	parameter F56_WRITE_ADD = 7;
	parameter F56_WRITE = 8;
	parameter F56_READ_ADD 	= 9;
	parameter F56_READ 	= 10;
	parameter DONE = 11;
	
	reg [3:0] WB_F56_STATE = 0;
	
	reg [2:0] ADD_WAITE = 0;
	reg [2:0] READ_WAITE = 0;
	reg [2:0] WRITE_WAITE = 0;
	
	parameter ADD_MAX_WAITE = 2; //30ns req -- 60mhz clk = 16.6ns
	parameter ADD_MAX_RW    = 5; //80ns req -- 60mhz clk = 16.6ns
	
	always @(posedge FALC56_DCM_CLK0_I)
		if (PHY_RSTn_I == 0)
			begin
				WB_DATA_O = 0;
				WB_ACK_O = 0;
				WB_VALID_O = 0;
				
				F56_WB_REQ_O = 0;
				F56_WB_EN_O = 0;
				
				F56_WB_CSn_O = 2'b11;
				
				DMA0_CMD_O = 0;
				DMA1_CMD_O = 0;
				
				WB_F56_STATE = IDLE;
				F56_WB_BADD_DIR_O = 0;
				
				ADD_WAITE = 0;
				READ_WAITE = 0;
				WRITE_WAITE = 0;
			end
		else if (WB_STB_I == 0)
			begin
				WB_DATA_O = 0;
				WB_ACK_O = 0;
				WB_VALID_O = 0;
				
				F56_WB_REQ_O = 0;
				F56_WB_EN_O = 0;
				
				WB_F56_STATE = IDLE;
				F56_WB_BADD_DIR_O = 0;
				
				F56_WB_CSn_O = 2'b11;
				ADD_WAITE = 0;
				READ_WAITE = 0;
				WRITE_WAITE = 0;
			end
		else
			begin
				case(WB_F56_STATE)
					IDLE :
						begin
							case (WB_ADD_I[15:11]) //address decode
								0 : 
									begin
										WB_F56_STATE = (WB_WE_I == 1) ? 
											DMA0_REG_WRITE : DMA0_REG_READ;
									end
								1 : 
									begin
										WB_F56_STATE = (WB_WE_I == 1) ? 
											DMA1_REG_WRITE : DMA1_REG_READ;
									end
								2 : 
									begin
										WB_F56_STATE = (WB_WE_I == 1) ? 
											F56_CMD_WRITE : F56_CMD_READ;
									end
								4 : 
									begin
										WB_F56_STATE = (WB_WE_I == 1) ? 
											F56_WRITE_ADD : F56_READ_ADD;
											F56_WB_REQ_O = 1;
									end
							endcase
						end
					DMA0_REG_WRITE :
						begin
							case (WB_ADD_I[9:2])
								0 :
									DMA0_SRC_ADD_O[12:0] = WB_DATA_I[12:0] ;
								1:
									DMA0_DST_ADD_O[12:0] = WB_DATA_I[12:0];
								2:
									DMA0_DATA_DIR_O = WB_DATA_I[0];
								4:
									DMA0_CMD_O[7:0] = WB_DATA_I[7:0];
							endcase
							WB_VALID_O = 1;	
						end
					DMA0_REG_READ :
						begin
							case (WB_ADD_I[9:2])
								0 :
									WB_DATA_O[12:0] = DMA0_SRC_ADD_O[12:0];
								1:
									WB_DATA_O[12:0] = DMA0_DST_ADD_O[12:0];
								2:
									WB_DATA_O[0] = DMA0_DATA_DIR_O;
								4:
									WB_DATA_O[7:0] = DMA0_CMD_O[7:0];
								8:  
									WB_DATA_O[7:0] = DMA0_STATE_I;
							endcase
							WB_ACK_O  = 1;	
						end
					DMA1_REG_WRITE :
						begin
							case (WB_ADD_I[9:2])
								0 :
									DMA1_SRC_ADD_O[12:0] = WB_DATA_I[12:0] ;
								1:
									DMA1_DST_ADD_O[12:0] = WB_DATA_I[12:0];
								2:
									DMA1_DATA_DIR_O = WB_DATA_I[0];
								4:
									DMA1_CMD_O[7:0] = WB_DATA_I[7:0];
							endcase
							WB_VALID_O = 1;	
						end
					DMA1_REG_READ :
						begin
							case (WB_ADD_I[9:2])
								0 :
									WB_DATA_O[12:0] = DMA1_SRC_ADD_O[12:0];
								1:
									WB_DATA_O[12:0] = DMA1_DST_ADD_O[12:0];
								2:
									WB_DATA_O[0] = DMA1_DATA_DIR_O;
								4:
									WB_DATA_O[7:0] = DMA1_CMD_O[7:0];
								8:  
									WB_DATA_O[7:0] = DMA1_STATE_I;
							endcase
							WB_ACK_O = 1;
						end
					F56_CMD_READ : 
						begin
							case (WB_ADD_I[9:2])
								0 : 
									WB_DATA_O[7:0] = F56_ENG_STATE;
								1 : 
									WB_DATA_O[7:0] = F56_ENG_CMD;
							endcase
							WB_VALID_O = 1;	
						end
					F56_CMD_WRITE :
						begin
							case (WB_ADD_I[9:2])
								1 : 
									 F56_ENG_CMD = WB_DATA_I[7:0];
							endcase
						WB_ACK_O = 1;
						end
					F56_WRITE_ADD :
						if (F56_WB_GNT_I == 1)
							begin //
								F56_WB_EN_O = 1;
							
								F56_WB_ALE_O = 1;
								F56_WB_BADD_O = WB_ADD_I[9:2];
								F56_WB_BADD_DIR_O = 1;
								ADD_WAITE = ADD_WAITE + 1;
								if (ADD_WAITE == ADD_MAX_WAITE)
									begin
									ADD_WAITE = 0;
									WB_F56_STATE = F56_WRITE;
									F56_WB_ALE_O = 0;
									end
							end
					F56_WRITE :
						begin
						
						
						end
					F56_READ_ADD  :
						if (F56_WB_GNT_I == 1)
							begin //
								F56_WB_EN_O = 1;
							
								F56_WB_ALE_O = 1;
								F56_WB_BADD_O = WB_ADD_I[9:2];
								F56_WB_BADD_DIR_O = 1;
								ADD_WAITE = ADD_WAITE + 1;
								if (ADD_WAITE == ADD_MAX_WAITE)
									begin
									ADD_WAITE = 0;
									WB_F56_STATE = F56_READ;
									F56_WB_ALE_O = 0;
									F56_WB_BADD_DIR_O = 0;
									end
							end
					F56_READ :
						begin
						
						end
					DONE :
						begin
						
						end
				endcase
			end
endmodule
