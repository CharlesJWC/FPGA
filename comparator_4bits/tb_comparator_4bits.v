module tb_comparator_4bits; 
//4bits �񱳱� �ùķ��̼��� ���� �׽�Ʈ���� ��� ���� 

reg [3:0] t_a;  // 4bit ũ���� reg�� ��Ʈ ����
reg [3:0] t_b;  // 4bit ũ���� reg�� ��Ʈ ����
// ���� �� ���� ��ȭ�� �� �ð��� ���� ��ȭ��Ű�� ���� reg ������ ����

wire t_equal;		// a=b ��� ���
wire t_a_greater;   // a>b ��� ���
wire t_b_greater;   // a<b ��� ���
// ����� ��°���� ��Ÿ���� ��Ʈ�� wire�� ����


comparator_4bits t_comparator_4bits 
// 4its �񱳱� ��� ��ü ���� �� �̸��� ���� ��Ʈ ����
(
	.a(t_a),
	.b(t_b),
	.equal(t_equal),
	.a_greater(t_a_greater),
	.b_greater(t_b_greater)
);

initial
// t=0 �϶� a=0, b=15�� ��ȣ �� �ʱ�ȭ
begin
	t_a = 4'd0;
	t_b = 4'd15;
end

initial
// t=0�϶� ���� ���������� �Ʒ� �ൿ�� �ѹ��� ����
begin 
	#10 t_a = 4'd5; t_b = 4'd5;	 //a=5 b=5
	#10 t_a = 4'd5; t_b = 4'd7;  //a=5 b=7
	#10 t_a = 4'd13; t_b = 4'd13;//a=13 b=13
	#10 t_a = 4'd13; t_b = 4'd3; //a=13 b=3
	#10 t_a = 4'd0; t_b = 4'd0;  //a=0 b=0
	// ���� ��ȭ���� ����� ����� ��ó�� �� �ִ��� �׽�Ʈ
	#1  t_a = 4'd1; t_b = 4'd0;  //a=1 b=0
	#1  t_a = 4'd1; t_b = 4'd1;  //a=1 b=1
	#1  t_a = 4'd0; t_b = 4'd1;  //a=0 b=1
	#1  t_a = 4'd0; t_b = 4'd0;  //a=0 b=0
end

endmodule  // 4bits �񱳱� �׽�Ʈ ��ġ ��� ��� �Ϸ�