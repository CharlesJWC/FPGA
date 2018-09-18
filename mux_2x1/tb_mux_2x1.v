module tb_mux_2x1();

reg in0_t, in1_t, select_t;
wire out_t;

mux_2x1 mux_2x1_tb
(
	.in0(in0_t),
	.in1(in1_t),
	.select(select_t),
	.out(out_t)
);

initial
begin
	in0_t = 0;
	in1_t = 0;
	select_t = 0;
end

always
begin
	#5 in0_t = 1;
	#5 in0_t = 0;
end

always
begin
	#20 select_t = 1;
	#20 select_t = 0;
end

endmodule
