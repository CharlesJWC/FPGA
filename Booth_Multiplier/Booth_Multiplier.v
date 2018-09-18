`define MPNum 8
`define MPCNum 8
`define PDNum 15 //`MPNum+`MCNum-1

`define ACC_H RegACC[`ACCNum-1:`ACCNum-`MPCNum]
`define ACC_M RegACC[`MPNum-1:0]
`define M RegACC[0]
`define CMC RegMtc_C[`MPCNum-1]
`define B0 RegMtp_B[0]
`define B1 RegMtp_B[1]

module Booth_Multiplier
(
	input clk,
	input St,
	input[`MPNum-1:0] Mtc,
	input[`MPCNum-1:0] Mtp,
	output[`PDNum-1:0] Product,
	output reg Ready
);

parameter [1:0] S0 = 2'd0,
				S1 = 2'd1,
				S2 = 2'd2;

reg [1:0] state, nxt_state;
reg [`MPCNum:0] RegACC_A;
reg [`MPNum:0] RegMtp_B;
reg [`MPCNum-1:0] RegMtc_C;
reg Load, Sh, Add;


wire [`MPCNum:0] Addout;
wire [`MPCNum-1:0] MtcComp;
wire CMC, CNT, MAdd, K;


upcounter_3bits counter
(
	.clk(clk),
	.CNT(CNT),
	.K(K)
);

initial 
begin
	Load = 1'b0; 
	Sh = 1'b0;
	Add = 1'b0;
	
	state = S0;
	nxt_state = S0;
	
	RegACC_A = 0;
	RegMtp_B = 0;
	RegMtc_C = 0;
end

assign CNT = Sh;
assign MAdd = `B1 ^ `B0;
assign CMC = `B1 & !`B0;
assign MtcComp = (CMC)? (~RegMtc_C)+1'b1 : RegMtc_C;
assign Addout = RegACC_A + {MtcComp[`MPCNum-1], MtcComp};
assign Product = {RegACC_A[`MPCNum-2:0], RegMtp_B[`MPNum:1]};



always @(posedge clk)
begin

	state <= nxt_state;

	if(Load)
	begin
		RegACC_A <= 0;
		RegMtp_B <= {Mtp, 1'b0};
		RegMtc_C <= Mtc;
	end
	
	if(Add) RegACC_A <= Addout;

	if(Sh)
	begin
		RegACC_A <= {RegACC_A[`MPCNum], RegACC_A[`MPCNum:1]};
		RegMtp_B <= {RegACC_A[0], RegMtp_B[`MPCNum:1]};
	end
	
end



always @(state, St, MAdd, K)
begin
Load = 1'b0;
Sh = 1'b0;
Add = 1'b0;
Ready = 1'b0;

	case(state)

	S0: 
	begin
		Ready = 1'b1;
		if(St) 
		begin
			Load <= 1'b1;
			nxt_state <= S1;
		end	
		else nxt_state <= S0;
	end
	
	S1: 
	begin
		 
		if(MAdd) 
		begin
			Add = 1'b1;
			nxt_state <= S2;
		end
		else
		begin
			Sh = 1'b1;
			if(K) nxt_state <= S0;
			else nxt_state <= S1;	
		end
	end
	
	S2: 
	begin
		Sh = 1'b1;
		if(K) nxt_state <= S0;
		else nxt_state <= S1;
	end
		
	default: 
	begin
		nxt_state <= S0;
	end
	
	endcase
end

endmodule
