module test2
(
	input clk_50M,
	input rst_bar,
	input enter_bar,
	input[9:0] sw,
	
	output [6:0] seg_1000,
	output [6:0] seg_100,
	output [6:0] seg_10,
	output [6:0] seg_1,
	
	output [7:0] LEDG
);

parameter [2:0] S0 = 3'd0,	// Mode1 IDLE
				S1 = 3'd1,	// Mode2 DATA SAVE (1) 
				S2 = 3'd2,	// Mode2 DATA SAVE (2) 
				S3 = 3'd3, // Mode3 DATA READ (1) 
				S4 = 3'd4,
				S5 = 3'd5,
				S6 = 3'd6,
				S7 = 3'd7;	// Mode3 DATA READ (2) 

reg [2:0] state, nxt_state;
reg [7:0] LEDGs;

wire rst;
wire enter;

//reg nul,tae;
// wire enG;

assign rst = ~rst_bar;
assign enter = ~enter_bar;
assign LEDG = LEDGs;

Board_7segment_decoder MJ_7Segment(sw, seg_1000,seg_100,seg_10,seg_1);

initial
begin
	state = S0;
	nxt_state = S0;
	LEDGs = 8'b00000000;
end

/*
always @(posedge enter_bar)
begin
	tae <= 1'b1;
	nul <= 1'b0;
end

always @(negedge enter_bar)
begin
	nul <= 1'b1; 
end

always @(posedge enG)
begin
	tae <= 1'b0;
end


always @(posedge clk_50M or posedge rst)
begin
	if(rst) LEDG_Reg <= 8'b00000000;
	else 
	begin
		if(enG) LEDG_Reg <= LEDG_Reg + 1;
		else LEDG_Reg <= LEDG_Reg;
	end
end
*/

always @(posedge clk_50M or posedge rst)
begin 
	if(rst) state <= S0;
	else 	state <= nxt_state;
end



always @(state, enter)
begin
LEDGs = 8'd0;

	case(state)

	S0 :
	begin
		LEDGs = 8'b10101010;
		if(enter) 
		begin
			nxt_state = S1;
		end
		else 
		begin
			nxt_state = S0;
		end
	end

	S1 :
	begin
		LEDGs = 8'b01010101;
		if(enter) 
		begin
			nxt_state = S0;
		end
		else 
		begin
			nxt_state = S1;
		end
	end
	
	default :
	begin
		nxt_state = S0;
	end
	
	endcase
/*
LEDG = 8'b00000000;

	case(state)
	
	S0 :
	begin
		LEDG = 8'b00000001;
		if(enter) nxt_state = S1;
		else nxt_state = S0;
	end
	
	S1 :
	begin
		LEDG = 8'b00000010;
		if(enter) nxt_state = S2;
		else nxt_state = S1;
	end
	
	S2 :
	begin
		LEDG = 8'b00000100;
		if(enter) nxt_state = S3;
		else nxt_state = S2;
	end

	S3 :
	begin
		LEDG = 8'b00001000;
		if(enter) nxt_state = S4;
		else nxt_state = S3;
	end

	S4 :
	begin
		LEDG = 8'b00010000;
		if(enter) nxt_state = S5;
		else nxt_state = S4;
	end

	S5 :
	begin
		LEDG = 8'b00100000;
		if(enter) nxt_state = S6;
		else nxt_state = S5;
	end
	
	S6 :
	begin
		LEDG = 8'b01000000;
		if(enter) nxt_state = S7;
		else nxt_state = S6;
	end

	S7 :
	begin
		LEDG = 8'b10000000;
		if(enter) nxt_state = S1;
		else nxt_state = S0;
	end
	
	endcase
*/
end

endmodule 