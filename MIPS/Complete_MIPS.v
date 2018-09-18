module Complete_MIPS
(
	input CLK,
	input RST,
	output [31:0] A_Out,
	output [31:0] B_Out
);

wire CS, WE;
wire [31:0] ADDR, Mem_Bus;
assign A_Out = ADDR;
assign B_Out = Mem_Bus;

MIPS CPU(CLK, RST, CS, WE, ADDR, Mem_Bus);
Memory MEM(CS,WE,CLK,ADDR,Mem_Bus);

endmodule
