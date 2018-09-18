`define MPNum 16

module upcounter_4bits
(
	input clk,
	input CNT,
	output reg K
);

reg [3:0] Count;

initial 
begin
	K = 1'd0;
	Count = 4'd0;
end


always @(posedge clk)
begin
	K = 1'd0;

	if(CNT)
	begin
		if (Count == `MPNum-1) Count <= 4'd0;
		//if (Count == `MPNum-2) Count <= 4'd0;
		else Count <= Count + 4'd1;
	end
	else Count <= Count;
	
	if (Count == `MPNum-2) K <= 1'd1;
	//if (Count == `MPNum-3) K <= 1'd1;
end

endmodule