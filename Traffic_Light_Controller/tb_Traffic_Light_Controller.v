`timescale 1ns/1ps

module tb_Traffic_Light_Controller;

reg t_clk;
reg t_rst;
reg t_fsX;
wire[1:0] t_hwy_TL;
wire[1:0] t_fwy_TL;

Traffic_Light_Controller t_TLC
(
	.clk(t_clk),
	.rst(t_rst),
	.farm_sensor_X(t_fsX),
	.hwy_TL(t_hwy_TL),
	.fwy_TL(t_fwy_TL)
);

initial
begin
	t_clk = 1'b1;
	t_rst = 1'b1;
	t_fsX = 1'b0;
	// ST : S0, NST : S0, hwy : GREEN, fwy : RED
end

always
begin
	#5 t_clk = ~t_clk;
end

initial
begin
	#10 t_fsX = 1'b0; t_rst = 1'b0;
	// No car in fwy
	#30 t_fsX = 1'b1; 
	// car appear in fwy
	#40 t_fsX = 1'b0;
	// car had gone in fwy
	#40 t_fsX = 1'b1;
	#5  t_fsX = 1'b0;
	// Sensor malfunction
	#25 t_fsX = 1'b1;
	// car appear in fwy
	#30 t_fsX = 1'b1; t_rst = 1'b1;
	#5  t_rst = 1'b0;
	// Lightining Strike the Controller
	#25 t_fsX = 1'b0;
	// car had gone in fwy
end

endmodule
