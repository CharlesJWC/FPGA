module D_FlipFlop
(
	input clk,
	input rst,
	input D,
	output reg Q,
	output Qbar
);

assign Qbar = ~Q;	
// Q���� ��ȭ�ϰ� �Ǹ� Qbar���� ������ Q�� �Ҵ�

always @(posedge clk or posedge rst)
//always @(posedge clk)
begin
	if(rst) Q <= 0;
	else Q <= D;
end

endmodule