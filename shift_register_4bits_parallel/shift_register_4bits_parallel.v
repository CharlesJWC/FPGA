module shift_register_4bits_parallel(
	input clk,
	input rst,
	input load,
	input [3:0] D,
	output reg [3:0] Q,
	output [3:0] Qbar
);
	
reg [3:0]temp;

always @(posedge clk) 
begin
	if (rst)
		temp <= 1;
	else if (load)
		temp <= D;
	else 
	begin
		Q <= temp[3];
		temp <= {temp[2:0],1'b0};
	end
end

	
/*
D_FlipFlop DFF0(clk, rst, D[0], Q[0], Qbar[0]);
D_FlipFlop DFF1(clk, rst, D[1], Q[1], Qbar[1]);
D_FlipFlop DFF2(clk, rst, D[2], Q[2], Qbar[2]);
D_FlipFlop DFF3(clk, rst, D[3], Q[3], Qbar[3]);
*/
endmodule