`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2018 04:00:47 PM
// Design Name: 
// Module Name: WB_INTERN
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


module WB_INTERN(

	input PHY_CLK33_I,
	input PHY_RSTn_I,
	
	
	input      [31:0]  M0_WB_ADD_I,
	output reg [31:0]  M0_WB_DATA_O = 0,
	input      [31:0]  M0_WB_DATA_I,
	
	output reg M0_WB_ACK_O = 0,
	output reg M0_WB_VALID_O = 0,
	
	input M0_WB_STB_I,
	input M0_WB_WE_I,
	
	
	output reg [31:0]  S0_WB_ADD_O = 0,
	output reg [31:0]  S0_WB_DATA_O = 0,
	input      [31:0]  S0_WB_DATA_I,
	
	input S0_WB_ACK_I,
	input S0_WB_VALID_I,
	
	output reg S0_WB_STB_O = 0,
	output reg S0_WB_WE_O = 0,
	
	
		
	output reg [31:0]  S1_WB_ADD_O = 0,
	output reg [31:0]  S1_WB_DATA_O = 0,
	input      [31:0]  S1_WB_DATA_I,
	
	input S1_WB_ACK_I,
	input S1_WB_VALID_I,
	
	output reg S1_WB_STB_O = 0,
	output reg S1_WB_WE_O = 0,
	
	
	output reg [31:0]  S2_WB_ADD_O = 0,
	output reg [31:0]  S2_WB_DATA_O = 0,
	input      [31:0]  S2_WB_DATA_I,
	
	input S2_WB_ACK_I,
	input S2_WB_VALID_I,
	
	output reg S2_WB_STB_O = 0,
	output reg S2_WB_WE_O = 0,
	
	output reg [31:0]  S3_WB_ADD_O = 0,
	output reg [31:0]  S3_WB_DATA_O = 0,
	input      [31:0]  S3_WB_DATA_I,
	
	input S3_WB_ACK_I,
	input S3_WB_VALID_I,
	
	output reg S3_WB_STB_O = 0,
	output reg S3_WB_WE_O = 0,
	
	output reg [31:0]  S4_WB_ADD_O = 0,
	output reg [31:0]  S4_WB_DATA_O = 0,
	input      [31:0]  S4_WB_DATA_I,
	
	input S4_WB_ACK_I,
	input S4_WB_VALID_I,
	
	output reg S4_WB_STB_O = 0,
	output reg S4_WB_WE_O = 0

    );
	
	/* +-------------------------------------------------------+
	---|					SLAVE ADRESS                       |
	---+-------------------------------------------------------+ */
	parameter S0_ADD = 4'b0000;
	parameter S1_ADD = 4'b0001;
	parameter S2_ADD = 4'b0010;
	parameter S3_ADD = 4'b0100;
	parameter S4_ADD = 4'b1000;
	

	always @(posedge PHY_CLK33_I)
		if(PHY_RSTn_I == 0)
			begin
				
			//Master 0 Wishbon Signal
				M0_WB_DATA_O = 0;
				M0_WB_ACK_O = 0;
				M0_WB_VALID_O = 0;
				
			//Slave 0 Wishbon Signal
				S0_WB_ADD_O = 0;
				S0_WB_DATA_O = 0;
				S0_WB_STB_O = 0;
				S0_WB_WE_O = 0;
				
			//Slave 1 Wishbon Signal
				S1_WB_ADD_O = 0;
				S1_WB_DATA_O = 0;
				S1_WB_STB_O = 0;
				S1_WB_WE_O = 0;
				
			//Slave 2 Wishbon Signal
				S2_WB_ADD_O = 0;
				S2_WB_DATA_O = 0;
				S2_WB_STB_O = 0;
				S2_WB_WE_O = 0;
				
			//Slave 3 Wishbon Signal
				S3_WB_ADD_O = 0;
				S3_WB_DATA_O = 0;
				S3_WB_STB_O = 0;
				S3_WB_WE_O = 0;
				
			//Slave 4 Wishbon Signal
				S4_WB_ADD_O = 0;
				S4_WB_DATA_O = 0;
				S4_WB_STB_O = 0;
				S4_WB_WE_O = 0;
				
	
			end
		else if (M0_WB_STB_I == 0)
			begin
				

				M0_WB_ACK_O = 0;
				M0_WB_VALID_O = 0;
				
				// SLAVE 0 WISHBON SIGNAL 
				S0_WB_STB_O = 0;
				
				// SLAVE 1 WISHBON SIGNAL 
				S1_WB_STB_O = 0;
				
				// SLAVE 2 WISHBON SIGNAL 
				S2_WB_STB_O = 0;
				
				// SLAVE 3 WISHBON SIGNAL 
				S3_WB_STB_O = 0;
				
				// SLAVE 4 WISHBON SIGNAL 
				S4_WB_STB_O = 0;
		
			end
		else
			begin
				 case ( M0_WB_ADD_I[15:12])
					S0_ADD : 
						begin
							S0_WB_ADD_O = M0_WB_ADD_I;
							S0_WB_DATA_O = M0_WB_DATA_I;
							M0_WB_DATA_O = S0_WB_DATA_I;

							M0_WB_ACK_O = S0_WB_ACK_I;
							M0_WB_VALID_O = S0_WB_VALID_I;
							S0_WB_WE_O = M0_WB_WE_I;
							S0_WB_STB_O = 1;
						end
					S1_ADD : 
						begin
							S1_WB_ADD_O = M0_WB_ADD_I;
							S1_WB_DATA_O = M0_WB_DATA_I;
							M0_WB_DATA_O = S1_WB_DATA_I;

							M0_WB_ACK_O = S1_WB_ACK_I;
							M0_WB_VALID_O = S1_WB_VALID_I;
							S1_WB_WE_O = M0_WB_WE_I;
							S1_WB_STB_O = 1;
						end
					S2_ADD : 
						begin
							S2_WB_ADD_O = M0_WB_ADD_I;
							S2_WB_DATA_O = M0_WB_DATA_I;
							M0_WB_DATA_O = S2_WB_DATA_I;

							M0_WB_ACK_O = S2_WB_ACK_I;
							M0_WB_VALID_O = S2_WB_VALID_I;
							S2_WB_WE_O = M0_WB_WE_I;
							S2_WB_STB_O = 1;
						end
					S3_ADD : 
						begin
							S3_WB_ADD_O = M0_WB_ADD_I;
							S3_WB_DATA_O = M0_WB_DATA_I;
							M0_WB_DATA_O = S3_WB_DATA_I;

							M0_WB_ACK_O = S3_WB_ACK_I;
							M0_WB_VALID_O = S3_WB_VALID_I;
							S3_WB_WE_O = M0_WB_WE_I;
							S3_WB_STB_O = 1;
						end			
					S4_ADD : 
						begin
							S4_WB_ADD_O = M0_WB_ADD_I;
							S4_WB_DATA_O = M0_WB_DATA_I;
							M0_WB_DATA_O = S4_WB_DATA_I;

							M0_WB_ACK_O = S4_WB_ACK_I;
							M0_WB_VALID_O = S4_WB_VALID_I;
							S4_WB_WE_O = M0_WB_WE_I;
							S4_WB_STB_O = 1;
						end
					default :
						begin
							M0_WB_ACK_O = 0;
							M0_WB_VALID_O = 0;
				
							// SLAVE 0 WISHBON SIGNAL 
							S0_WB_STB_O = 0;
							// SLAVE 1 WISHBON SIGNAL 
							S1_WB_STB_O = 0;
							// SLAVE 2 WISHBON SIGNAL 
							S2_WB_STB_O = 0;
							// SLAVE 3 WISHBON SIGNAL 
							S3_WB_STB_O = 0;
							// SLAVE 4 WISHBON SIGNAL 
							S4_WB_STB_O = 0;
						end
				endcase
			end
endmodule
