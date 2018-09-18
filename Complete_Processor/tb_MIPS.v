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
	// Data Read Mode, Data Write Mode 확인 
	#10 sw = 10'd3; enter_bar = 1'b0;	// IDLE -> Read Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd1; enter_bar = 1'b0;	// READ(1) - 1번 주소 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 1번 주소값 12345확인 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd2; enter_bar = 1'b0; 	// IDLE -> Save Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd1; enter_bar = 1'b0;	// SAVE(1) - 1번 주소 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd777; enter_bar = 1'b0;// SAVE(2) - 1번 주소값 777입력 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd3; enter_bar = 1'b0;	// IDLE -> Read Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd1; enter_bar = 1'b0;	// READ(1) - 1번 주소 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 1번 주소값 777확인 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd2; enter_bar = 1'b0; 	// IDLE -> Save Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd2; enter_bar = 1'b0;	// SAVE(1) - 2번 주소 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd100; enter_bar = 1'b0;// SAVE(2) - 2번 주소값 100입력 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd2; enter_bar = 1'b0; 	// IDLE -> Save Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd3; enter_bar = 1'b0;	// SAVE(1) - 3번 주소 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd30; enter_bar = 1'b0;// SAVE(2) - 3번 주소값 30입력 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd2; enter_bar = 1'b0; 	// IDLE -> Save Mode
	#10 enter_bar = 1'b1;
	#10 sw = 10'd0; enter_bar = 1'b0;	// SAVE(1) - 0번 주소 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd0; enter_bar = 1'b0;	// SAVE(2) - 0번 주소값 0입력 
	#10 enter_bar = 1'b1;
	
	// Opcode Input Mode, Opcode Execution Mode 확인 (add, sub, mul, div 결과 저장) 
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
	#10 sw = 10'd4; enter_bar = 1'b0;	// READ(1) - 4번 주소 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 4번 주소값 130확인 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd3; enter_bar = 1'b0;	// IDLE -> Read Mode
	#10 enter_bar = 1'b1;	
	#10 sw = 10'd5; enter_bar = 1'b0;	// READ(1) - 5번 주소 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 5번 주소값 70확인 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd3; enter_bar = 1'b0;	// IDLE -> Read Mode
	#10 enter_bar = 1'b1;	
	#10 sw = 10'd6; enter_bar = 1'b0;	// READ(1) - 6번 주소 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 6번 주소값 3000확인 
	#10 enter_bar = 1'b1;
	#10 sw = 10'd3; enter_bar = 1'b0;	// IDLE -> Read Mode
	#10 enter_bar = 1'b1;	
	#10 sw = 10'd7; enter_bar = 1'b0;	// READ(1) - 7번 주소 
	#10 enter_bar = 1'b1;
	#10 enter_bar = 1'b0;				// READ(2) - 7번 주소값 3확인 
	#10 enter_bar = 1'b1;
	
	// Opcode Input Mode, Opcode Execution Mode 확인 (add, sub, mul, div 결과 출력) 
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
	
	// Opcode Input Mode, Opcode Execution Mode 확인 (add(생략), sub, mul, div 오버플로우 예외처리) 
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

	// Opcode Input Mode, Opcode Execution Mode 확인 (addi, subi, muli, divi 결과 출력) 
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
	
	// state rest, memory reset 확인
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