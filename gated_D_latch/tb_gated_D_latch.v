module tb_gated_D_latch;

reg t_D;
reg t_G;
wire t_Q;
wire t_Qbar;

gated_D_latch t_gated_D_latch
(
	.D(t_D),
	.G(t_G),
	.Qbar(t_Qbar),
	.Q(t_Q)
);

initial
begin	
	t_D = 1'b1; 
	t_G = 1'b1;
end


always	// t = 0 일 때부터 20ns마다 EN신호 변화(Toggle)
begin
	#20 t_G = ~t_G;
end

always // t = 0 일 때부터 5ns마다 입력 신호 변화
begin 
	#50 t_D = 1'b1;
	#50 t_D = 1'b0;
end

endmodule