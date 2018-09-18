`timescale 1ns/1ps
`define MPNum 16
`define MPCNum 16
`define ACCNum 32//`MPNum+`MCNum

module tb_Signed_Multiplier_NbyM;

parameter N = 6;
reg[`MPNum-1:0] McandTest[1:N];
reg[`MPCNum-1:0] MplierTest[1:N];
reg[`ACCNum-1:0] ProdAnsTest[1:N];
integer i;

reg clk;
reg St;
reg[`MPNum-1:0] Multiplier;
reg[`MPCNum-1:0] Multiplicand;
wire Done;
wire[`ACCNum-1:0] Product;

Signed_Multiplier_NbyM t_Signed_Multiplier_NbyM
(
	.clk(clk),
	.St(St),
	.Mtp(Multiplier),
	.Mtc(Multiplicand),
	.Done(Done),
	.Product(Product)
);


initial
begin
	clk = 1'b1;
	St = 1'b0;
	Multiplier = 0;
	Multiplicand = 0;
	
	McandTest[1] = 200;
	MplierTest[1] = 200;
	ProdAnsTest[1] = 40000; 
	
	McandTest[2] = -15;
	MplierTest[2] = 60;
	ProdAnsTest[2] = -900; 
	
	McandTest[3] = 120;
	MplierTest[3] = -250;
	ProdAnsTest[3] = -30000; 
	
	McandTest[4] = -7;
	MplierTest[4] = -111;
	ProdAnsTest[4] = 777; 
	
	McandTest[5] = 255;
	MplierTest[5] = 255;
	ProdAnsTest[5] = 65025; 
	
	McandTest[6] = 255;
	MplierTest[6] = -255;
	ProdAnsTest[6] = -65025; 
	
end

always
begin
	#5 clk = ~clk;
end

initial
begin
	for(i = 1; i <=N; i = i+1)
	begin
		Multiplier <= MplierTest[i];
		Multiplicand <= McandTest[i];
		St <= 1'b1;
		@(posedge clk);
		St <= 1'b0;
		@(negedge Done);
		if(~(Product == ProdAnsTest[i]))
			$display("BEEP! WRONG ANSWER!! GO TO QURTUS2 AGAIN");
	end
	$display("TEST END!");
end

endmodule


