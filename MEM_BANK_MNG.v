`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2019 09:13:59 PM
// Design Name: 
// Module Name: MEM_BANK_MNG
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


module MEM_BANK_MNG(
	input PHY_CLK33_I,
	input PHY_RSTn_I,
	
	
	input      [31:0]  WB_ADD_I,
	output reg [31:0]  WB_DATA_O = 0,
	input      [31:0]  WB_DATA_I,
	
	output reg WB_ACK_O = 0,
	output reg WB_VALID_O = 0,
	
	input WB_STB_I,
	input WB_WE_I,
	
	input HP_MEM_IDLE_I,
	output reg FL56_BRAM_ENABLE_O = 0,
	
	input  [31:0] HPRAM_DATA_I,
	output reg [31:0] HPRAM_DATA_O,
	input  [11:0] HPRAM_ADD_I,
	input  [3:0]  HPRAM_WEN_I,
	
	input  [31:0] F56RAM_DATA_I,
	output reg [31:0] F56RAM_DATA_O,
	input  [11:0] F56RAM_ADD_I,
	input  [3:0]  F56RAM_WEN_I
	
    );




reg [3:0]  B0HPRAM_WEN;
reg [31:0] B0HPRAM_ADD;
reg [31:0] B0HPRAM_DATA_O;
wire [31:0] B0HPRAM_DATA_I;


reg [3:0]  B1HPRAM_WEN;
reg [31:0] B1HPRAM_ADD;
reg [31:0] B1HPRAM_DATA_O;
wire [31:0] B1HPRAM_DATA_I;


blk_mem_gen_v7_3_1 B0HPRAM0 (
	  .clka(PHY_CLK33_I), // input clka
	  .wea(B0HPRAM_WEN[0]), // input [0 : 0] wea
	  .addra(B0HPRAM_ADD), // input [11 : 0] addra
	  .dina(B0HPRAM_DATA_O[7:0]), // input [7 : 0] dina
	  .douta(B0HPRAM_DATA_I[7:0]) // output [7 : 0] douta
	);
	
	blk_mem_gen_v7_3_1 B0HPRAM1 (
	  .clka(PHY_CLK33_I), // input clka
	  .wea(B0HPRAM_WEN[1]), // input [0 : 0] wea
	  .addra(B0HPRAM_ADD), // input [11 : 0] addra
	  .dina(B0HPRAM_DATA_O[15:8]), // input [7 : 0] dina
	  .douta(B0HPRAM_DATA_I[15:8]) // output [7 : 0] douta

	);
	
	blk_mem_gen_v7_3_1 B0HPRAM2 (
	  .clka(PHY_CLK33_I), // input clka
	  .wea(B0HPRAM_WEN[2]), // input [0 : 0] wea
	  .addra(B0HPRAM_ADD), // input [11 : 0] addra
	  .dina(B0HPRAM_DATA_O[23:16]), // input [7 : 0] dina
	  .douta(B0HPRAM_DATA_I[23:16]) // output [7 : 0] douta

	);
	
	blk_mem_gen_v7_3_1 B0HPRAM3 (
	  .clka(PHY_CLK33_I), // input clka
	  .wea(B0HPRAM_WEN[3]), // input [0 : 0] wea
	  .addra(B0HPRAM_ADD), // input [11 : 0] addra
	  .dina(B0HPRAM_DATA_O[31:24]), // input [7 : 0] dina
	  .douta(B0HPRAM_DATA_I[31:24])// output [7 : 0] douta

	);
	
	
	
	blk_mem_gen_v7_3_1 B1HPRAM0 (
	  .clka(PHY_CLK33_I), // input clka
	  .wea(B1HPRAM_WEN[0]), // input [0 : 0] wea
	  .addra(B1HPRAM_ADD), // input [11 : 0] addra
	  .dina(B1HPRAM_DATA_O[7:0]), // input [7 : 0] dina
	  .douta(B1HPRAM_DATA_I[7:0]) // output [7 : 0] douta
	);
	
	blk_mem_gen_v7_3_1 B1HPRAM1 (
	  .clka(PHY_CLK33_I), // input clka
	  .wea(B1HPRAM_WEN[1]), // input [0 : 0] wea
	  .addra(B1HPRAM_ADD), // input [11 : 0] addra
	  .dina(B1HPRAM_DATA_O[15:8]), // input [7 : 0] dina
	  .douta(B1HPRAM_DATA_I[15:8]) // output [7 : 0] douta

	);
	
	blk_mem_gen_v7_3_1 B1HPRAM2 (
	  .clka(PHY_CLK33_I), // input clka
	  .wea(B1HPRAM_WEN[2]), // input [0 : 0] wea
	  .addra(B1HPRAM_ADD), // input [11 : 0] addra
	  .dina(B1HPRAM_DATA_O[23:16]), // input [7 : 0] dina
	  .douta(B1HPRAM_DATA_I[23:16]) // output [7 : 0] douta

	);
	
	blk_mem_gen_v7_3_1 B1HPRAM3 (
	  .clka(PHY_CLK33_I), // input clka
	  .wea(B1HPRAM_WEN[3]), // input [0 : 0] wea
	  .addra(B1HPRAM_ADD), // input [11 : 0] addra
	  .dina(B1HPRAM_DATA_O[31:24]), // input [7 : 0] dina
	  .douta(B1HPRAM_DATA_I[31:24])// output [7 : 0] douta

	);
	
	
	reg  [31:0] BANK_REG = 32'h0000_0002;
	reg  [31:0] SWITCHTIMER = 33333;
    reg BANK_REG_WRITE_FLAG =  0;
	reg BANK_STATE = 0;
	
		reg MemorySel =  0;
	reg [2:0] MemorySwitcherState = 0;
	reg [31:0] MilSecCounter = 0;
	
	always @(posedge PHY_CLK33_I)
		if(PHY_RSTn_I == 0)
			begin
				BANK_REG = 32'h0000_0002;
				SWITCHTIMER = 33333;
				BANK_STATE = 0;
				
				WB_DATA_O = 0;
				WB_ACK_O = 0;
				WB_VALID_O = 0;
				
				BANK_REG_WRITE_FLAG =  0;
			
			end
		else if (WB_STB_I == 0)
			begin
				WB_DATA_O = 0;
				WB_ACK_O = 0;
				WB_VALID_O = 0;
				
				BANK_STATE = 0;
				
				BANK_REG_WRITE_FLAG =  0;
			end
		else
			begin
				BANK_REG_WRITE_FLAG =  0;
				case (BANK_STATE)
					0: 
						begin
							if(WB_WE_I == 0)
								begin
									case (WB_ADD_I[11:2])
										0 :
											begin
												WB_DATA_O = BANK_REG;
											
											end
										1 : 
											begin
												WB_DATA_O = SWITCHTIMER;
											end
										2 : 
											begin
												WB_DATA_O[0] = MemorySel;
												WB_DATA_O[31:1] = 0;
											end
										3 : 
											begin
												WB_DATA_O[2:0] = MemorySwitcherState;
												WB_DATA_O[31:3] = 0;
											end
										4 : 
											begin
												WB_DATA_O = MilSecCounter;
											end
										default :
											WB_DATA_O = 32'h0000_0000;
									endcase
									WB_VALID_O = 1;
								end
							else
								begin
									case (WB_ADD_I[11:2])
										0: 
											begin
												BANK_REG  = WB_DATA_I;
												BANK_REG_WRITE_FLAG =  1;
											end
										1 :
											begin
												SWITCHTIMER = WB_DATA_I;
												BANK_REG_WRITE_FLAG =  1;
											end
										
										
									endcase
									WB_ACK_O = 1;
								end				
						
						end
					1 : ;
				endcase
			end
			

	always @(posedge PHY_CLK33_I)
		if(PHY_RSTn_I == 0)
			begin
				MemorySel = 0;
				MemorySwitcherState = 0;
				MilSecCounter = 0;
				FL56_BRAM_ENABLE_O = 1 ;
			end
		else if (BANK_REG_WRITE_FLAG == 1)	
			begin
				MemorySwitcherState = 0;
				FL56_BRAM_ENABLE_O = 0 ; // FL56 MUST FREE MEMORY iN MAXIMU 3 CLK 
			end
		else 
			begin
				case (MemorySwitcherState)
					0 : 
						begin
							if (BANK_REG[1] == 0)
								MemorySwitcherState = 1;
							else 
								MemorySwitcherState = 3; //AUTOMATIC SWITCHER
							FL56_BRAM_ENABLE_O = 0 ;
						end
					1 : 
						if (HP_MEM_IDLE_I == 1)
							begin
								MemorySel = BANK_REG[0];
								MemorySwitcherState = 2;
							end
					2 : 
						;
					3 :
						begin
							if(MilSecCounter == SWITCHTIMER)
								begin
									MilSecCounter = 0;
									MemorySwitcherState = 4;
									FL56_BRAM_ENABLE_O = 0 ;
								end
							MilSecCounter = MilSecCounter + 1;
						end
					4 :
						begin
							if (HP_MEM_IDLE_I == 1)
								begin
									MemorySel = ~MemorySel;
									MemorySwitcherState = 3;
								end
						end
					default : 
						MemorySwitcherState = 0;
				endcase
			end
			
	always@(*)
		case (MemorySel)
			0 :
				begin
					B0HPRAM_DATA_O = HPRAM_DATA_I;
				    HPRAM_DATA_O = B0HPRAM_DATA_I;
				    B0HPRAM_ADD = HPRAM_ADD_I;
				    B0HPRAM_WEN = HPRAM_WEN_I;
				    
				    B1HPRAM_DATA_O = F56RAM_DATA_I;
				    F56RAM_DATA_O = B1HPRAM_DATA_I;
				    B1HPRAM_ADD = F56RAM_ADD_I;
				    B1HPRAM_WEN = F56RAM_WEN_I;
					
			
				end
			1: 
				begin
					B1HPRAM_DATA_O = HPRAM_DATA_I;
				    HPRAM_DATA_O = B1HPRAM_DATA_I;
				    B1HPRAM_ADD = HPRAM_ADD_I;
				    B1HPRAM_WEN = HPRAM_WEN_I;
				    
				    B0HPRAM_DATA_O = F56RAM_DATA_I;
				    F56RAM_DATA_O = B0HPRAM_DATA_I;
				    B0HPRAM_ADD = F56RAM_ADD_I;
				    B0HPRAM_WEN = F56RAM_WEN_I;
				end
		
		endcase
	endmodule