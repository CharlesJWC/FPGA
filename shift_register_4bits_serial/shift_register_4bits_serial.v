module shift_register_4bits_serial( // D_FlipFlop 으로 구현
	input clk,
	input rst,
	input D,
	output [3:0] Q,
	output [3:0] Qbar
);
//wire Qa, c2, c3;

//assign <= Q[0]

D_FlipFlop DFF0(clk, rst, D, Q[0], Qbar[0]);
D_FlipFlop DFF1(clk, rst, Q[0], Q[1], Qbar[1]);
D_FlipFlop DFF2(clk, rst, Q[1], Q[2], Qbar[2]);
D_FlipFlop DFF3(clk, rst, Q[2], Q[3], Qbar[3]);

endmodule