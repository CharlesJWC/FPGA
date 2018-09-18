/*    bcd_7segment.v �ҽ� �ڵ�    */

// bcd �Է½�ȣ�� ���� 7segment ��½�ȣ�� ���� ���ڴ� ���
module bcd_7segment(bcd,segment,c_flag);
// bcd�� segment ����� ��Ʈ�� ������ ������ ��� ����

input [3:0] bcd; // 4��Ʈ ũ���� �Է� ��Ʈ ���� (A, B, C, D)
input c_flag; 
output reg [6:0] segment; // 7��Ʈ ũ���� ��� ��Ʈ ����
// ���� ��ȭ�� �ֱ����Ͽ� reg�� ���� (a, b, c, d, e, f, g)

always @(bcd, c_flag)
// t=0���� bcd ���� ��ȭ�� �� ���� �Ʒ� �ൿ ����
begin 
	if(!c_flag)
	begin
		case(bcd) // bcd���� ���� segment ��°� ����
	
			4'd0 : segment = ~7'b011_111_1; // 0 ǥ��
			4'd1 : segment = ~7'b000_011_0; // 1 ǥ��
			4'd2 : segment = ~7'b101_101_1; // 2 ǥ��
			4'd3 : segment = ~7'b100_111_1; // 3 ǥ��
			4'd4 : segment = ~7'b110_011_0; // 4 ǥ��
			4'd5 : segment = ~7'b110_110_1; // 5 ǥ��
			4'd6 : segment = ~7'b111_110_1; // 6 ǥ��
			4'd7 : segment = ~7'b010_011_1; // 7 ǥ��
			4'd8 : segment = ~7'b111_111_1; // 8 ǥ��
			4'd9 : segment = ~7'b110_111_1; // 9 ǥ��
		
			default : segment = ~7'b100_000_0; // �̿ܿ� ��쿡�� -�� ǥ��
			// �������� ���� �� �������� Ȯ���� ����
		endcase 		
	end
	else
	begin
		case(bcd) // bcd���� ���� segment ��°� ����
	
			4'd0 : segment = ~7'b000_000_0; // none ǥ��
			4'd1 : segment = ~7'b000_011_0; // I ǥ��
			4'd2 : segment = ~7'b101_111_0; // d ǥ��
			4'd3 : segment = ~7'b011_000_0; // l ǥ��
			4'd4 : segment = ~7'b111_100_1; // E ǥ��
			4'd5 : segment = ~7'b101_110_0; // o ǥ��
			4'd6 : segment = ~7'b101_010_0; // n ǥ��
			4'd7 : segment = ~7'b101_000_0; // r ǥ��
			4'd8 : segment = ~7'b001_110_0; // u ǥ��
			4'd9 : segment = ~7'b011_111_1; // O ǥ��
			4'd10: segment = ~7'b111_000_1; // F ǥ��			
		
			default : segment = ~7'b100_000_0; // �̿ܿ� ��쿡�� -�� ǥ��
			// �������� ���� �� �������� Ȯ���� ����
		endcase 		
	end 
end

endmodule //bcd to 7segment ���ڴ� ��� ��� �Ϸ�