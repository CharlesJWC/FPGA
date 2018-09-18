module tb_MIPS;

reg CLK, rst;
wire CS, WE;
wire [31:0]Addr_Out, Mem_Bus_Wire;

reg init, WE_TB, CS_TB;
reg [31:0] AddressTB;
	
	
parameter N = 10;
reg [31:0] expected[N:1];
integer i;

Complete_MIPS t_MIPS(CLK,rst,init,WE_TB,CS_TB,AddressTB,Addr_Out,Mem_Bus_Wire);

always #10 CLK = ~CLK;

initial 
begin
	expected[1] = 32'h00000006;	// 6
	expected[2] = 32'h00000012;	// 18
	expected[3] = 32'h00000018;	// 24
	expected[4] = 32'h0000000C;	// 12
	expected[5] = 32'h00000002;	// 2
	expected[6] = 32'h00000016;	// 22
	expected[7] = 32'h00000001;	// 1
	expected[8] = 32'h00000120;	// 288
	expected[9] = 32'h00000003;	// 3
	expected[10] = 32'h00412022;// 5th Instruction
	CLK = 0;
end

always 
begin

	rst = 1;
	@(posedge CLK);
	init <=1; CS_TB<=1; WE_TB<=1;
	@(posedge CLK);
	CS_TB<=0; WE_TB<=0; init <=0;
	@(posedge CLK);
	rst <= 0;
	for(i = 1; i <= N; i = i+1)
	begin
		@(posedge WE);
		@(negedge CLK);
		if(Mem_Bus_Wire != expected[i])
			$display("result Mismatch!\n got : %d\t expect : %d",Mem_Bus_Wire,expected[i]);
	end
	$display("Testing Finished!");
	$stop;
end
endmodule 