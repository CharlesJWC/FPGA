module tb_ROM8X2;

reg A,B,C;
wire F,G;

ROM8X2 t_ROM8X2
(
	.A(A),
	.B(B),
	.C(C),
	.F(F),
	.G(G)
);

initial
begin
	A = 0;
	B = 0;
	C = 0;
end

initial
begin
	#10 {A,B,C} = 3'b001;
	#10 {A,B,C} = 3'b010;
	#10 {A,B,C} = 3'b001;
	#10 {A,B,C} = 3'b101;
	#10 {A,B,C} = 3'b111;
end

endmodule
