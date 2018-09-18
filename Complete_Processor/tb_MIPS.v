`timescale 1ns / 1ps

 module tb_MIPS;

reg clk_50M;
reg mem_rst_bar;
reg rst_bar;
reg enter_bar;
reg [9:0] sw;
	
wire [7:0] LEDG;
wire [6:0] segment_1000;
wire [6:0] segment_100;
wire [6:0] segment_10;
wire [6:0] segment_1;

// MIPS ahebf todtjd alc tnstjdp Ekfms aoqvld
Complete_Processor MIPS(clk_50M, mem_rst_bar, rst_bar, enter_bar, sw, LEDG, segment_1000, segment_100, segment_10, segment_1);

initial // dlqfurchrlghk
begin
	clk_50M = 1'b1;
	mem_rst_bar = 1'b1;
	rst_bar = 1'b1;
	enter_bar = 1'b1;
	sw = 10'b0000000000;
end

always
begin
	#10 clk_50M = ~clk_50M;
end

initial
begin
	// Data Read Mode, Data Write Mode Ȯ�� 
	#10 sw = 10'd3; enter_bar = 1'b0;	// IDLE -> Read Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd1; enter_bar = 1'b0;	// READ(1) - 1�� �ּ� 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 1�� �ּҰ� 12345Ȯ�� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd2; enter_bar = 1'b0; 	// IDLE -> Save Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd1; enter_bar = 1'b0;	// SAVE(1) - 1�� �ּ� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd777; enter_bar = 1'b0;// SAVE(2) - 1�� �ּҰ� 777�Է� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd3; enter_bar = 1'b0;	// IDLE -> Read Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd1; enter_bar = 1'b0;	// READ(1) - 1�� �ּ� 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 1�� �ּҰ� 777Ȯ�� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd2; enter_bar = 1'b0; 	// IDLE -> Save Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd2; enter_bar = 1'b0;	// SAVE(1) - 2�� �ּ� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd100; enter_bar = 1'b0;// SAVE(2) - 2�� �ּҰ� 100�Է� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd2; enter_bar = 1'b0; 	// IDLE -> Save Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd3; enter_bar = 1'b0;	// SAVE(1) - 3�� �ּ� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd30; enter_bar = 1'b0;// SAVE(2) - 3�� �ּҰ� 30�Է� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd2; enter_bar = 1'b0; 	// IDLE -> Save Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd0; enter_bar = 1'b0;	// SAVE(1) - 0�� �ּ� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd0; enter_bar = 1'b0;	// SAVE(2) - 0�� �ּҰ� 0�Է� 
	#10 enter_bar = 1'b1;
	
	// Opcode Input Mode, Opcode Execution Mode Ȯ�� (add, sub, mul, div ��� ����) 
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010001100; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000001000; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 4 opr Mode = 0(add)  output Mode = 0(save)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010001101; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000001010; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 5 opr Mode = 1(sub)  output Mode = 0(save)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010001110; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000001100; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 6 opr Mode = 2(mul)  output Mode = 0(save)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010001111; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000001110; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 7 opr Mode = 3(div)  output Mode = 0(save)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd3; enter_bar = 1'b0;	// IDLE -> Read Mode
	#10 enter_bar = 1'b1;	
	#10 sw = 10'd4; enter_bar = 1'b0;	// READ(1) - 4�� �ּ� 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 4�� �ּҰ� 130Ȯ�� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd3; enter_bar = 1'b0;	// IDLE -> Read Mode
	#10 enter_bar = 1'b1;	
	#10 sw = 10'd5; enter_bar = 1'b0;	// READ(1) - 5�� �ּ� 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 5�� �ּҰ� 70Ȯ�� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd3; enter_bar = 1'b0;	// IDLE -> Read Mode
	#10 enter_bar = 1'b1;	
	#10 sw = 10'd6; enter_bar = 1'b0;	// READ(1) - 6�� �ּ� 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 6�� �ּҰ� 3000Ȯ�� 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd3; enter_bar = 1'b0;	// IDLE -> Read Mode
	#10 enter_bar = 1'b1;	
	#10 sw = 10'd7; enter_bar = 1'b0;	// READ(1) - 7�� �ּ� 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 7�� �ּҰ� 3Ȯ�� 
	#10 enter_bar = 1'b1;
	
	// Opcode Input Mode, Opcode Execution Mode Ȯ�� (add, sub, mul, div ��� ���) 
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010001100; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000001111; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 7 opr Mode = 0(add)  output Mode = 1(display)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010001101; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000001101; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 6 opr Mode = 1(sub)  output Mode = 1(display)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010001110; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000001011; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 5 opr Mode = 2(mul)  output Mode = 1(display)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;	
	#10 sw = 10'b0010001111; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000001001; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 4 opr Mode = 3(div)  output Mode = 1(display)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	
	// Opcode Input Mode, Opcode Execution Mode Ȯ�� (add(����), sub, mul, div �����÷ο� ����ó��) 
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0011000101; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 3 SR2 = 1 
	#10 sw = 10'b0000001010; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 5 opr Mode = 1(sub)  output Mode = 0(save)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0001000110; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 1 SR2 = 1 
	#10 sw = 10'b0000001100; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 6 opr Mode = 2(mul)  output Mode = 0(save)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010000011; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 0 
	#10 sw = 10'b0000001110; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 7 opr Mode = 3(div)  output Mode = 0(save)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;

	// Opcode Input Mode, Opcode Execution Mode Ȯ�� (addi, subi, muli, divi ��� ���) 
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010001100; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000101001; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 4 opr Mode = 4(addi)  output Mode = 1(display)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010001101; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000101011; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 5 opr Mode = 5(subi)  output Mode = 1(display)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010001110; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000101101; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 6 opr Mode = 6(muli)  output Mode = 1(display)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;	
	#10 sw = 10'b0010001111; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000101111; enter_bar = 1'b0;	// Opcode Input Mode(2)
	#10 enter_bar = 1'b1;	// DR = 7 opr Mode = 7(divi)  output Mode = 1(display)
	#10 enter_bar = 1'b0;						// Opcode Execution Mode
	#10 enter_bar = 1'b1;
	
	// state rest, memory reset Ȯ��
	#10 sw = 10'd4; enter_bar = 1'b0;	// IDLE -> Opcode Input Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'b0010001100; enter_bar = 1'b0;	// Opcode Input Mode(1)
	#10 enter_bar = 1'b1;	// SR1 = 2 SR2 = 3 
	#10 sw = 10'b0000101001; rst_bar = 1'b0;	// Opcode Input Mode(2) -> State Reset!
	#10 rst_bar = 1'b1;
	
	#20 mem_rst_bar = 1'b0;				// IDLE -> Memory Reset!
	#330 mem_rst_bar = 1'b1;
	
end
 
endmodule 