module ROM8X3
(
	input X, clk,
	output reg Z
);

reg [2:1] Q, D;
reg [2:0] ROM[0:7];
reg [2:0] ROM_out;
reg [2:0] ROM_in;

initial
begin
	Q = 2'b00;
	D = 2'b00;
	ROM[0] = 3'b010;
	ROM[1] = 3'b101;
	ROM[2] = 3'b101;
	ROM[3] = 3'b001;
	ROM[4] = 3'b001;
	ROM[5] = 3'b010;
	ROM[6] = 3'b000;
	ROM[7] = 3'b000;
end

always @(Q, X)
begin
	ROM_in = {Q, X};
	ROM_out = ROM[ROM_in];
	#10 D = ROM_out[2:1];
	#10 Z = ROM_out[0];
end

always @(negedge clk)
begin
	#15 Q <= D;
end

endmodule
