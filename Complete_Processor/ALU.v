module ALU
(
	input [15:0] A_Data,
	input [15:0] B_Data, 
	input [1:0] opcode,
	
	output reg OF,
	output reg [15:0] ALU_result
);
    
parameter	add = 2'b00,
			sub = 2'b01,
			mul = 2'b10,
			div = 2'b11;

reg [31:0] temp;

initial
begin   
   OF = 1'b0;
   ALU_result = 16'd0;
   temp = 32'd0;
end

always @(*)
begin
OF = 1'b0;
ALU_result = 16'd0;
temp = 32'd0;

	case(opcode)

	add:
	begin
		temp = A_Data + B_Data;
		if(temp > 32'h0000FFFF) 
		begin
			OF = 1'b1;
		end
		else 
		begin
			ALU_result = temp;
		end
	end

	sub:
	begin
		if(B_Data > A_Data) 
		begin
			OF = 1'b1;
		end
		else 
		begin
			ALU_result = A_Data - B_Data;
		end
	end

	mul:
	begin
		temp = A_Data * B_Data;
		if(temp > 32'h0000FFFF) 
		begin
			OF = 1'b1;
		end
		else 
		begin
			ALU_result = temp;
		end
	end

	div:
	begin 
		if(B_Data == 16'd0) 
		begin
			OF = 1'b1;
		end
		else 
		begin
			ALU_result = A_Data / B_Data;
		end
	end

	endcase
end

endmodule 