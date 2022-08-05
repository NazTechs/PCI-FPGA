`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2018 04:52:04 PM
// Design Name: 
// Module Name: WB_LED_SLAVE
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


module WB_LED_SLAVE(

	input PHY_CLK33_I,
	input PHY_RSTn_I,
	
	
	input      [31:0]  WB_ADD_I,
	output reg [31:0]  WB_DATA_O = 0,
	input      [31:0]  WB_DATA_I,
	
	output reg WB_ACK_O = 0,
	output reg WB_VALID_O = 0,
	
	input WB_STB_I,
	input WB_WE_I,
	
	output  [1:0] wb_led
    );
	
	
	reg [31:0] counter = 0;
	reg [31:0] dreg = 32'hAAAA_BBBB;
	reg WB_LED_SLAVE_STATE = 0;
	assign wb_led = counter[25:24];
	always @(posedge PHY_CLK33_I)
		if(PHY_RSTn_I == 0)
			begin
				counter = counter + 1;
				WB_DATA_O = 0;
				WB_ACK_O = 0;
				WB_VALID_O = 0;
				
				dreg = 0;
				
				WB_LED_SLAVE_STATE = 0;
				
			end
		else if (WB_STB_I == 0)
			begin
				WB_DATA_O = 0;
				WB_ACK_O = 0;
				WB_VALID_O = 0;
				//WB_LED_SLAVE_STATE = 0;
			end
		else
			case(WB_LED_SLAVE_STATE)
				0 :
					begin
						//WB_LED_SLAVE_STATE = 1;
						if(WB_WE_I == 0)
							begin
								case (WB_ADD_I[11:2])
									0 : 
										begin	 //counter reg
											WB_DATA_O = counter;

										end
									1 :
										begin
											WB_DATA_O = dreg;
										end
								endcase
								WB_VALID_O = 1;
							end
						else
							begin
								case (WB_ADD_I[11:2])
									0 :
										begin
											counter = WB_DATA_I;
										end
									1:
										begin
											dreg = WB_DATA_I;
										end
								endcase
								WB_ACK_O = 1;
							end
					end
				1 : ;
			endcase
	
endmodule
