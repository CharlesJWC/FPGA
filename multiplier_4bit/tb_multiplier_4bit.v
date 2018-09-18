`timescale 1ns/1ps
`define MPNum 16
`define MPCNum 16
`define ACCNum 32//`MPNum+`MCNum

module tb_multiplier_4bit;

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

multiplier_4bit t_multiplier_4bit
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
	
	McandTest[1] = 3;
	MplierTest[1] = 3;
	ProdAnsTest[1] = 9; 
	
	McandTest[2] = -3;
	MplierTest[2] = 3;
	ProdAnsTest[2] = -9; 
	
	McandTest[3] = 3;
	MplierTest[3] = -3;
	ProdAnsTest[3] = -9; 
	
	McandTest[4] = -3;
	MplierTest[4] = -3;
	ProdAnsTest[4] = 9; 
	
	McandTest[5] = 7;
	MplierTest[5] = 7;
	ProdAnsTest[5] = 49; 
	
	McandTest[6] = 0;
	MplierTest[6] = -7;
	ProdAnsTest[6] = 0; 
	
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

