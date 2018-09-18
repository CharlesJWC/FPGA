`timescale 1ns / 1ps

`define F2GTF1 CompareResult[7]

module floating_point_Divider
(
	input CLK, St,
	input [7:0] F1, F2,
	input [4:0] E1, E2,
	output [7:0] Fout,
	output [4:0] Eout,
	output reg V, Done
);

reg [7:0] RegF1;
reg [7:0] RegF2;
reg [5:0] RegE1;
reg [4:0] RegE2;

wire [5:0] Subout;
wire [7:0] CompF1, ToCompF1, ToCompF2, CompareResult;

reg Load, StD, RSF, LSF, Store;
wire Cm, EV, F1Z, F2Z, Fnorm;

reg [2:0] state, nextstate;
wire [7:0] dividerResult;
wire DivDone;

initial 
begin
	V = 0;
	Done = 0;
	RegF1 = 0;
	RegF2 = 0;
	RegE1 = 0;
	RegE2 = 0;
	Load = 0;
	StD = 0;
	RSF = 0;
	LSF = 0;
	Store = 0;

	state = 0;
	nextstate = 0;
end

Divider fdivider
(
	.CLK(CLK), 
	.St(StD), 
	.dividend(RegF1), 
	.divisor(RegF2), 
	.dividerResult(), 
	.Done(DivDone)
);

assign CompF1 = ~(RegF1) + 1;
assign ToCompF1 = (RegF1[7] == 0)? RegF1 : CompF1;
assign ToCompF2 = (RegF2[7] == 1)? RegF2 : ~RegF2;
assign Cm = !RegF2[7];
assign CompareResult = ToCompF1 + ToCompF2 + {7'b0000000, Cm};
assign Subout = RegE1 - {RegE2[4], RegE2};
assign Fout = RegF1;
assign Eout = RegE1[4:0];
assign EV = (RegE1[5] != RegE1[4])? 1 : 0;
assign F1Z = (RegF1[7:5] == 0)? 1 : 0;
assign F2Z = (RegF2[7:6] == 0)? 1 : 0;
assign Fnorm = (RegF1[7] != RegF1[6])? 1 : 0;

always @(state, St, F1Z, F2Z, `F2GTF1, Fnorm, EV, DivDone)
begin
Load = 0; RSF = 0; LSF = 0; V = 0;
Done = 0; StD = 0; Store = 0;
	
	case(state)

	0: 
	begin
		if(St == 1) 
		begin
			Load = 1;
			nextstate = 1;
		end
		else nextstate = 0;
	end

	1: 
	begin
		if(F1Z == 1'b1 || F2Z == 1'b1) nextstate = 4;
		else if(`F2GTF1 == 0) 
		begin
			RSF = 1;
			nextstate = 1;
		end
		else 
		begin
			StD = 1;
			nextstate = 2;
		end
	end

	2: 
	begin
		if(DivDone == 1) 
		begin
			Store = 1;
			nextstate = 3;
		end
		else nextstate = 2;
	end
	
	3: 
	begin
		if(Fnorm == 1) nextstate = 4;
		else 
		begin
			LSF = 1;
			nextstate = 3;
		end
	end
	
	4: 
	begin
		Done = 1'b1;
		if(EV == 1 || F2Z == 1) V = 1;
		if(St == 0) nextstate = 0;
		else nextstate = 4;
	end
	
	endcase
end

always @(posedge CLK)
begin
	state <= nextstate;
	
	if(Load == 1) 
	begin
		RegF1 <= F1;
		RegF2 <= F2;
		RegE1 <= {E1[4], E1};
		RegE2 <= E2;
	end
	
	if(LSF == 1) 
	begin
		RegF1 <= {RegF1[6:0], 1'b0};
		RegE1 <= RegE1 - 1;
	end
	
	if(RSF == 1) 
	begin
		RegF1 <= {RegF1[7], RegF1[7:1]};
		RegE1 <= RegE1 + 1;
	end

	if(StD == 1) RegE1 <= Subout;
	if(Store == 1) RegF1 <= dividerResult;
end

endmodule
