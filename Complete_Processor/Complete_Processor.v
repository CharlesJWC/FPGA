`define Mode sw[2:0]
`define sw_addr sw[3:0]
`define I_SR1 instr[14:11]
`define I_SR2 instr[10:7]
`define IM_Data instr[10:7]
`define I_DR  instr[4:1]
`define I_opcode instr[6:5]
`define I_IMM instr[15]
`define I_OPM instr[0]

module Complete_Processor
(
	input clk_50M,
	input mem_rst_bar,
	input rst_bar,
	input enter_bar,
	input [9:0] sw,
	
	output reg [7:0] LEDG,
	output [6:0] segment_1000,
	output [6:0] segment_100,
	output [6:0] segment_10,
	output [6:0] segment_1
);

parameter	IdlE 	= 3'b000,
			donE 	= 3'b001,
			 OVF 	= 3'b010,
			SW_FULL = 3'b011,
			Src_Adr = 3'b100,
			Dst_Adr = 3'b101,
			Data_16 = 3'b110,
			ADDR	= 3'b111;
			
parameter	S1  = 3'b000,
			S21 = 3'b001,
			S22 = 3'b010,
			S31 = 2'b011,
			S32 = 3'b100,
			S41 = 3'b101,
			S42 = 3'b110,
			S5  = 3'b111;
			
parameter	Mode2 = 3'b010,
			Mode3 = 3'b011,
			Mode4 = 3'b100;

parameter	READ = 2'b00,
			WRITE_sv = 2'b01,
			WRITE_mp = 2'b11,
			DISABLE = 2'b10;

reg [2:0] state, nxt_state;
reg [2:0] ts;
reg [15:0] instr; 
reg [3:0] count;

reg [1:0] RegW;
reg [15:0] save_data;
reg [3:0] DR;
reg [3:0] SR1; 
reg [3:0] SR2; 

wire [3:0] DR_select;
wire [15:0] SR1_Data; 
wire [15:0] SR2_Data;
wire [15:0] Write_data;
wire [15:0] Write_data_mp;
wire [15:0] Disp_data;
wire [15:0] segDisp_data;


wire [15:0] A_Data;
wire [15:0] B_Data;
wire [2:0] opcode;
wire op_mode;

wire alu_OF;
wire [15:0] ALU_result;

wire mem_rst, rst, enter;

assign mem_rst = ~mem_rst_bar;
assign rst = ~rst_bar;
assign enter = ~enter_bar;
assign Disp_data = (RegW == READ)? SR1_Data : segDisp_data;

assign A_Data = SR1_Data;
assign B_Data = (`I_IMM)? {12'd0, `IM_Data} : SR2_Data;
assign opcode = `I_opcode;
assign op_mode = `I_OPM; 
assign Write_data = (mem_rst == 1'b1)? 16'd0 :
					(RegW == WRITE_mp)? Write_data_mp : save_data;
assign DR_select = (mem_rst)? count : DR;

RAM_Register pro_rr(clk_50M, RegW, DR_select, SR1, SR2, Write_data, SR1_Data, SR2_Data);
ALU pro_alu(A_Data, B_Data, opcode, alu_OF, ALU_result);
Output_Multiplexer pro_om(ALU_result, op_mode, Write_data_mp, segDisp_data);
pro_7segment_decoder pro_7sd(clk_50M, rst, sw, Disp_data, ts, segment_1000, segment_100, segment_10, segment_1);

initial
begin
	ts = IdlE;
	LEDG = 8'd1;
	count = 4'd0;
	instr = 16'd0; 
	RegW = DISABLE;
	save_data = 16'd0;
	DR = 4'd0;
	SR1 = 4'd0; 
	SR2 = 4'd0; 
	state = S1;
	nxt_state = S1;
end

always @(posedge clk_50M or posedge rst)
begin
	if(rst) state <= S1;
	else state <= nxt_state;
end

always @(posedge clk_50M)
begin
	if(mem_rst) count <= count + 1'b1;
	else count <= 4'd0;
end

always @(posedge enter or posedge rst)
begin

	if(rst) 
	begin
		nxt_state = S1;
	end
	else
	begin
		case(state)
	
		S1 :
		begin
			//save_data <= 16'd0;
			//DR <= 4'd0;
			//SR1 <= 4'd0;
			//SR2 <= 4'd0;
			//instr <= 16'd0;
			if(enter) 
			begin
				case(`Mode)
				Mode2 :
				begin
					nxt_state <= S21;
				end
				Mode3 :
				begin
					nxt_state <= S31;
				end
				Mode4 :
				begin
					nxt_state <= S41;
				end
				default :
				begin
					nxt_state <= S1;
				end
				endcase
			end
			else
			begin
				nxt_state <= S1;
			end
		end
		
		S21 :
		begin
			if(enter) 
			begin
				DR <= `sw_addr; 
				nxt_state <= S22;
			end
			else
			begin
				nxt_state <= S21;
			end
		end
	
		S22 :
		begin
			if(enter) 
			begin
				save_data <= {6'd0, sw};
				nxt_state <= S1;
			end
			else
			begin
				nxt_state <= S22;
			end
		end
			
		S31 :
		begin
			if(enter) 
			begin
				SR1 <= `sw_addr;
				nxt_state <= S32;
			end
		else	
			begin
				nxt_state <= S31;
			end	
		end	

		S32 :
		begin
			if(enter) 
			begin
				nxt_state <= S1;
			end
			else
			begin
				nxt_state <= S32;
			end
		end
	
		S41 :
		begin
			if(enter) 
			begin
				`I_SR1 <= sw[9:6];
				`I_SR2 <= sw[5:2];
				`I_opcode <= sw[1:0];
				nxt_state <= S42;
			end
			else
			begin
				nxt_state <= S41;
			end
		end
	
		S42 :
		begin
			if(enter) 
			begin
				`I_DR <= sw[4:1];
				`I_OPM <= sw[0];
				`I_IMM <= sw[5];
				SR1 <= `I_SR1; 
				SR2 <= `I_SR2;
				DR  <= `I_DR;
				nxt_state <= S5;
			end
			else
			begin
				nxt_state <= S42;
			end
		end
	
		S5 :
		begin
			if(enter) 
			begin
				nxt_state <= S1;
			end
			else
			begin
				nxt_state <= S5;
			end
		end
		
		default : 
		begin
			nxt_state <= S1;
		end
	
		endcase
	end
end

always @(state, alu_OF, op_mode, mem_rst)
begin
RegW = DISABLE;

	case(state)

	S1 :
	begin
		ts = IdlE;
		if(mem_rst)
		begin
			RegW = WRITE_sv;
			LEDG = 8'b11111111;
		end
		else
		begin
			LEDG = 8'b00000001;
		end
	end
	
	S21 :
	begin
		ts = ADDR;
		LEDG = 8'b00000010;
	end

	S22 :
	begin
		ts = SW_FULL;
		LEDG = 8'b00000100;
		RegW = WRITE_sv;
	end
		
	S31 :
	begin
		ts = ADDR;
		LEDG = 8'b00001000;
	end

	S32 :
	begin
		ts = Data_16;
		LEDG = 8'b00010000;
		RegW = READ;
	end

	S41 :
	begin
		ts = Src_Adr;
		LEDG = 8'b00100000;
	end

	S42 :
	begin
		ts = Dst_Adr;
		LEDG = 8'b01000000;
	end

	S5 :
	begin
		if(alu_OF)
		begin
			ts = OVF;
		end
		else
		begin
			if(op_mode)
			begin
				ts = Data_16;
			end
			else 
			begin
				RegW = WRITE_mp;
				ts = donE;
			end
		end
		LEDG = 8'b10000000;
	end
	
	default : 
	begin
		ts = IdlE;
		LEDG = 8'b00000001;
	end

	endcase
end

endmodule 