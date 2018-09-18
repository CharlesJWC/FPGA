module tb_downcounter_4bits;

reg t_clk;
reg t_rst;
reg t_down;
wire [3:0] t_q;


downcounter_4bits t_downcounter_4bits
(
	.clk(t_clk),
	.rst(t_rst),
	.down(t_down),
	.q(t_q)
);


initial
begin
	t_clk = 1'b1;
	t_rst = 1'b1;
	t_down = 1'b0;
end

always
begin
	#3 t_clk = ~t_clk;
end

initial
begin
	#3  t_rst = 1'b0; t_down = 1'b1;
	#30 t_down = 1'b0;
	#9  t_down = 1'b1;
	#9  t_rst = 1'b1;
	#3  t_rst = 1'b0;
	#66 t_rst = 1'b1;
	#3  t_rst = 1'b0;
end

endmodule