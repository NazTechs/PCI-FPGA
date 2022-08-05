`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: SOHEIL NAZARI +989122939002
// 
// Create Date: 12/25/2018 05:38:52 PM
// Design Name: 
// Module Name: PCI_DEFSM_HPMEM_MNG
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


module PCI_DEFSM_HPMEM_MNG(
	input PHY_CLK33_I,
	input PHY_RSTn_I,
	

	output reg DEFSM_HPMEM_END_O = 0,
	input      HPMEM_WR_I,
	input      DEFSM_ADD2HPMEM_I,
	output reg HPMEM_OUTPUT_EN_O = 0,
	
	input [23:2] PCI_ADD_I,
	
	input [31:0] CFG_REG_0x04_I,
	output reg CFG_STATE_HPMEM_ABORT_O = 0,
	
	output reg HPMEM_PAR_REQ_O = 0,
	
	input  HPMEM_FRAMEn_I,
	input  HPMEM_IRDYn_I,
	
	output reg   HPMEM_TRDYn_O = 1,
	output reg   HPMEM_TRDYn_DIR_O = 0,
	output reg   HPMEM_DEVSELn_O = 1,
	output reg   HPMEM_DEVSELn_DIR_O = 0,
	output reg   HPMEM_STOPn_O = 1 ,
	output reg   HPMEM_STOPn_DIR_O = 0,

	

	output reg  [31:0]  HPMEM_AD_O = 0,
	output reg          HPMEM_AD_DIR_O = 0,
	input [31:0]        HPMEM_AD_I,
	
	input [3:0]         HPMEM_CBEn_I,
	
	output HP_MEM_IDLE_O,
	//HPRAM INTERFACE
	
	input [31:0] HPRAM_DATA_I,
	output reg [31:0] HPRAM_DATA_O = 0,
	output reg [11:0] HPRAM_ADD_O = 0,
	output reg [3:0]  HPRAM_WEN_O = 0
	

	
    );
	

	
	localparam READY       = 0;
	localparam WRITE       = 1;
	localparam READ        = 2;
	localparam TERMINATE   = 3;
	localparam WAITE_WRITE = 4;
	localparam WAITE_READ  = 5;
	
	reg [2:0] HPMEM_STATE = READY;
	reg [31:0] prv_data = 0;
	reg FIRST = 1;
   
  /* localparam RAM_WIDTH = 32;
   localparam RAM_ADDR_BITS = 12;
	
	//(* RAM_STYLE="{auto | block |  block_power1 | block_power2}" *)
	(* RAM_STYLE="{BLOCK}" *)
   reg [31:0] HPRAM [(2**8)-1:0];
   reg [7:0] HRAM_ADD = 0;*/
	
	assign HP_MEM_IDLE_O = (HPMEM_STATE == READY) ? 1'b1 : 1'b0;

	always @(posedge PHY_CLK33_I)
		if (PHY_RSTn_I == 0)
			begin

				HPMEM_TRDYn_O = 1;
				HPMEM_TRDYn_DIR_O = 0;
				HPMEM_DEVSELn_O = 1;
				HPMEM_DEVSELn_DIR_O = 0;
				HPMEM_STOPn_O = 1;
				HPMEM_STOPn_DIR_O = 0;
				
				HPMEM_AD_O = 0;
				HPMEM_AD_DIR_O = 0;

				DEFSM_HPMEM_END_O = 0;
				HPMEM_OUTPUT_EN_O = 0;
				
				CFG_STATE_HPMEM_ABORT_O = 0;
				
				HPMEM_PAR_REQ_O = 0;
				HPRAM_WEN_O = 0;
				HPRAM_ADD_O = 0;				
				HPRAM_DATA_O = 0;	
				
				

				HPMEM_STATE = READY;				

				
			end
		else
			begin
				case (HPMEM_STATE)
					READY :
						begin
						DEFSM_HPMEM_END_O = 0;
							if (DEFSM_ADD2HPMEM_I == 1)
								begin
									HPMEM_OUTPUT_EN_O = 1;
									HPMEM_DEVSELn_O = 0;
									HPMEM_TRDYn_DIR_O = 1;
									HPMEM_DEVSELn_DIR_O = 1;
									HPMEM_STOPn_DIR_O = 1;
									HPMEM_STOPn_O = 1;
									HPMEM_TRDYn_O = 1;		
									HPRAM_ADD_O[11:0] = PCI_ADD_I[13:2];
									FIRST = 1;
									if (HPMEM_WR_I == 0) //read cycle
										begin
											HPMEM_AD_DIR_O = 1; //bus turn around	
											HPMEM_STATE = WAITE_READ;
										end
									else	//WRITE CYCLE
										begin
										HPMEM_STATE = WRITE;
										end
								end
						end
					WAITE_READ :
					if (HPMEM_IRDYn_I == 0)
						begin
							
							HPMEM_STATE = READ;
							HPRAM_ADD_O = HPRAM_ADD_O + 1;
							HPMEM_AD_O[31:24] = HPMEM_CBEn_I[3] == 0 ? HPRAM_DATA_I[31:24] : 8'h00;
							HPMEM_AD_O[23:16] = HPMEM_CBEn_I[2] == 0 ? HPRAM_DATA_I[23:16] : 8'h00;
							HPMEM_AD_O[15:8]  = HPMEM_CBEn_I[1] == 0 ? HPRAM_DATA_I[15:8]  : 8'h00;
							HPMEM_AD_O[7:0]   = HPMEM_CBEn_I[0] == 0 ? HPRAM_DATA_I[7:0]   : 8'h00;
							
						end
					WAITE_WRITE :
						if (HPMEM_IRDYn_I == 0)
							begin
								HPMEM_STATE = WRITE;	
							end
					READ :
						begin
							
							if (HPMEM_IRDYn_I == 0)
								begin
								
									HPRAM_ADD_O = HPRAM_ADD_O + 1;
									HPMEM_AD_O[31:24] = HPMEM_CBEn_I[3] == 0 ? HPRAM_DATA_I[31:24] : 8'h00;
									HPMEM_AD_O[23:16] = HPMEM_CBEn_I[2] == 0 ? HPRAM_DATA_I[23:16] : 8'h00;
									HPMEM_AD_O[15:8]  = HPMEM_CBEn_I[1] == 0 ? HPRAM_DATA_I[15:8]  : 8'h00;
									HPMEM_AD_O[7:0]   = HPMEM_CBEn_I[0] == 0 ? HPRAM_DATA_I[7:0]   : 8'h00;
									
									
									HPMEM_TRDYn_O = 0;
									//HPMEM_STOPn_O = 0;
									HPMEM_PAR_REQ_O = 1;
									
									
										
									FIRST = 0;
								end
							else if (FIRST == 0 && HPMEM_FRAMEn_I == 1)
									begin
										//HPMEM_STATE = TERMINATE;
										HPMEM_AD_DIR_O = 0;
										HPMEM_PAR_REQ_O = 0;
										HPMEM_TRDYn_O = 1;	
										//HPMEM_STOPn_O = 1;										
										DEFSM_HPMEM_END_O = 1;
										
										
										HPMEM_OUTPUT_EN_O = 0;
										CFG_STATE_HPMEM_ABORT_O = 0;
										HPMEM_STATE = READY;
										HPMEM_DEVSELn_O = 1;
										HPMEM_DEVSELn_DIR_O = 0;
										HPMEM_STOPn_O = 1;
										HPMEM_STOPn_DIR_O = 0;		
									end
							else 
							begin
								HPMEM_TRDYn_O = 1;
								HPMEM_PAR_REQ_O = 1;
							end
						end
					WRITE :
						begin
								HPRAM_DATA_O = HPMEM_AD_I;
							if (HPMEM_IRDYn_I == 0)
								begin
									if (HPMEM_CBEn_I[3] == 0)
										begin
											HPRAM_WEN_O[3] = 1;
										end
									else
										HPRAM_WEN_O[3] = 0;
										
									if (HPMEM_CBEn_I[2] == 0)
										begin
											HPRAM_WEN_O[2] = 1;
										end
									else
										HPRAM_WEN_O[2] = 0;
										
									if (HPMEM_CBEn_I[1] == 0)
										begin
											HPRAM_WEN_O[1] = 1;
										end
									else	
										HPRAM_WEN_O[1] = 0;
										
									if (HPMEM_CBEn_I[0] == 0)
										begin 
											HPRAM_WEN_O[0] = 1;
										end
									else
										HPRAM_WEN_O[0] = 0;
									HPMEM_TRDYn_O = 0;
									//HPMEM_STOPn_O = 0;
									
									if (HPMEM_FRAMEn_I == 0 && FIRST == 0)
										begin
											HPRAM_ADD_O = HPRAM_ADD_O + 1;
										end
									FIRST = 0;
								end	
							else if (FIRST == 0 && HPMEM_FRAMEn_I == 1)
								begin
									HPMEM_STATE = TERMINATE;
									HPMEM_TRDYn_O = 1;
									DEFSM_HPMEM_END_O = 1;
									HPRAM_WEN_O = 0;
								end
							else
								HPRAM_WEN_O = 0;
						
						end
					TERMINATE :
						begin
							HPMEM_OUTPUT_EN_O = 0;
							CFG_STATE_HPMEM_ABORT_O = 0;
							HPRAM_WEN_O = 0;
							HPMEM_STATE = READY;
							HPMEM_DEVSELn_O = 1;
							HPMEM_DEVSELn_DIR_O = 0;
							HPMEM_TRDYn_O = 1;
							HPMEM_AD_DIR_O = 0;
							HPMEM_STOPn_O = 1;
							HPMEM_STOPn_DIR_O = 0;
							HPMEM_PAR_REQ_O = 0;
							DEFSM_HPMEM_END_O = 0;
							
							
						end	

				endcase			
			end
endmodule
