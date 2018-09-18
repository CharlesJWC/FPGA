`timescale 1ns / 1ps

module floating_point_Adder
(
	input CLK, St,
	input [4:0] F1, F2,
	input [3:0] E1, E2,
	output Fnorm,
	output reg V, Done
);

reg [5:0] RegF1;
reg [4:0] RegF2;
reg [4:0] RegE1;
reg [3:0] RegE2;

wire [5:0] addout;
wire [4:0] subout;

reg Load, Ad, LM8, RSX1, LS, RSX2, INC1, INC2, DEC1, LdTwoToOne;
wire LT, GT, E1G, E2G, EV, SubV;
wire FZero, FV;

reg [1:0] state, nextstate;

initial 
begin
	V = 0;
	Done = 0;
	RegF1 = 0;
	RegF2 = 0;
	RegE1 = 0;
	RegE2 = 0;
	Load = 0;
	Ad = 0;
	LM8 = 0;
	RSX1 = 0;
	LS = 0;
	RSX2 = 0;
	INC1 = 0;
	INC2 = 0;
	DEC1 = 0;
	LdTwoToOne = 0;
	
	state = 0;
	nextstate = 0;
end

assign subout = RegE1 - {RegE2[3], RegE2};
assign addout = RegF1 + {RegF2[4], RegF2};

assign SubV = (subout[4] != subout[3])? 1 : 0;
assign EV = (RegE1[4] != RegE1[3])? 1 : 0;

assign LT = subout[3];
assign GT = (subout[3] == 0 && subout[3:0] != 3'b000)? 1 : 0;

assign E1G = ((SubV == 0 && subout[3] == 0 && subout[2] == 1 &&(~(subout[1:0])==2'b00))
||(SubV == 1 && RegE1[3] == 0 && RegE2[3] == 1))? 1 : 0;
assign E2G = ((SubV == 0 && subout[3] == 1 && subout[2] == 0) 
||(SubV == 1 && RegE1[3] == 1 && RegE2[3] == 0))? 1 : 0;

assign FZero = (RegF1 == 0)? 1 : 0;

assign FV = (RegF1[5] != RegF1[4])? 1 : 0;
assign Fnorm = (RegF1[4] != RegF1[3])? 1 : 0;

always @(state, St, LT, GT, E1G, E2G, FZero, FV, Fnorm, EV)
begin

Load = 0; Ad = 0; LM8 = 0; RSX1 = 0; LS = 0; V = 0;
RSX2 = 0; INC1 = 0; INC2 = 0; DEC1 = 0; Done = 0;
LdTwoToOne = 0;
	case(state)

	0: 
	begin
		if(St == 1) 
		begin
			Load = 1;
			nextstate = 1;
		end
		else 
		begin
			nextstate = 0;
		end
	end

	1: 
	begin
		if(E1G == 1) 
		begin
			nextstate = 3;
		end
		else if(E2G == 1) 
		begin
			LdTwoToOne = 1;
			nextstate = 3;
		end
		else if(GT == 1) 
		begin
			RSX2 = 1;
			INC2 = 1;
			nextstate = 1;
		end
		else if(LT == 1) 
		begin	
			RSX1 = 1;
			INC1 = 1;
			nextstate = 1;
		end
		else 
		begin
			Ad = 1;
			nextstate = 2;
		end
	end

	2: 
	begin
		if(FZero == 1) 
		begin
			LM8 = 1;	
			nextstate = 3;
		end
		else if(FV == 1) 
		begin
			RSX1 = 1;
			INC1 = 1;
			nextstate = 3;
		end
		else if(Fnorm == 0) 
		begin
			LS = 1;
			DEC1 = 1;
			nextstate = 2;
		end	
		else 
		begin
			nextstate = 3;
		end
	end

	3: 
	begin
		Done =1 ;
		
		if(St == 0) nextstate = 0;	
		else nextstate = 3;
		
		if(EV == 1) V = 1;
	end
	endcase
end

always @(posedge CLK)
begin
	state <= nextstate;
	if(Load == 1) 
	begin
		RegF1 <= {F1[4],F1};
		RegF2 <= F2;
		RegE1 <= {E1[3],E1};
		RegE2 <= E2;
	end
	else 
	begin

	//RegE1 
	if(LM8 == 1)
		RegE1 <= 5'b11000;

	if(LdTwoToOne == 1) 
	begin
		RegE1 <= {RegE2[3], RegE2};
		RegF1 <= {RegF2[4], RegF2};
	end

	if(INC1 == 1)
		RegE1 <= RegE1 + 1;
	else if(DEC1 == 1)
		RegE1 <= RegE1 - 1;
		
	//RegE2
	if(INC2 == 1)
		RegE2 <= RegE2 + 1;
	//REGF1
	if(LS == 1)
		RegF1 <= {RegF1[4:0], 1'b0};
	else if(RSX1 == 1)
		RegF1 <= {RegF1[5], RegF1[5:1]};
	else if(Ad == 1)
		RegF1 <= addout;
	//RegF2
	if(RSX2 == 1)
		RegF2 <= {RegF2[4], RegF2[4:1]};
	end
end

endmodule
