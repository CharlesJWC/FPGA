module Moore_Machine
(
	input clk,
	input rst,
	input in,
	output reg out
);

parameter [1:0] S1 = 2'd01,
				S1 = 2'd1,
				S2 = 2'd2,
				S3 = 2'd3;

reg [1:0] state, nxt_state;


/*
initial
begin
out = 1'b0;
state = S0;
nxt_state = S0;
end
*/

always @(posedge clk or posedge rst)
begin 
	if(rst) state <= S0;
	else 	state <= nxt_state;
end

always @(state or in)
begin
//out = 1'b0;
	
	case(state)
	
	S0 : 
	begin 
		out <= 1'b0;
		if(in) nxt_state <= S1;
		else   nxt_state <= S0;
	end
	
	S1:
	begin 
		out <= 1'b0;
		if(in) nxt_state <= S1;
		else   nxt_state <= S2;
	end

	S2:
	begin 
		out <= 1'b0;
		if(in) nxt_state <= S3;
		else   nxt_state <= S0;
	end
	
	S3:
	begin 
		out <= 1'b1;
		if(in) nxt_state <= S1;
		else   nxt_state <= S2;
	end
	
	default :
	begin
		out <= 1'b0;
		nxt_state <= S0;
	end

	endcase
end

endmodule	 