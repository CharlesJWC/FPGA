module comparator_4bits(a, b, equal, a_greater, b_greater);
// ���� 2���� 4bits �Է� ��ȣ ��Ʈ�� 3���� ��� ��� ��Ʈ�� ���� �񱳱� ���

// 4bits ũ���� ���� a, b �� �Է� ��ȣ ���� 
input [3:0] a;	
input [3:0] b;

// a�� b ��ȣ�� ���� �� ����� ���� 3���� ��� ��ȣ ����
output equal;		// a = b�� ���
output a_greater;	// a > b�� ���
output b_greater;	// a < b�� ���


// �Ʒ� ���� 3������ �񱳿������� ����� �� ��� ��ȣ�� �Ҵ�
// ���� ���� ��ɾ�� ������ ���ÿ� ����ȴ�.
assign equal = (a==b) ? 1:0;	// a=b �ϰ�� high �ƴϸ� low
assign a_greater = (a>b) ? 1:0; // a>b �ϰ�� high �ƴϸ� low
assign b_greater = (a<b) ? 1:0; // a<b �ϰ�� high �ƴϸ� low

endmodule //4bits �񱳱� ��� ��� �Ϸ�