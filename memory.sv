module memory 
#(
  parameter NUM_REGS = 64, 
  parameter SIZE = 32
)(
  input clk,
  input rst,
  input  [5:0]  wr_addr,
  input         wr_en,
  input  [31:0] wr_data,
  input  [5:0]  rd_addr,
  output [31:0] rd_data
);
  
    logic [SIZE-1:0] rf [NUM_REGS-1:0];
  
    integer i;
	 always_ff @ (posedge clk) begin
      if (rst)
			for (i = 0; i < NUM_REGS-1; i = i + 1)
				rf[i] <= 0;
		else if (wr_en) 
        rf[wr_addr] <= wr_data;
		else begin
			rf[0] = 9'h038;
			rf[1] = 9'h00C;
			rf[2] = 9'h001;
			rf[3] = 9'h006;
			rf[4] = 9'h080;
			rf[5] = 9'h120;
			rf[6] = 9'h148;
			rf[7] = 9'h145;
			rf[8] = 9'h14C;
			rf[9] = 9'h14C;
			rf[10] = 9'h14F;
			rf[11] = 9'h120;
			rf[12] = 9'h120;
			rf[13] = 9'h120;
			rf[14] = 9'h120;
			rf[15] = 9'h120;
			rf[16] = 9'h120;
			rf[17] = 9'h120;
			rf[18] = 9'h120;
			rf[19] = 9'h120;
			rf[20] = 9'h120;
			rf[21] = 9'h0C0;
			rf[22] = 9'h120;
			rf[23] = 9'h120;
			rf[24] = 9'h120;
			rf[25] = 9'h120;
			rf[26] = 9'h120;
			rf[27] = 9'h120;
			rf[28] = 9'h120;
			rf[29] = 9'h120;
			rf[30] = 9'h120;
			rf[31] = 9'h120;
			rf[32] = 9'h120;
			rf[33] = 9'h120;
			rf[34] = 9'h120;
			rf[35] = 9'h120;
			rf[36] = 9'h120;
			rf[37] = 9'h120;
			rf[38] = 9'h120;
			rf[39] = 9'h120;
		end
	end
	

    assign rd_data = rf[rd_addr];

endmodule