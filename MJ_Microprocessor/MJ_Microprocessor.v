module MJ_Microprocessor
(
	input clk_50M,
	input rst_bar,
	input enter_bar,
	input[9:0] sw,
	
	output [6:0] seg_1000,
	output [6:0] seg_100,
	output [6:0] seg_10,
	output [6:0] seg_1,
	
	output reg [7:0] LEDG
);

parameter [2:0] S1 = 3'd0,	// Mode1 IDLE
				S21 = 3'd1,	// Mode2 DATA SAVE (1) 
				S22 = 3'd2,	// Mode2 DATA SAVE (2) 
				S31 = 3'd3, // Mode3 DATA READ (1) 
				S32 = 3'd4;	// Mode3 DATA READ (2) 
//				S41
//				S42
//				S51
//				S52

reg [2:0] ts;
reg [15:0] ram_read;
reg [2:0] state, nxt_state;

wire rst, enter;

assign rst = ~rst_bar;
assign enter = ~enter_bar;

Board_7segment_decoder MJ_7segdecoder(sw, ram_read, ts, seg_1000,seg_100,seg_10,seg_1);

initial
begin
	state = S1;
	nxt_state = S1;
	LEDG = 8'b11111111;
	ts = 3'd0;
	ram_read = 16'd0;
end
/*
always @(posedge clk_50M or posedge rst)
begin 
	if(rst) state <= S1;
	else 	state <= nxt_state;
end

always @(state, sw, enter)
begin
LEDG = 8'd0;
ts = 3'd0;
ram_read = 16'd0;
	
	case(state)
	
	S1 :	// Mode1 : Idle 
	begin 
		LEDG[0] = 1'b1;
		ts = 3'd0;
		if(sw[2:0] == 3'd2 && enter) nxt_state = S21;
		else if(sw[2:0] == 3'd3 && enter) nxt_state = S31;
		else nxt_state = S1;
	end
	
	S21 : 
	begin 
		LEDG[1] = 1'b1;
		ts = 3'd3;
		if(enter) nxt_state = S22;
		else      nxt_state = S21;
	end

	S22 :
	begin 
		LEDG[2] = 1'b1;
		ts = 3'd3;
		if(enter) nxt_state = S1;
		else      nxt_state = S22;
	end
	
	S31 :
	begin 
		LEDG[3] = 1'b1;
		ts = 3'd3;
		if(enter) nxt_state = S32;
		else      nxt_state = S31;
	end
	
	S32 :
	begin 
		LEDG[4] = 1'b1;
		ts = 3'd6;
		ram_read = 16'd7777; 
		if(enter) nxt_state = S1;
		else      nxt_state = S32;
	end

	default :
	begin
		nxt_state = S1;
	end

	endcase
end
*/

endmodule
