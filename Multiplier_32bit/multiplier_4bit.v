`define ACC_H ACC[7:4]
`define ACC_M ACC[3:0]
`define M ACC[0]
`define CM MP[15]
`define CMC MPC[15]

module multiplier_4bit
(
	input clk,
	input St,
	input Mtp,
	input Mtc,
	output Done,
	output Product
)

parameter [1:0] S0 = 2'd0,
				S1 = 2'd1,
				S2 = 2'd2,
				S3 = 2'd3;
				
input clk,St;
input [3:0] Mtp, Mtc;
output reg Done;
output [7:0] Product;

reg [1:0] state, nxt_state;
reg [7:0] ACC;
reg [3:0] RegMtp;
reg [3:0] RegMtc;
reg Sh, AddSh;
reg Load, CNT, CP;

wire Pneg;
wire K;
wire [3:0] Addin;
wire [4:0] Addout;

initial
begin
state = 2'd0;
nxt_state = 2'd0;

ACC = 8'd0;
RegMtp = 4'd0;
RegMtc = 4'd0;

Sh = 1'd0;
AddSh = 1'd0;
Load = 1'd0;
CNT = 1'd0;
CP = 1'd0;
Done = 1'd0;
end

always @(posedge clk)
begin 
	state <= nxt_state;
end


always @(state, St, K, M, Pneg)

begin

Load = 0; CoM = 0; AdSh = 0; Sh = 0;

Cnt = 0; CoP = 0; Done = 0;

case(state)

0: begin

if(St == 1) begin

Load = 1;

nextstate = 1;

end

else begin

nextstate = 0;

end

end

1: begin

if(`M15 == 1) begin

CoM = 1;

end

nextstate = 2;

end

2: begin

if(K == 1) begin

nextstate = 3;

end

else begin

nextstate = 2;

end

if(`M == 0) begin

Sh = 1;

Cnt = 1;

end

else begin

AdSh = 1;

Cnt = 1;

end

end

3: begin

if(Pneg == 1) begin

CoP = 1;

end

nextstate = 4;

end

4: begin

Done = 1;

if(St == 1) begin

nextstate = 4;

end

else begin

nextstate = 0;

end

end

default: begin

end

endcase

end

always @(posedge CLK)

begin

state <= nextstate;

if(Cnt == 1) begin

if(Cntr == 15) begin

Cntr <= 0;

end

else begin

Cntr <= Cntr + 1;

end

end

if(Sh == 1) begin

`ACC <= {1'b0, RegA[31:17]};

`RegM <= {RegA[16], RegA[15:1]};

end

if(AdSh == 1) begin

`ACC <= Addout[16:1];

`RegM <= {Addout[0], RegA[15:1]};

end

if(Load == 1) begin

`ACC <= 0;

`RegM <= Mplier;

Sign <= Mplier[15];

RegB <= Mcand;

end

if(CoM == 1) begin

`RegM <= (!Mplier) + 1;

end

if(CoP == 1) begin

RegA <= (!RegA) + 1;

end

end

endmodule