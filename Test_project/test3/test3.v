module test3
(
	input clk_50M,
	input rst_bar,
	input enter_bar,
	
	input [9:0] sw,
	
	output [6:0] segment_1000,
	output [6:0] segment_100,
	output [6:0] segment_10,
	output [6:0] segment_1,
	
	output [7:0] LEDG
);

wire [15:0] Disp_data;
wire rst, enter;
reg [2:0] ts;

assign rst = ~rst_bar;
assign enter = ~enter_bar;
assign Disp_data = {6'b000001, sw};


pro_7segment_decoder pro_7sd(clk_50M, rst , sw, Disp_data, ts, segment_1000, segment_100, segment_10, segment_1);

parameter	IdlE 	= 3'b000,
			donE 	= 3'b001,
			 run 	= 3'b010,
			SW_FULL = 3'b011,
			Src_Adr = 3'b100,
			Dst_Adr = 3'b101,
			Data_16 = 3'b110;

assign LEDG =	(sw[7] & sw[8] & sw[9])? 8'b10000000 :
				(sw[6])? 8'b01000000 :
				(sw[5])? 8'b00100000 :
				(sw[4])? 8'b00010000 :
				(sw[3])? 8'b00001000 :
				(sw[2])? 8'b00000100 :
				(sw[1])? 8'b00000010 :
				(sw[0])? 8'b00000001 :
				8'b00000000;

parameter	S1 = 3'b000,
			S2 = 3'b001,
			S3 = 3'b010,
			S4 = 2'b011,
			S5 = 3'b100,
			S6 = 3'b101,
			S7 = 3'b110;



reg [2:0] state, nxt_state;

initial
begin
	ts = IdlE;
	state = S1;
	nxt_state = S1;
end


always @(posedge clk_50M or posedge rst)
begin
	if(rst) state <= S1;
	else state <= nxt_state;
end


always @(posedge enter or posedge rst)
begin

	if(rst) 
	begin
		nxt_state = S1;
	end
	else
	begin
		case(state)
	
		S1 :
		begin
			if(enter) 
			begin
				nxt_state = S2;
			end
			else
			begin
				nxt_state = S1;
			end
		end
		
		S2 :
		begin
			if(enter) 
			begin
				nxt_state = S3;
			end
			else
			begin
				nxt_state <= S2;
			end
		end
	
		S3 :
		begin
			if(enter) 
			begin
				nxt_state <= S4;
			end
			else
			begin
				nxt_state = S3;
			end
		end
			
		S4 :
		begin
			if(enter) 
			begin
				nxt_state = S5;
			end
		else	
			begin
				nxt_state = S4;
			end	
		end	

		S5 :
		begin
			if(enter) 
			begin
				nxt_state = S6;
			end
			else
			begin
				nxt_state = S5;
			end
		end
	
		S6 :
		begin
			if(enter) 
			begin
				nxt_state = S7;
			end
			else
			begin
				nxt_state = S6;
			end
		end
		
		S7 :
		begin
			if(enter) 
			begin
				nxt_state = S1;
			end
			else
			begin
				nxt_state = S7;
			end
		end
		
		default : 
		begin
			nxt_state = S1;
		end
	
		endcase
	end
end

always @(state)
begin

	case(state)

	S1 :
	begin
		ts = IdlE;
		//LEDG = 8'b00000001;
	end

	S2 :
	begin
		ts = donE;
		//LEDG = 8'b00000010;
	end

	S3 :
	begin
		ts =  run;
		//LEDG = 8'b00000100;
	end
		
	S4 :
	begin
		ts = SW_FULL;
		//LEDG = 8'b00001000;
	end

	S5 :
	begin
		ts = Src_Adr;
		//LEDG = 8'b00010000;
	end

	S6 :
	begin
		ts = Dst_Adr;
		//LEDG = 8'b00100000;
	end
	
	S7 :
	begin
		ts = Data_16;
		//LEDG = 8'b00100000;
	end	
	
	default : 
	begin
		ts = IdlE;
	end

	endcase
end

endmodule 