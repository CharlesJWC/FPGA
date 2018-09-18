/*    bcd_7segment.v �ҽ� �ڵ�    */

// bcd �Է½�ȣ�� ���� 7segment ��½�ȣ�� ���� ���ڴ� ���
module bcd_7segment(bcd,segment);
// bcd�� segment ����� ��Ʈ�� ������ ������ ��� ����

input [3:0] bcd; // 4��Ʈ ũ���� �Է� ��Ʈ ���� (A, B, C, D)
output reg [6:0] segment; // 7��Ʈ ũ���� ��� ��Ʈ ����
// ���� ��ȭ�� �ֱ����Ͽ� reg�� ���� (a, b, c, d, e, f, g)

always @(bcd)
// t=0���� bcd ���� ��ȭ�� �� ���� �Ʒ� �ൿ ����
begin 
	case(bcd) // bcd���� ���� segment ��°� ����
		4'd0 : segment = 7'b111_111_0; // 0 ǥ��
		4'd1 : segment = 7'b011_000_0; // 1 ǥ��
		4'd2 : segment = 7'b110_110_1; // 2 ǥ��
		4'd3 : segment = 7'b111_100_1; // 3 ǥ��
		4'd4 : segment = 7'b011_001_1; // 4 ǥ��
		4'd5 : segment = 7'b101_101_1; // 5 ǥ��
		4'd6 : segment = 7'b101_111_1; // 6 ǥ��
		4'd7 : segment = 7'b111_000_0; // 7 ǥ��
		4'd8 : segment = 7'b111_111_1; // 8 ǥ��
		4'd9 : segment = 7'b111_101_1; // 9 ǥ��
		default : segment = 7'b000_000_1; // �̿ܿ� ��쿡�� -�� ǥ��
		// �������� ���� �� �������� Ȯ���� ����
	endcase 
end

endmodule //bcd to 7segment ���ڴ� ��� ��� �Ϸ�