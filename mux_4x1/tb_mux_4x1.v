module tb_mux_4x1();

reg in0_t, in1_t, in2_t, in3_t;
reg [1:0] select_t;
wire out_t;

mux_4x1 mux_4x1_tb
(
	.in0(in0_t),
	.in1(in1_t),
	.in2(in2_t),
	.in3(in3_t),
	.select(select_t),
	.out(out_t)
);

initial
begin
	in0_t = 0;
	in1_t = 0;
	in2_t = 1;
	in3_t = 0;
	select_t = 0;
end

always
begin
	#5 in0_t = 1;
	#5 in0_t = 0;
end

always
begin
	#30 in3_t = 1;
	#30 in3_t = 0;
end

always
begin
	#50 select_t = 1;
	#50 select_t = 2;
	#50 select_t = 3;
	#50 select_t = 0;
end

endmodule

	

