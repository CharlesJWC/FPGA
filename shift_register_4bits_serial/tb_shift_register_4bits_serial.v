module tb_shift_register_4bits_serial;

reg t_clk;
reg t_rst;
reg t_D;
wire [3:0] t_Q;
wire [3:0] t_Qbar;

shift_register_4bits_serial t_shift_register_4bits_serial
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
	t_D = 1'b0;
end

always
begin
	#5 t_clk = ~t_clk;
end

initial
begin
	#10 t_D = 1'b1; t_rst = 1'b0;
	#10 t_D = 1'b0; t_rst = 1'b0;
	#10 t_D = 1'b1; t_rst = 1'b0;
	#10 t_D = 1'b1; t_rst = 1'b0;
	#10 t_D = 1'b0; t_rst = 1'b1;
	#10 t_D = 1'b1; t_rst = 1'b1;
	#10 t_D = 1'b1; t_rst = 1'b0;
	#10 t_D = 1'b1; t_rst = 1'b0;
	#10 t_D = 1'b0; t_rst = 1'b0;
	#10 t_D = 1'b1; t_rst = 1'b0;
	#10 t_D = 1'b1; t_rst = 1'b0;
	#10 t_D = 1'b1; t_rst = 1'b1;
end

endmodule