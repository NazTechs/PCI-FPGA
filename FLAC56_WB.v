`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2019 11:10:57 PM
// Design Name: 
// Module Name: FLAC56_WB
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


module FLAC56_WB(
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
	
	reg [15:0] FL56_STATE = 0;
	reg [31:0] FL56_CMD   = 0;
	reg CMD_FLAG = 0;
	reg READ_DATA_FLAG = 0;
	
	reg [31:0] F56_READ = 0;
	
	reg [7:0] READ_COUNTER = 0;
	reg [7:0] WRITE_COUNTER = 0;
	
	reg [31:0] ALE_CAPTURE = 0;
	reg [31:0] BADD_DIR_CAPTURE = 0;
	reg [31:0] RDn_CAPTURE = 0;
	reg [31:0] WRn_CAPTURE = 0;
	reg [31:0] Csn0_CAPTURE = 0;
	reg [31:0] Csn1_CAPTURE = 0;
	reg [7:0] DATA_CAP[31:0];
	reg [4:0] readVector = 0;
	
	reg [31:0] GNT_CAPTURE = 0;
	reg [31:0] REQ_CAPTURE = 0;
	
	always @(posedge PHY_CLK33_I)
		begin
			if(PHY_RSTn_I == 0)
				begin
					WB_DATA_O = 0;
					WB_ACK_O = 0;
					WB_VALID_O = 0;
					CMD_FLAG = 0;
				end
			else if (WB_STB_I == 0)
				begin
					WB_DATA_O = 0;
					WB_ACK_O = 0;
					WB_VALID_O = 0;
					CMD_FLAG = 0;
				end
			else 
			begin
				CMD_FLAG = 0;
				READ_DATA_FLAG = 0;
				if (WB_WE_I == 0) //read cycle
					begin
						case (WB_ADD_I[11:2])
							0:
								begin
									WB_DATA_O = {FL56_STATE[15:0],WRITE_COUNTER[7:0],READ_COUNTER[7:0]};
								end
							1 : 
								begin
									WB_DATA_O[7:0] = F56_READ[7:0];
									WB_DATA_O[31:8] = 0;
									READ_DATA_FLAG = 1;
								end
							//2: CMD WONLY
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
							11 : 
								WB_DATA_O = GNT_CAPTURE;
							12 :
								WB_DATA_O = REQ_CAPTURE;
								
							default :
								WB_DATA_O = 0;
						endcase
						WB_VALID_O = 1;
					end
				else 
					begin
						case (WB_ADD_I[11:2])
							/*0 :
							
							*/
							  2 :
								begin
								 FL56_CMD = WB_DATA_I;
								 CMD_FLAG = 1;
								end
							10 :
								begin
									readVector = WB_DATA_I;
								end
						endcase
						WB_ACK_O = 1;
					end
			end
		end
		
		localparam IDLE = 0;
		localparam READY = 1;
		localparam BUS_REQIURE = 2;
		localparam DECODE = 3;
		localparam ADD_LATCH = 4;
		localparam READ_REG = 5;
		localparam WRITE_REG = 6;
		
		
		reg [7:0] F56_REG_ADD = 0;
		reg [15:0] F56_REG_WDATA = 0;
		reg [7:0]  F56_REG_CMD   = 0;
		
		reg [3:0]  F56_STATE = IDLE;
		
		reg [2:0] ADD_WAIT = 0;
		reg [2:0] READ_WAIT = 0;
		reg [2:0] WRITE_WAIT = 0;
		
		reg TEST_CAP = 0;
		reg TEST_CAP1 = 0;
		reg TEST_CAP2 = 0;
		reg TEST_CAP3 = 0;
		reg TEST_CAP4 = 0;

	
		localparam ADD_MAX_WAIT = 3; //30ns req -- 60mhz clk = 16.6ns -- 30ns pci clk
		localparam ADD_MAX_RW    = 3; //80ns req -- 60mhz clk = 16.6ns -- 30ns pci clk
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
					
					F56_REG_ADD = 0;
					F56_REG_WDATA = 0;
					F56_REG_CMD  = 0;
					
					F56_READ = 0;
					FL56_STATE = 0;
					READ_COUNTER = 0;
					WRITE_COUNTER = 0;
					
					F56_WB_REQ_O = 0;
					F56_STATE = IDLE; 
				end
			else
				begin
					FL56_STATE[8] = F56_RSTn_O;
					if (READ_DATA_FLAG == 1)
						FL56_STATE[9] = 0;
					case (F56_STATE)
						IDLE : 
							begin
								TEST_CAP = ~TEST_CAP;
							
								FL56_STATE[7:0] = 8'h01; //IDLE
								F56_BADD_O     = 0;
								F56_BADD_DIR_O = 0;
								F56_ALE_O = 0;
								F56_RDn_O = 1;
								F56_WRn_O = 1;
								F56_CSn_O = 2'b11;
								
								ADD_WAIT = 0;
								READ_WAIT = 0;
								WRITE_WAIT = 0;
								
								F56_WB_REQ_O = 0;
								
								if (CMD_FLAG == 0)
									F56_STATE = READY;
							end
						READY :
							begin
								if (CMD_FLAG == 1)
									begin
										F56_STATE = BUS_REQIURE;
										F56_WB_REQ_O = 1;
									end
							end
							
						BUS_REQIURE :
							begin
								if (F56_WB_GNT_I == 1)
									F56_STATE = DECODE;
							end
						DECODE :
								begin
									TEST_CAP1 = ~TEST_CAP1;
									FL56_STATE[7:0] = 8'h02; //COMMAND DECODE
									F56_REG_ADD [7:0] = FL56_CMD[23:16];
									F56_REG_WDATA[15:0] = FL56_CMD[15:0];
									F56_REG_CMD[7:0] = FL56_CMD[31:24];
									if (F56_REG_CMD[7] == 1)
										begin
											F56_STATE = IDLE;
											F56_RSTn_O = F56_REG_WDATA[0] ;
											
										end
									else if (F56_REG_CMD[2] == 1)
										begin
											F56_STATE = ADD_LATCH;
											F56_BADD_DIR_O = 1;
											F56_BADD_O = F56_REG_ADD;
										end
									else if (F56_REG_CMD[3] == 0)
										begin
											F56_STATE = READ_REG;
										end
									else
										begin
											F56_STATE = WRITE_REG;
											F56_BADD_DIR_O = 1;
										end
								end
						ADD_LATCH : 
							begin
								TEST_CAP2 = ~TEST_CAP2;
								//ALE pulse width 30 ns
								//ALE setup time before command active 0 ns
								FL56_STATE[7:0] = 8'h04; //ADD DECODE
								F56_ALE_O = 1;
								if (ADD_WAIT == ADD_MAX_WAIT)
									begin
										F56_ALE_O = 0;
										if (F56_REG_CMD[3] == 0)
											begin
												F56_STATE = READ_REG;
												F56_BADD_DIR_O = 0;
											end
										else
											begin
												F56_STATE = WRITE_REG;
											end
									end
								ADD_WAIT = ADD_WAIT + 1;
							end
						READ_REG :
							begin
								TEST_CAP3 = ~TEST_CAP3;
								//RD, WR pulse width 80 ns
								//Data valid after RD active 75 ns
								//RD, WR control interval 70 ns
								//CS setup time 0 ns
								FL56_STATE[7:0] = 8'h08; //READ CYCLE
								F56_RDn_O = 0;
								if (F56_REG_CMD[6] == 0)
									F56_CSn_O[0] = 0;
								else
									F56_CSn_O[1] = 0;
								if (READ_WAIT == ADD_MAX_RW)
									begin
										F56_READ[7:0] = F56_BADD_I[7:0];
										FL56_STATE[9] = 1; //newdata available;
										F56_STATE = IDLE;
										READ_COUNTER = READ_COUNTER  + 1;
									end
								READ_WAIT = READ_WAIT + 1;
							end
						WRITE_REG :
							begin
								TEST_CAP4 = ~TEST_CAP4;
								FL56_STATE[7:0] = 8'h10; //WRITE CYCLE
								
								F56_BADD_O[7:0] = F56_REG_WDATA[7:0];
								if (WRITE_WAIT == 1)
									begin
										F56_WRn_O = 0;
										if (F56_REG_CMD[6] == 0)
											F56_CSn_O[0] = 0;
										else
											F56_CSn_O[1] = 0;
									end
								if (WRITE_WAIT == ADD_MAX_RW + 1)
									begin
										F56_STATE = IDLE;
										WRITE_COUNTER = WRITE_COUNTER + 1;
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
							ALE_CAPTURE      = 0;
			                BADD_DIR_CAPTURE = 0;
			                RDn_CAPTURE      = 0;
			                WRn_CAPTURE      = 0;
							Csn0_CAPTURE 	 = 0;
							Csn1_CAPTURE     = 0;
							reg_counter      = 0;
							
							GNT_CAPTURE			= 0;
						    REQ_CAPTURE         = 0;
							
							
						end
					else
						begin
						   if (F56_STATE == READY && CMD_FLAG == 1)
								begin
									reg_counter = 0;
								end	
						   else if (reg_counter < 32)
								begin
									GNT_CAPTURE[reg_counter] =  F56_WB_GNT_I;
									REQ_CAPTURE[reg_counter] =  F56_WB_REQ_O;
									ALE_CAPTURE[reg_counter] =     /* TEST_CAP; */  F56_ALE_O;   //12 
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
            
            