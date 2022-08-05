`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2018 08:38:36 PM
// Design Name: 
// Module Name: WB_DEBUG_SLAVE
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


module WB_DEBUG_SLAVE(
	input PHY_CLK33_I,
	input PHY_RSTn_I,
	
	
	input      [31:0]  WB_ADD_I,
	output reg [31:0]  WB_DATA_O = 0,
	input      [31:0]  WB_DATA_I,
	
	output reg WB_ACK_O = 0,
	output reg WB_VALID_O = 0,
	
	input WB_STB_I,
	input WB_WE_I,
	
	
	input DBG_PCI_FRAMEn_I,
	input DBG_PCI_IRDYn_I,
	input DBG_PCI_TRDYn_I,
	input DBG_PCI_DEVSELn_I,
	input DBG_PCI_STOPn_I,
	input DBG_PCI_PAR_I,
	input DBG_PCI_PERRn_I,
	input DBG_PCI_SERRn_I,
	input DBG_PCI_REQn_I,
	input DBG_PCI_GNTn_I,
	
	input DBG_PCI_IDSEL_I
	
	
    );
	reg [9:0] dbg_ctr = 0;
	reg [15:0] framen_cnt = 0;
	reg [15:0] irdyn_cnt = 0;
	reg [15:0] trdyn_cnt = 0;
	reg [15:0] devseln_cnt = 0;
	reg [15:0] stopn_cnt = 0;
	reg [15:0] par_cnt = 0;
	reg [15:0] perrn_cnt = 0;
	reg [15:0] reqn_cnt = 0;
	reg [15:0] gntn_cnt = 0;
	reg [15:0] idsel_cnt = 0;
	

	
	reg WB_DBG_SLAVE_STATE = 0;
	
	always @(posedge PHY_CLK33_I)
		if(PHY_RSTn_I == 0)
			begin
				
				WB_DATA_O = 0;
				WB_ACK_O = 0;
				WB_VALID_O = 0;
				
				WB_DBG_SLAVE_STATE = 0;
				
				dbg_ctr = 0;
					
			end
		else if (WB_STB_I == 0)
			begin
				WB_DATA_O = 0;
				WB_ACK_O = 0;
				WB_VALID_O = 0;
				dbg_ctr = 0;
				//WB_DBG_SLAVE_STATE = 0;
			end
		else
			case(WB_DBG_SLAVE_STATE)
				0 :
					begin
						//WB_DBG_SLAVE_STATE = 1;
						if(WB_WE_I == 0)
							begin
								case (WB_ADD_I[11:2])
									/*0 : 
										begin	 
											WB_DATA_O = counter;

										end */
									1 :
										begin
											WB_DATA_O = {framen_cnt,devseln_cnt};
										end
									2 : 
										begin
											WB_DATA_O = {irdyn_cnt,trdyn_cnt};
										end
									3 : 
										begin
											WB_DATA_O = {stopn_cnt,idsel_cnt};
										end
									4 : 
										begin
											WB_DATA_O = {gntn_cnt,reqn_cnt};
										end
									5 : 
										begin
											WB_DATA_O = {par_cnt,perrn_cnt};
										end
									
								endcase
								WB_VALID_O = 1;
							end
						else
							begin
								case (WB_ADD_I[11:2])
									0 : // dbg_ctr
										begin
											dbg_ctr = WB_DATA_I;
										end
									
								endcase
								WB_ACK_O = 1;
							end
					end
				1 : ;
			endcase
		
	
			
		reg framen_cnt_stat = 0;
		always @(posedge PHY_CLK33_I)
			if(PHY_RSTn_I == 0)
				begin
					framen_cnt_stat = 0;
					framen_cnt = 0;
				end
			else if (dbg_ctr[0] == 1)
					framen_cnt = 0;
			else if (framen_cnt_stat == 0)
				begin
					if (DBG_PCI_FRAMEn_I == 1)
						begin
							framen_cnt_stat = 1;
						end
				end
			else if (framen_cnt_stat == 1)
				begin
					if (DBG_PCI_FRAMEn_I == 0)
						begin
							framen_cnt_stat = 0;
							framen_cnt = framen_cnt + 1;
						end
				end
				
		reg devseln_cnt_stat = 0;
		always @(posedge PHY_CLK33_I)
			if(PHY_RSTn_I == 0)
				begin
					devseln_cnt_stat = 0;
					devseln_cnt = 0;
				end
			else if (dbg_ctr[1] == 1)
					devseln_cnt = 0;
			else if (devseln_cnt_stat == 0)
				begin
					if (DBG_PCI_DEVSELn_I == 1)
						begin
							devseln_cnt_stat = 1;
						end
				end
			else if (devseln_cnt_stat == 1)
				begin
					if (DBG_PCI_DEVSELn_I == 0)
						begin
							devseln_cnt_stat = 0;
							devseln_cnt = devseln_cnt + 1;
						end
				end
			
			
			
				
		reg irdyn_cnt_stat = 0;
		always @(posedge PHY_CLK33_I)
			if(PHY_RSTn_I == 0)
				begin
					irdyn_cnt_stat = 0;
					irdyn_cnt = 0;
				end
			else if (dbg_ctr[2] == 1)
					irdyn_cnt = 0;
			else if (irdyn_cnt_stat == 0)
				begin
					if (DBG_PCI_IRDYn_I == 1)
						begin
							irdyn_cnt_stat = 1;
						end
				end
			else if (irdyn_cnt_stat == 1)
				begin
					if (DBG_PCI_IRDYn_I == 0)
						begin
							irdyn_cnt_stat = 0;
							irdyn_cnt = irdyn_cnt + 1;
						end
				end	
				
		
		reg trdyn_cnt_stat = 0;
		always @(posedge PHY_CLK33_I)
			if(PHY_RSTn_I == 0)
				begin
					trdyn_cnt_stat = 0;
					trdyn_cnt = 0;
				end
			else if (dbg_ctr[3] == 1)
					trdyn_cnt = 0;
			else if (trdyn_cnt_stat == 0)
				begin
					if (DBG_PCI_TRDYn_I == 1)
						begin
							trdyn_cnt_stat = 1;
						end
				end
			else if (trdyn_cnt_stat == 1)
				begin
					if (DBG_PCI_TRDYn_I == 0)
						begin
							trdyn_cnt_stat = 0;
							trdyn_cnt = trdyn_cnt + 1;
						end
				end	
				
			
				
		reg stopn_cnt_stat = 0;
		always @(posedge PHY_CLK33_I)
			if(PHY_RSTn_I == 0)
				begin
					stopn_cnt_stat = 0;
					stopn_cnt = 0;
				end
			else if (dbg_ctr[4] == 1)
					stopn_cnt = 0;
			else if (stopn_cnt_stat == 0)
				begin
					if (DBG_PCI_STOPn_I == 1)
						begin
							stopn_cnt_stat = 1;
						end
				end
			else if (stopn_cnt_stat == 1)
				begin
					if (DBG_PCI_STOPn_I == 0)
						begin
							stopn_cnt_stat = 0;
							stopn_cnt = stopn_cnt + 1;
						end
				end
				
				
				
		reg idsel_cnt_stat = 0;
		always @(posedge PHY_CLK33_I)
			if(PHY_RSTn_I == 0)
				begin
					idsel_cnt_stat = 0;
					idsel_cnt = 0;
				end
			else if (dbg_ctr[5] == 1)
					idsel_cnt = 0;
			else if (idsel_cnt_stat == 0)
				begin
					if (DBG_PCI_IDSEL_I == 1)
						begin
							idsel_cnt_stat = 1;
						end
				end
			else if (idsel_cnt_stat == 1)
				begin
					if (DBG_PCI_IDSEL_I == 0)
						begin
							idsel_cnt_stat = 0;
							idsel_cnt = idsel_cnt + 1;
						end
				end
			
			
		reg gntn_cnt_stat = 0;
		always @(posedge PHY_CLK33_I)
			if(PHY_RSTn_I == 0)
				begin
					gntn_cnt_stat = 0;
					gntn_cnt = 0;
				end
			else if (dbg_ctr[6] == 1)
					gntn_cnt = 0;
			else if (gntn_cnt_stat == 0)
				begin
					if (DBG_PCI_GNTn_I == 1)
						begin
							gntn_cnt_stat = 1;
						end
				end
			else if (gntn_cnt_stat == 1)
				begin
					if (DBG_PCI_GNTn_I == 0)
						begin
							gntn_cnt_stat = 0;
							gntn_cnt = gntn_cnt + 1;
						end
				end
				
				
		reg reqn_cnt_stat = 0;
		always @(posedge PHY_CLK33_I)
			if(PHY_RSTn_I == 0)
				begin
					reqn_cnt_stat = 0;
					reqn_cnt = 0;
				end
			else if (dbg_ctr[7] == 1)
					reqn_cnt = 0;
			else if (gntn_cnt_stat == 0)
				begin
					if (DBG_PCI_REQn_I == 1)
						begin
							reqn_cnt_stat = 1;
						end
				end
			else if (reqn_cnt_stat == 1)
				begin
					if (DBG_PCI_REQn_I == 0)
						begin
							reqn_cnt_stat = 0;
							reqn_cnt = reqn_cnt + 1;
						end
				end
				
				
		reg par_cnt_stat = 0;
		always @(posedge PHY_CLK33_I)
			if(PHY_RSTn_I == 0)
				begin
					par_cnt_stat = 0;
					par_cnt = 0;
				end
			else if (dbg_ctr[8] == 1)
					par_cnt = 0;
			else if (par_cnt_stat == 0)
				begin
					if (DBG_PCI_PAR_I == 1)
						begin
							par_cnt_stat = 1;
						end
				end
			else if (par_cnt_stat == 1)
				begin
					if (DBG_PCI_PAR_I == 0)
						begin
							par_cnt_stat = 0;
							par_cnt = par_cnt + 1;
						end
				end
				
		
		reg perrn_cnt_stat = 0;
		always @(posedge PHY_CLK33_I)
			if(PHY_RSTn_I == 0)
				begin
					perrn_cnt_stat = 0;
					perrn_cnt = 0;
				end
			else if (dbg_ctr[9] == 1)
					perrn_cnt = 0;
			else if (perrn_cnt_stat == 0)
				begin
					if (DBG_PCI_PERRn_I == 1)
						begin
							perrn_cnt_stat = 1;
						end
				end
			else if (perrn_cnt_stat == 1)
				begin
					if (DBG_PCI_PERRn_I == 0)
						begin
							perrn_cnt_stat = 0;
							perrn_cnt = perrn_cnt + 1;
						end
				end
			
			
		
				
		
		
	
endmodule
