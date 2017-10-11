module	LCD_TEST (	
					input clk,rst,
					output [7:0] LCD_DATA,
					output LCD_RW,LCD_EN,LCD_RS,LCD_ON);

//	Internals
logic	[5:0]	LUT_INDEX;
logic	[8:0]	LUT_DATA;
logic	[5:0]	mLCD_ST;
logic	[17:0]	mDLY;
logic			mLCD_Start;
logic	[7:0]	mLCD_DATA;
logic			mLCD_RS;
logic		mLCD_Done;

// Parameters
parameter	LCD_INTIAL	=	0;
parameter	LCD_LINE1	=	5;
parameter	LCD_CH_LINE	=	LCD_LINE1+16;
parameter	LCD_LINE2	=	LCD_LINE1+16+1;
parameter	LUT_SIZE	=	LCD_LINE1+32+1;

always_ff @(posedge clk) begin
	if(~rst)
	begin
		LUT_INDEX	<=	0;
		mLCD_ST		<=	0;
		mDLY		<=	0;
		mLCD_Start	<=	0;
		mLCD_DATA	<=	0;
		mLCD_RS		<=	0;
	end
	else
	begin
		if(LUT_INDEX<LUT_SIZE)
		begin
			case(mLCD_ST)
			0:	begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_ST		<=	1;
				end
			1:	begin
					if(mLCD_Done)
					begin
						mLCD_ST		<=	2;					
					end
				end
			2:	begin
					if(mDLY<18'h3FFFE)
					mDLY	<=	mDLY+1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	3;
					end
				end
			3:	begin
					LUT_INDEX	<=	LUT_INDEX+1;
					mLCD_ST	<=	0;
				end
			endcase
		end
	end
end

always_comb begin
	case(LUT_INDEX)
	//	Initial
	LCD_INTIAL+0:	LUT_DATA	<=	9'h038;
	LCD_INTIAL+1:	LUT_DATA	<=	9'h00C;
	LCD_INTIAL+2:	LUT_DATA	<=	9'h001;
	LCD_INTIAL+3:	LUT_DATA	<=	9'h006;
	LCD_INTIAL+4:	LUT_DATA	<=	9'h080;
	//	Line 1
	LCD_LINE1+0:	LUT_DATA	<=	9'h120;	//	Welcome to the
	LCD_LINE1+1:	LUT_DATA	<=	9'h157;
	LCD_LINE1+2:	LUT_DATA	<=	9'h165;
	LCD_LINE1+3:	LUT_DATA	<=	9'h16C;
	LCD_LINE1+4:	LUT_DATA	<=	9'h163;
	LCD_LINE1+5:	LUT_DATA	<=	9'h16F;
	LCD_LINE1+6:	LUT_DATA	<=	9'h16D;
	LCD_LINE1+7:	LUT_DATA	<=	9'h165;
	LCD_LINE1+8:	LUT_DATA	<=	9'h120;
	LCD_LINE1+9:	LUT_DATA	<=	9'h174;
	LCD_LINE1+10:	LUT_DATA	<=	9'h16F;
	LCD_LINE1+11:	LUT_DATA	<=	9'h120;
	LCD_LINE1+12:	LUT_DATA	<=	9'h174;
	LCD_LINE1+13:	LUT_DATA	<=	9'h168;
	LCD_LINE1+14:	LUT_DATA	<=	9'h165;
	LCD_LINE1+15:	LUT_DATA	<=	9'h120;
	//	Change Line
	LCD_CH_LINE:	LUT_DATA	<=	9'h0C0;
	//	Line 2
	LCD_LINE2+0:	LUT_DATA	<=	9'h154;	//	Terasic DE2i-150 T
	LCD_LINE2+1:	LUT_DATA	<=	9'h165;	// e
	LCD_LINE2+2:	LUT_DATA	<=	9'h172;  // r
	LCD_LINE2+3:	LUT_DATA	<=	9'h161;  // a
	LCD_LINE2+4:	LUT_DATA	<=	9'h173;  // s
	LCD_LINE2+5:	LUT_DATA	<=	9'h169;  // i
	LCD_LINE2+6:	LUT_DATA	<=	9'h163;  // c
	LCD_LINE2+7:	LUT_DATA	<=	9'h120;  // 
	LCD_LINE2+8:	LUT_DATA	<=	9'h144;  // D
	LCD_LINE2+9:	LUT_DATA	<=	9'h145;  // E
	LCD_LINE2+10:	LUT_DATA	<=	9'h132;  // 2
	LCD_LINE2+11:	LUT_DATA	<=	9'h169;  // i
	LCD_LINE2+12:	LUT_DATA	<=	9'h1B0;  // -
	LCD_LINE2+13:	LUT_DATA	<=	9'h131;  // 1
	LCD_LINE2+14:	LUT_DATA	<=	9'h135;  // 5
	LCD_LINE2+15:	LUT_DATA	<=	9'h130;  // 0
	default:		LUT_DATA	<=	9'h120;
	endcase
end

LCD_Controller 		u0	(
							.DATA(mLCD_DATA),
							.iRS(mLCD_RS),
							.LCD_DONE(mLCD_Done),
							.clk(clk),
							.reset(~rst),
							.LCD_DATA(LCD_DATA),
							.LCD_RW(LCD_RW),
							.LCD_EN(LCD_EN),
							.LCD_RS(LCD_RS),
							.LCD_ON(LCD_ON));

endmodule