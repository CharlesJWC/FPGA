module D_FlipFlop
(
	input clk,
	input rst,
	input D,
	output reg Q,
	output Qbar
);

assign Qbar = ~Q;	
// Q값이 변화하게 되면 Qbar값에 반전된 Q값 할당

always @(posedge clk or posedge rst)
//always @(posedge clk)
begin
	if(rst) Q <= 0;
	else Q <= D;
end

endmodule