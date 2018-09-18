module tb_MY_TEST;

reg clk;
wire [5:0] outlet;

MY_TEST t_MY_TEST
(
	.clk(clk),
	.outlet(outlet)
);

initial 
begin
	clk = 0;
end

always
begin
	#5 clk = ~clk;
end


endmodule