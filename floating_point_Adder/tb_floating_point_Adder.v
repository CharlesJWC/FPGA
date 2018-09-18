`timescale 1ns / 1ps
module tb_floating_point_Adder;

reg CLK, St;
reg [4:0] F1, F2;
reg [3:0] E1, E2;
wire V, Done;

floating_point_Adder t_floating_point_Adder(CLK, St, F1, F2, E1, E2, Fnorm, V, Done);

parameter N = 6;
integer i;
reg [4:0] Test_F1[1:N];
reg [4:0] Test_F2[1:N];
reg [3:0] Test_E1[1:N];
reg [3:0] Test_E2[1:N];

initial 
begin
	CLK = 0;
	St = 0;
	F1 = 0;
	F2 = 0;
	E1 = 0;
	E2 = 0;
	
	Test_F1[1] = 5'b01010;
	Test_F2[1] = 5'b01100;
	Test_E1[1] = 4'b1001;
	Test_E2[1] = 4'b1010;
	
	Test_F1[2] = 5'b01010;
	Test_F2[2] = 5'b11100;
	Test_E1[2] = 4'b1001;
	Test_E2[2] = 4'b1010;
	
	Test_F1[3] = 5'b11010;
	Test_F2[3] = 5'b01100;
	Test_E1[3] = 4'b1001;
	Test_E2[3] = 4'b1010;
	
	Test_F1[4] = 5'b11010;
	Test_F2[4] = 5'b11100;
	Test_E1[4] = 4'b1001;
	Test_E2[4] = 4'b1010;
	
	Test_F1[5] = 5'b01010;
	Test_F2[5] = 5'b00000;
	Test_E1[5] = 4'b1001;
	Test_E2[5] = 4'b1000;
	
	Test_F1[6] = 5'b01010;
	Test_F2[6] = 5'b01100;
	Test_E1[6] = 4'b1100;
	Test_E2[6] = 4'b1101;
end

always
begin
	#5 CLK = ~CLK;
end


initial
begin
	for(i = 1; i <= N; i = i+1)
	begin
		F1 <= Test_F1[i];
		F2 <= Test_F2[i];
		E1 <= Test_E1[i];
		E2 <= Test_E2[i];
		St <= 1'b1;
		@(posedge CLK);
		St <= 1'b0;
		@(negedge Done);
	end
	$display("TEST END!");
end

endmodule 