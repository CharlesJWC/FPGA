//(a)
/* 
module Q6_37
(
	input clk,
	input A_3,
	output B_0
);



reg [3:0] A, B;

assign B_0 = B[0];

always @(posedge clk)
begin
	
	A <= {A[3], A[3:1]};
	B <= {A[0], B[3:1]};
end

endmodule
*/

//(b)

/*
module Q6_37
(
	input [1:0] C,
	output[1:0] D_out
);

reg [1:0] D;

assign D_out = D;

always @(C)
begin
//D = 0;
	case(C)
	0: D = 2'b11;
	1: D = 2'b10;
	2: D = 2'b00;
	default: 
	begin
	end
	endcase
end

endmodule
*/

//(c)
module Q6_37
(
	input [1:0] C,
	input [3:0] A,B,
	output reg [3:0] E
);

always @(C)
begin

	case(C)
	0: E = A+B;
	1: E = A >>> 2;
	2: E = A-B;
	3: E = A;
	endcase
end

endmodule

