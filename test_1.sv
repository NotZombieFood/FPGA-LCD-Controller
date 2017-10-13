module test_1;

	// Inputs
	logic clk;
	logic rst;

	// Outputs
	 logic [7:0] DATA;
	 logic RW;
	 logic EN;
	 logic RS;
	 logic ON;

	// Instantiate the Unit Under Test (UUT)
	MIPS uut (
		.clk(clk),
		.rst(rst),
		.DATA(DATA),
		.RW(RW),
		.EN(EN),
		.RS(RS),
		.ON(ON)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
		
		rst= 1;
		#200;
		rst= 0;
		#200;
		rst = 1;
        
		// Add stimulus here

	end
	
	initial forever #10 clk = ~clk;
      
endmodule