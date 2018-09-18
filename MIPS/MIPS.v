`define opcode instr[31:26]
`define rs instr[25:21]
`define rt instr[20:16]
`define rd instr[15:11]
`define shamt instr[10:6]
`define f_code instr[5:0]

module MIPS
(
	input CLK, RST,
	output reg CS, WE,
	output [31:0] ADDR,
	inout [31: 0] Mem_Bus
);

// (R format) f_code
parameter add  = 6'd32;
parameter sub  = 6'd34;
parameter _xor = 6'd38;
parameter _and = 6'd36;
parameter _or  = 6'd37;
parameter slt  = 6'd42;
parameter srl  = 6'd2;
parameter sll  = 6'd0;
parameter jr   = 6'd8;

// (I, J format) opcode
parameter addi  = 6'd8;
parameter andi  = 6'd12;
parameter ori   = 6'd13;
parameter lw    = 6'd35;
parameter sw    = 6'd43;
parameter beq   = 6'd4;
parameter bne   = 6'd5;
parameter j     = 6'd2;

// format type
parameter R  = 2'd0;
parameter I  = 2'd1;
parameter J  = 2'd2;

reg[5:0] op, opsave;
wire[1:0] format;
reg [31:0] instr, pc, nxt_pc, alu_result;
wire [31:0] imm_ext, alu_in_A, alu_in_B, reg_in, readreg1, readreg2;
reg [31:0] alu_result_save;
reg alu_or_mem, alu_or_mem_save, regw, writing, reg_or_imm, reg_or_imm_save;
reg fetchDorI;
wire [4:0] dr;
reg [2:0] state, nxt_state;

assign imm_ext = (instr[15] == 1)? {16'hFFFF, instr[15:0]} : {16'h0000, instr[15:0]}; // Sign Extend!
assign dr = (format == R)? instr[15:11] : instr[20:16]; // destination MUX
assign alu_in_A = readreg1;
assign alu_in_B = (reg_or_imm_save)? imm_ext : readreg2;	// ALU MUX
assign reg_in = (alu_or_mem_save)? Mem_Bus : alu_result_save; // Data MUX
assign format = (`opcode == 6'd0) ? R : ((`opcode == 6'd2)? J : I); // No jal
assign Mem_Bus = (writing)? readreg2 : 32'bZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ;
assign ADDR = (fetchDorI)? pc : alu_result_save; // ADDR MUX

Register REG(CLK, regw, dr, `rs, `rt, reg_in, readreg1, readreg2);

initial 
begin
	op = _and;
	opsave = _and;
	state = 3'b0;
	nxt_state = 3'b0;
	alu_or_mem = 0;
	regw = 0;
	fetchDorI = 0;
	writing = 0;
	reg_or_imm = 0;
	reg_or_imm_save = 0;
	alu_or_mem_save = 0;
end

always @(*)
begin
	fetchDorI = 0;
	CS = 0; WE = 0;
	regw = 0; writing = 0;
	alu_result = 32'd0;
	nxt_pc = pc; op = jr;
	reg_or_imm = 0; alu_or_mem = 0;
	
	case(state)
		0: begin
			nxt_pc = pc +32'd1; CS = 1; nxt_state = 3'd1;
			fetchDorI = 1;
		end
			
		1: begin
			nxt_state = 3'd2; reg_or_imm = 0; alu_or_mem = 0;
			if(format == J)
			begin
				nxt_pc = {pc[31:26],instr[25:0]};
				nxt_state = 3'd0;
			end
			else if(format == R)
				op = `f_code;
			else if(format == I)
			begin
				reg_or_imm = 1;
				if(`opcode == lw)
				begin
					op = add;
					alu_or_mem = 1;
				end
			end
			else if((`opcode == lw)||(`opcode == sw) || (`opcode == addi))
				op = add;
			else if((`opcode == beq)||(`opcode == bne))
			begin
				op = sub;
				reg_or_imm = 0;
			end
			else if(`opcode == addi) op = _and;
			else if(`opcode == addi) op = _or;
		end
	
		2: begin
			nxt_state = 3'd3;
			if(opsave == _and) alu_result = alu_in_A & alu_in_B;
			else if(opsave == _or) alu_result = alu_in_A | alu_in_B;
			else if(opsave == add) alu_result = alu_in_A + alu_in_B;
			else if(opsave == sub) alu_result = alu_in_A - alu_in_B;
			else if(opsave == srl) alu_result = alu_in_B >> `shamt;
			else if(opsave == sll) alu_result = alu_in_B << `shamt;
			else if(opsave == slt) alu_result = (alu_in_A < alu_in_B)? 32'd1 : 32'd0;
			else if(opsave == _xor) alu_result = alu_in_A ^ alu_in_B;
			if(((alu_in_A == alu_in_B) && (`opcode == beq)) || ((alu_in_A != alu_in_B) && (`opcode == bne)))
			begin
				nxt_pc = pc + imm_ext;
				nxt_state = 3'd0;
			end
			else if ((`opcode == bne) || (`opcode == beq)) nxt_state = 3'd0;
			else if (opsave == jr)
			begin
				nxt_pc = alu_in_A;
				nxt_state = 3'd0;
			end
		end
	
		3: begin
			nxt_state = 3'd0;
			if((format == R)||(`opcode == addi)||(`opcode == andi)||(`opcode == ori)) regw = 1;
			else if (`opcode == sw) 
			begin
				CS = 1;
				WE = 1;
				writing = 1;
			end
			else if (`opcode == lw)
			begin
				CS = 1;
				nxt_state = 3'd4;
			end
		end
			
		4: begin
			nxt_state = 3'd0;
			CS = 1;
			if(`opcode == lw) regw = 1;
		end
	endcase
end
	
always @(posedge CLK)
begin
	if(RST)
	begin
		state <= 3'd0;
		pc <= 32'd0;
	end
	else
	begin
		state <= nxt_state;
		pc <= nxt_pc;
	end
	
	if(state == 3'd0) instr <= Mem_Bus;
	else if(state == 3'd1)
	begin
		opsave <= op;
		reg_or_imm_save <= reg_or_imm;
		alu_or_mem_save <= alu_or_mem;
	end
	else if (state == 3'd2) alu_result_save <= alu_result;
end

endmodule	



