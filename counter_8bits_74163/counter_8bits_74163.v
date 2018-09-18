module counter_8bits_74163
(
	input clk,
	input Load_N,
	input Clear_N,
	input P,
	input T,
	input [3:0] Din1,
	input [3:0] Din2,
	output [3:0] Qout1,
	output [3:0] Qout2,
	output [1:0] Carry
);

counter_74163 Lower_Counter
(
	.clk(clk),
	.Load_N(Load_N),
	.Clear_N(Clear_N),
	.P(P),
	.T(T),
	.D(Din1),
	.Q(Qout1),
	.Carry(Carry[0])
);

counter_74163 Upper_Counter
(
	.clk(clk),
	.Load_N(Load_N),
	.Clear_N(Clear_N),
	.P(P),
	.T(T),
	.D(Din2),
	.Q(Qout2),
	.Carry(Carry[1])
);

endmodule 