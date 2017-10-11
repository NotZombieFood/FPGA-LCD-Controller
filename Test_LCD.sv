module Test_LCD;

	// Inputs
	logic clk;
	logic rst;

	// Outputs
	logic [7:0] LCD_DATA;
	logic LCD_RW;
	logic LCD_EN;
	logic LCD_RS;
	logic LCD_ON;
	

	// Instantiate the Unit Under Test (UUT)
	testLCDControlller uut (
		.clk(clk), 
		.rst(rst),
		.LCD_DATA(LCD_DATA),
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN),
		.LCD_RS(LCD_RS),
		.LCD_ON(LCD_ON)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		rst=1;
		#20;
		rst = 0;

	end
	
	initial forever #10 clk = ~clk;
      
endmodule

