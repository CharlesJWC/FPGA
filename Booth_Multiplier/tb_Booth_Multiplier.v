`timescale 1ns/1ps
`define MPNum 8
`define MPCNum 8
`define PDNum 15 //`MPNum+`MCNum-1

module tb_Booth_Multiplier;

parameter N = 5;
reg[`MPNum-1:0] McandTest[1:N];
reg[`MPCNum-1:0] MplierTest[1:N];
reg[`PDNum-1:0] ProdAnsTest[1:N];
integer i;

reg clk;
reg St;
reg[`MPNum-1:0] Multiplier;
reg[`MPCNum-1:0] Multiplicand;

wire[`PDNum-1:0] Product;
wire Ready;

Booth_Multiplier t_Booth_Multiplier
(
	.clk(clk),
	.St(St),
	.Mtp(Multiplier),
	.Mtc(Multiplicand),
	.Ready(Ready),
	.Product(Product)
);


initial
begin
	clk = 1'b1;
	St = 1'b0;
	Multiplier = 0;
	Multiplicand = 0;

	McandTest[1] = 8'b01100110;		// 102
	MplierTest[1] = 8'b00110011;	// 51
	ProdAnsTest[1] = 5202; 
	
	McandTest[2] = 8'b10100110;		// -90
	MplierTest[2] = 8'b01100110;	// 102
	ProdAnsTest[2] = -9180; 
	
	McandTest[3] = 8'b01101011;		// 107
	MplierTest[3] = 8'b10001110;	// -114
	ProdAnsTest[3] = -12198; 		
	
	McandTest[4] = 8'b11001100;		// -52
	MplierTest[4] = 8'b10011001;	// -103
	ProdAnsTest[4] = 5356; 

	McandTest[5] = -9;		
	MplierTest[5] = -13;
	ProdAnsTest[5] = 117; 
	
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
		@(posedge Ready);
		if(~(Product == ProdAnsTest[i]))
			$display("BEEP! WRONG ANSWER!! GO TO QURTUS2 AGAIN");
	end
	$display("TEST END!");
end

endmodule


