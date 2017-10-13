module	LCD (	
					input clk,rst,
					output [7:0] DATA,
					output RW,EN,RS,ON);

//	Internals
logic	[5:0]	L_Addr;
logic	[8:0]	L_DATA;
logic	[17:0]	Delay;
logic			c_start;
logic	[7:0]	c_DATA;
logic			c_RS;
logic		c_Done;
logic rs_counter;
logic en_delay;
logic en_addr;
logic rs_addr;

//enum  { BEG, INIT, DLY, DONE } state;
//logic [1:0] state;
//logic [1:0] next_state;

enum {BEG, INIT, DLY, DONE} state, next_state;

// Parameters
parameter	INITIAL	=	0;
parameter	LINE1	=	5;
parameter	CH_LINE	=	LINE1+16;
parameter	LINE2	=	LINE1+16+1;
parameter	SIZE	=	LINE1+32+1;

//////////////////////////////////////////////////////////////////////////////////////////
//FSM

//Transicion de estado
always_ff @(posedge clk) begin
	if(~rst)
		state <= BEG;
	else
		state <= next_state;
end

//Cambio de estado
always_comb begin
	if (~rst)
		next_state = BEG;
	else if (L_Addr<SIZE) begin
		case (state)
			BEG: next_state = INIT;
			INIT: if (c_Done)
					next_state = DLY;
				else 
					next_state = INIT;
			DLY: if(Delay<18'h3FFFE)
					next_state = DLY;
				else
					next_state = DONE;
			DONE: next_state = BEG;
			default: next_state = BEG;
		endcase
	end
	else
		next_state = BEG;
end

//salidas

always_comb  begin
	if(~rst) begin
		c_start	<=	0;
		c_DATA	<=	0;
		c_RS		<=	0;
		rs_counter <= 1;
		rs_addr <= 1;
		en_delay <= 0;
		en_addr <= 0;
	end
	else if (L_Addr<SIZE) begin
		case (state)
		BEG:begin
			c_DATA	<=	L_DATA[7:0];
			c_RS		<=	L_DATA[8];
			c_start <=1;
			rs_counter <= 1;
			en_delay <= 0;
			en_addr <= 0;
			rs_addr <= 0;
		end
		INIT:begin
			c_start <=0;
			c_DATA	<=	L_DATA[7:0];
			c_RS		<=	L_DATA[8];
			rs_counter <= 0;
			en_delay <= 0;
			en_addr <= 0;
			rs_addr <= 0;
		end
		DLY:begin
			c_start <=0;
			c_DATA	<=	L_DATA[7:0];
			c_RS		<=	L_DATA[8];
			rs_counter <= 0;
			en_delay <= 1;
			en_addr <= 0;
			rs_addr <= 0;
		end
		DONE:begin
			c_start <=0;
			c_DATA	<=	L_DATA[7:0];
			c_RS		<=	L_DATA[8];
			rs_counter <= 1;
			en_delay <= 0;
			en_addr <= 1;
			rs_addr <= 0;
		end
		default: begin
			c_start	<=	0;
			c_DATA	<=	0;
			c_RS		<=	0;
			rs_addr <= 0;
			en_addr <= 0;
			rs_counter <= 0;
			en_delay <= 0;
		end
		endcase
	end
	else begin
		c_start	<=	0;
		c_DATA	<=	0;
		c_RS		<=	0;
		rs_addr <= 0;
		en_addr <= 0;
		rs_counter <= 0;
		en_delay <= 0;
	end
end


///////////////////////////////////////////////////////////////////////////////////////////////

//counter addr
always @(posedge clk) begin
	if (rs_addr)
		L_Addr <= 0;
	else if (en_addr)
		L_Addr <= L_Addr + 1;
	else
		L_Addr <= L_Addr;
end




//counter delay
always @(posedge clk) begin
	if (rs_counter)
		Delay <= 0;
	else if (en_delay)
		Delay <= Delay+1;
	else
		Delay <= Delay;
end



always_comb begin
	case(L_Addr)
	//	Initial
	INITIAL+0:	L_DATA	<=	9'h038;
	INITIAL+1:	L_DATA	<=	9'h00C;
	INITIAL+2:	L_DATA	<=	9'h001;
	INITIAL+3:	L_DATA	<=	9'h006;
	INITIAL+4:	L_DATA	<=	9'h080;
	//	Line 1
	LINE1+0:	L_DATA	<=	9'h120;	//	Welcome to the
	LINE1+1:	L_DATA	<=	9'h148;
	LINE1+2:	L_DATA	<=	9'h145;
	LINE1+3:	L_DATA	<=	9'h14C;
	LINE1+4:	L_DATA	<=	9'h14C;
	LINE1+5:	L_DATA	<=	9'h14F;
	LINE1+6:	L_DATA	<=	9'h120;
	LINE1+7:	L_DATA	<=	9'h120;
	LINE1+8:	L_DATA	<=	9'h120;
	LINE1+9:	L_DATA	<=	9'h120;
	LINE1+10:	L_DATA	<=	9'h120;
	LINE1+11:	L_DATA	<=	9'h120;
	LINE1+12:	L_DATA	<=	9'h120;
	LINE1+13:	L_DATA	<=	9'h120;
	LINE1+14:	L_DATA	<=	9'h120;
	LINE1+15:	L_DATA	<=	9'h120;
	//	Change Line
	CH_LINE:	L_DATA	<=	9'h0C0;
	//	Line 2
	LINE2+0:	L_DATA	<=	9'h120;	//	Terasic DE2i-150 T
	LINE2+1:	L_DATA	<=	9'h157;	// e
	LINE2+2:	L_DATA	<=	9'h14F;  // r
	LINE2+3:	L_DATA	<=	9'h152;  // a
	LINE2+4:	L_DATA	<=	9'h14C;  // s
	LINE2+5:	L_DATA	<=	9'h144;  // i
	LINE2+6:	L_DATA	<=	9'h120;  // c
	LINE2+7:	L_DATA	<=	9'h120;  // 
	LINE2+8:	L_DATA	<=	9'h120;  // D
	LINE2+9:	L_DATA	<=	9'h120;  // E
	LINE2+10:	L_DATA	<=	9'h120;  // 2
	LINE2+11:	L_DATA	<=	9'h120;  // i
	LINE2+12:	L_DATA	<=	9'h120;  // -
	LINE2+13:	L_DATA	<=	9'h120;  // 1
	LINE2+14:	L_DATA	<=	9'h120;  // 5
	LINE2+15:	L_DATA	<=	9'h120;  // 0
	default:		L_DATA	<=	9'h120;
	endcase
end

LCD_Controller 		u0	(
							.DATA(c_DATA),
							.iRS(c_RS),
							.LCD_start(c_start),
							.LCD_DONE(c_Done),
							.clk(clk),
							.reset(~rst),
							.LCD_DATA(DATA),
							.LCD_RW(RW),
							.LCD_EN(EN),
							.LCD_RS(RS),
							.LCD_ON(ON));

endmodule