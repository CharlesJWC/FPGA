module upcounter_4bits
(
	input clk,
	input rst,
	input up,
	output reg [3:0] q
);

always @(posedge clk)
begin
	if(rst) q <= 4'd0;
	else
	begin
		if(up) q <= q + 1'b1;
		else q <= q;
	end
end

endmodule