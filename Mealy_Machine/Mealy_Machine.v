module Mealy_Machine
(
	input clk,
	input rst,
	input in,
	output reg out
);

parameter [1:0] S0 = 2'd0,
				S1 = 2'd1,
				S2 = 2'd2; //2'd3 Not need
				
reg [1:0] state, nxt_state;

always @(posedge clk or posedge rst) // rst also edge
begin 
	if(rst) state <= S0;
	else 	state <= nxt_state;
end

always @(state or in)
begin
	case(state)
	
	S0 : 
	begin 
		if(in)
		begin
			out <= 1'b0;
			nxt_state <= S0;
		end
	
		else
		begin
			out <= 1'b0;
			nxt_state <= S1;
		end
	end
	
	S1:
	begin 
		if(in)
		begin
			out <= 1'b0;
			nxt_state <= S2;
		end
	
		else
		begin
			out <= 1'b0;
			nxt_state <= S1;
		end
	end

	S2:
	begin 
		if(in)
		begin
			out <= 1'b0;
			nxt_state <= S2;
		end
	
		else
		begin
			out <= 1'b1;
			nxt_state <= S0;
		end
	end
	
	default :
	begin
		out <= 1'b0;
		nxt_state <= S0;
	end
	endcase
end

endmodule	
		