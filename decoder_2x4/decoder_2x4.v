module decoder_2x4(in, enable, out);
// �Է�, ���, EN��ȣ�� 3���� ��Ʈ�� ������ 2x4 ���ڴ� ��� ����
// 2bits �Է��� ���� 4���� ����� ���� ���� 4bits ��� ���ڴ�

input [1:0] in; // 2bits ��ȣ�� �Է� ����
input enable;	// EN ��ȣ �Է� ����
output reg [3:0] out; // 4bits ��ȣ�� ��� ����
// ����� ��ȭ�� ���� ���� �����Ͽ� ������ �� �ִ� reg�� ���� 

always @(in, enable)
// t = 0 ���� in�� enable�� �Է��� ��ȭ�� ������ �Ʒ� ���� ���� 
begin
	case(enable) // ���� enable ���� high�� ��� 
	1'b1 :
		/*if(in == 1'b00)
			out = 4'b1110;  // 00
		else if (in == 1'b01)
			out = 4'b1101;  // 01
		else if (in == 1'b10)
			out = 4'b1011;  // 10
		else
			out = 4'b0111; // 11*/
		case(in) // in�� ��ȣ�� ���� ��� ��ȣ ����
			2'b00 : out = 4'b1110;  // 00
			2'b01 : out = 4'b1101;  // 01
			2'b10 : out = 4'b1011;  // 10
			default out = 4'b0111; // 11 	
			// �̿��� ��� (in = 2'd3�� ���) 
		endcase
	
	1'b0 : // �� ���� ��� (enable ���� low�� ���) 
	
		out = 4'b1111;	// in�� ������� ��� ��Ʈ high ���
		// enable ���� high�� ���� ���ϱ� ���� ���� �ٸ� �� ����
	endcase
end

endmodule // 2x4 ���ڴ� ��� ��� �Ϸ�