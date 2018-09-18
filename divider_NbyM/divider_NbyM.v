`define DVendNum 16
`define DVsorNum 8
`define QuotNum 8 //`DVendNum-`DVsorNum
`define RemnNum 8 // DVsorNum
`define ACCNum 17//`DVendNum+1

`define ACC_R RegACC[`DVendNum-1:`DVendNum-`RemnNum] //`DVendNum
`define ACC_Q RegACC[`QuotNum-1:0] // `DVendNum-`DVsorNum
`define C SubComp[`DVsorNum+1]

module divider_NbyM
(
	input clk,
	input St,
	input [`DVendNum-1:0] Dividend_in,
	input [`DVsorNum-1:0] Divisor_in,
	output [`QuotNum-1:0] Quotient,
	output [`RemnNum-1:0] Remainder,
	output reg V,
	output reg Ready
);

parameter [1:0] S0 = 2'd0,
				S1 = 2'd1,
				S2 = 2'd2;

reg [1:0] state, nxt_state;
reg [`ACCNum-1:0] RegACC;
reg [`DVsorNum-1:0] RegDVsor;
reg SuSh, Sh, Su, Load;

wire CNT;
wire K;
//wire [`DVsorNum-1:0] Subin;
wire [`DVsorNum-1:0] Subout;
wire [`DVsorNum+1:0] SubComp;

upcounter_4bits counter
(
	.clk(clk),
	.CNT(CNT),
	.K(K)
);


initial
begin
	state = S0;
	nxt_state = S0;
	RegACC = 0;
	RegDVsor = 0;
	Load = 1'b0;
	V = 1'b0;
	SuSh = 1'b0;
	Sh = 1'b0;
	Su = 1'b0;
	Ready = 1'b0;
end

assign Quotient = `ACC_Q;
assign Remainder = `ACC_R;
assign SubComp = {1'b1,RegACC[`ACCNum-1:`ACCNum-`RemnNum-1]} - {2'b00,RegDVsor};
assign Subout = SubComp[`DVsorNum-1:0];
assign CNT = SuSh | Sh | Su;

always @(posedge clk)
begin

	state <= nxt_state;

	if(Load)
	begin
		RegACC <= {1'b0,Dividend_in};
		RegDVsor <= Divisor_in;
	end
	
	if(Su)
	begin
		RegACC[`ACCNum-1:`ACCNum-`RemnNum-1] <= {1'b0, Subout};
		`ACC_Q <= {RegACC[`QuotNum-2:0],1'b1};
	end
	
	if(Sh)
	begin
		RegACC <= {RegACC[`ACCNum-2:0],1'b0};
	end
	
	if(SuSh)
	begin
		RegACC[`ACCNum-1:`ACCNum-`RemnNum] <= Subout;
		RegACC[`QuotNum:0] <= {`ACC_Q,1'b1};
	end

end

always @(state, St, `C, K)
begin
	Load = 1'b0;
	V = 1'b0;
	Sh = 1'b0;
	Su = 1'b0;
	SuSh = 1'b0;
	Ready = 1'b0;
	
	case (state)
	
		S0: 
		begin
			Ready <= 1'b1;
			if(St)
			begin
				Load <= 1'b1;
				nxt_state <= S1;
			end
			else nxt_state <= S0;
		end		
		
		S1:
		begin
			if (`C) 
			begin
				V <= 1'b1;
				nxt_state <= S0;
			end
			else
			begin
				Sh <= 1'b1;
				nxt_state <= S2;
			end
		end
		
		S2:
		begin
			if(K)
			begin
				if(`C) Su <= 1'b1;
				else Sh <= 1'b1;
				nxt_state <= S0;
			end
			else
			begin
				if(`C)
				begin 
					SuSh <= 1'b1;
					nxt_state <= S2;
				end
				else
				begin
					Sh <= 1'b1;
					nxt_state <= S2;
				end
			end
		end
		
		default:
		begin
			nxt_state <= S0;
		end	
	endcase
end
	
endmodule		





