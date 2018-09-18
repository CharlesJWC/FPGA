module Board_7segment_decoder
(
//input [13:0] sw,
input [9:0] sw,
output [6:0] segment_1000,
output [6:0] segment_100,
output [6:0] segment_10,
output [6:0] segment_1
);

wire [3:0] digit_1000;
wire [3:0] digit_100;
wire [3:0] digit_10;
wire [3:0] digit_1;

wire [9:0] mod_1000;
wire [6:0] mod_100;
wire [3:0] mod_10;


assign digit_1000 = sw/10'd1000;
assign mod_1000 = sw - (digit_1000*10'd1000);

assign digit_100 = mod_1000 / 7'd100;
assign mod_100 = mod_1000 - (digit_100*7'd100);

assign digit_10 = mod_100/4'd10;
assign mod_10 = mod_100 - (digit_10*4'd10);


assign digit_1 = mod_10;

bcd_7segment bcd_7segment_1000(digit_1000, segment_1000);
bcd_7segment bcd_7segment_100(digit_100, segment_100);
bcd_7segment bcd_7segment_10(digit_10, segment_10);
bcd_7segment bcd_7segment_1(digit_1, segment_1);

endmodule


/*
module Board_7segment_decoder
(
	//input [13:0] sw,
	input [9:0] sw,
	input [15:0] ram_read,
	input [2:0] ts,	// type select
	
	output [6:0] segment_1000,
	output [6:0] segment_100,
	output [6:0] segment_10,
	output [6:0] segment_1
);

reg [1:0] ALU_Mode_2;
reg [1:0] pre_ALU_Mode_2;
reg decpos;

wire [3:0] digit_1000;
wire [3:0] digit_100;
wire [3:0] digit_10;
wire [3:0] digit_1;

wire [13:0] mod_10000;
wire [13:0] mod_1000;
wire [9:0] mod_100;
wire [6:0] mod_10;
wire c_flag;


assign c_flag = (ts < 3'd3)? 1:0;

assign mod_10000 = (ts == 3'd6 && !decpos)? ram_read - (14'd1000*(ram_read/14'd1000)) : 14'bXXXXXXXXXXXXXX;	// R10^4 (Result - 16bit)

assign digit_1000 = 
			(ts == 3'd6)? (decpos)? ram_read/14'd10000 : mod_10000/10'd1000 :	// 10^4 : 10^3 (Result - 16bit)
			(ts == 3'd0)? 4'd1 : // I
			(ts == 3'd1)? 4'd2 : // d 
			(ts == 3'd2)? 4'd0 : // none
			(ts == 3'd3)? sw/10'd1000 :	// 10^3 (Input - 10bit)
			(ts == 3'd4)? sw[9:6]/4'd10 : // 10^1 (SAR1 - 4bit) 
			(ts == 3'd5)? sw[4:1]/4'd10 : // 10^1 (DAR  - 4bit)
			4'bXXXX;						 
assign mod_1000 = 
			(ts == 3'd6)? (decpos)? ram_read-digit_1000*14'd10000 : mod_10000-digit_1000*10'd1000 :	// R10^3 : R10^2 (Result - 16bit)
			(ts == 3'd3)? sw - (digit_1000*10'd1000) : // R10^2 (Input - 10bit)
			(ts == 3'd4)? sw[9:6]-(digit_1000*4'd10) : // R10^0 (SAR1 - 4bit)
			(ts == 3'd5)? sw[4:1]-(digit_1000*4'd10) : // R10^0 (DAR  - 4bit)
			14'bXXXXXXXXXXXXXX;


assign digit_100 = 
			(ts == 3'd6)? (decpos)? mod_1000/10'd1000 : mod_1000/7'd100 :	// 10^3 : 10^2 (Result - 16bit)
			(ts == 3'd0)? 4'd2 : // d
			(ts == 3'd1)? 4'd5 : // o
			(ts == 3'd2)? 4'd7 : // r
			(ts == 3'd3)? mod_1000 / 7'd100 : // 10^2 (Input - 10bit)
			(ts == 3'd4)? mod_1000 : // 10^0 (SAR1 - 4bit)
			(ts == 3'd5)? mod_1000 : // 10^0 (DAR  - 4bit)
			4'bXXXX;	
assign mod_100 = 
			(ts == 3'd6)? (decpos)? mod_1000-digit_100*10'd1000 : mod_1000-digit_100*7'd100 : // R10^2 : R10^1 (Result - 16bit)
			(ts == 3'd3)? mod_1000 - (digit_100*7'd100) : // R10^1 (Input - 10bit)
			10'bXXXXXXXXXX;


assign digit_10 = 
			(ts == 3'd6)? (decpos)? mod_100/7'd100 : mod_100/4'd10 : // 10^2 : 10^1 (Result - 16bit)
			(ts == 3'd0)? 4'd3 : // l
			(ts == 3'd1)? 4'd6 : // n 
			(ts == 3'd2)? 4'd8 : // u
			(ts == 3'd3)? mod_100/4'd10 : // 10^1 (Input - 10bit)
			(ts == 3'd4)? sw[5:2]/4'd10 : // 10^1 (SAR2 - 4bit) 
			(ts == 3'd5)? {1'b0, sw[5], ALU_Mode_2} : // 10^0 (ALU_Mode - 3bit)
			4'bXXXX;			 
assign mod_10 =
			(ts == 3'd6)? (decpos)? mod_100-digit_10*7'd100 : mod_100-digit_10*4'd10 : // R10^1 : R10^0 (Result - 16bit)
			(ts == 3'd3)? mod_100 - (digit_10*4'd10) : // R10^0 (Input - 10bit)
			(ts == 3'd4)? sw[5:2] - (digit_10*4'd10) : // R10^0 (SAR2 - 4bit)
			7'bXXXXXXX;


assign digit_1 = 
			(ts == 3'd6)? (decpos)? mod_10/4'd10 : mod_10 : // 10^1 : 10^0 (Result - 16bit)
			(ts == 3'd0)? 4'd4 : // E
			(ts == 3'd1)? 4'd4 : // E 
			(ts == 3'd2)? 4'd8 : // n
			(ts == 3'd3)? mod_10 : // 10^0 (Input - 10bit)
			(ts == 3'd4)? mod_10 : // 10^0 (SAR2 - 4bit) 
			(ts == 3'd5)? {3'b000, sw[0]} : // 10^0 (Output_Mode - 1bit)
			4'bXXXX;								  
			
initial
begin
	ALU_Mode_2 = 2'd0;
	pre_ALU_Mode_2 = 2'd0;
	decpos = 1'd0;
end
			
always @(sw, ts, pre_ALU_Mode_2)
begin
	if(ts == 3'd4)
	begin
		ALU_Mode_2 = sw[1:0];
	end
	else ALU_Mode_2 = pre_ALU_Mode_2;
end			

always @(ALU_Mode_2)
begin
	pre_ALU_Mode_2 = ALU_Mode_2; 
end
			
bcd_7segment bcd_7segment_1000(digit_1000, segment_1000, c_flag);
bcd_7segment bcd_7segment_100(digit_100, segment_100, c_flag);
bcd_7segment bcd_7segment_10(digit_10, segment_10, c_flag);
bcd_7segment bcd_7segment_1(digit_1, segment_1, c_flag);

endmodule
*/