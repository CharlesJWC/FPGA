module counter_74163
(
	input clk,
	input Load_N,
	input Clear_N,
	input P,
	input T,
	input [3:0] D,
	output reg [3:0] Q,
	output Carry
);

assign Carry = ((&Q) & T);

always @(posedge clk)
begin
	if(!Clear_N) Q <= 4'b0000;
	else
	begin
		if(!Load_N) Q <= D;
		else
		begin
			if((P&&T) == 1'b0) Q<=Q;
			else Q <= Q + 1'b1;
		end
	end
end

endmodule
		