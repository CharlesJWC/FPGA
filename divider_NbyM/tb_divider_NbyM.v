`timescale 1ns/1ps
`define DVendNum 16
`define DVsorNum 8
`define QuotNum 8 //`DVendNum-`DVsorNum
`define RemnNum 8 // DVsorNum

module tb_divider_NbyM;

parameter N = 8;
reg[`DVendNum-1:0] DVendTest[1:N];
reg[`DVsorNum-1:0] DVsorTest[1:N];
reg[`QuotNum-1:0] QuotAnsTest[1:N];
reg[`RemnNum-1:0] RemainAnsTest[1:N];
integer i;

reg clk;
reg St;
reg[`DVendNum-1:0] Dividend;
reg[`DVsorNum-1:0] Divisor;

wire V;
wire Ready;
wire[`QuotNum-1:0] Quotient;
wire[`RemnNum-1:0] Remainder;

divider_NbyM t_divider_NbyM
(
	.clk(clk),
	.St(St),
	.Dividend_in(Dividend),
	.Divisor_in(Divisor),
	.V(V),
	.Ready(Ready),
	.Quotient(Quotient),
	.Remainder(Remainder)
);

initial
begin
	clk = 1'b0;
	St = 1'b0;
	Dividend = 0;
	Divisor = 0;
	
	DVendTest[1] = 40000;
	DVsorTest[1] = 200;
	QuotAnsTest[1] = 200; 
	RemainAnsTest[1] = 0;
	
	DVendTest[2] = 1300;
	DVsorTest[2] = 250;
	QuotAnsTest[2] = 2; 
	RemainAnsTest[2] = 50;
	
	DVendTest[3] = 65535;
	DVsorTest[3] = 255;
	QuotAnsTest[3] = 0; 
	RemainAnsTest[3] = 0;
	
	DVendTest[4] = 65280;
	DVsorTest[4] = 255;
	QuotAnsTest[4] = 0; 
	RemainAnsTest[4] = 0;
	
	DVendTest[5] = 65279;
	DVsorTest[5] = 255;
	QuotAnsTest[5] = 0; 
	RemainAnsTest[5] = 0;
	
	DVendTest[6] = 10;
	DVsorTest[6] = 0;
	QuotAnsTest[6] = 0; 
	RemainAnsTest[6] = 0;
	
	DVendTest[7] = 777;
	DVsorTest[7] = 7;
	QuotAnsTest[7] = 111; 
	RemainAnsTest[7] = 0;
	
	DVendTest[8] = 0;
	DVsorTest[8] = 0;
	QuotAnsTest[8] = 0; 
	RemainAnsTest[8] = 0;
	
end

always
begin
	#5 clk = ~clk;
end

initial
begin
	for(i = 1; i <=N; i = i+1)
	begin
		Dividend <= DVendTest[i];
		Divisor <= DVsorTest[i];
		St <= 1'b1;
		@(posedge clk);
		St <= 1'b0;
		@(posedge Ready);
		if(~(Quotient == QuotAnsTest[i] && Remainder == RemainAnsTest[i]))
			$display("BEEP! WRONG ANSWER!! GO TO QURTUS2 AGAIN");
	end
	$display("TEST END!");
end

endmodule
