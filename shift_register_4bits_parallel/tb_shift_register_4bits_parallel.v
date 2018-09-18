module tb_shift_register_4bits_parallel;

reg t_clk;
reg t_rst;
reg [3:0] t_D;
wire [3:0] t_Q;
wire [3:0] t_Qbar;


shift_register_4bits_parallel t_shift_register_4bits_parallel
(
	.clk(t_clk),
	.rst(t_rst),
	.D(t_D),
	.Q(t_Q),
	.Qbar(t_Qbar)
);

initial
begin
	t_clk = 1'b1;
	t_rst = 1'b0;
	t_D = 4'b0000;
end

always
begin
	#5 t_clk = ~t_clk;
end

initial
begin
	#10 t_D = 4'b1010; t_rst = 1'b0;
	#10 t_D = 4'b1110; t_rst = 1'b0;
	#10 t_D = 4'b1011; t_rst = 1'b1;
	#10 t_D = 4'b1111; t_rst = 1'b1;
	#10 t_D = 4'b1011; t_rst = 1'b0;
	#10 t_D = 4'b1111; t_rst = 1'b0;
	#10 t_D = 4'b1001; t_rst = 1'b1;
	#10 t_D = 4'b1001; t_rst = 1'b0;
end

endmodule