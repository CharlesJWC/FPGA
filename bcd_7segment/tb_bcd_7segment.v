module tb_bcd_7segment;
//bcd to 7segment ���ڴ� �ùķ��̼��� ���� �׽�Ʈ ��ġ ��� ����

reg [3:0] t_bcd;	// ABCD�� 4��Ʈ bcd��ȣ�� ���۵� ��Ʈ
// �Է½�ȣ�� ��ȭ��Ű�� ���� reg�� ����
wire [6:0] t_segment; // 7segment ��� ��ȣ�� ��Ÿ�� ��Ʈ

bcd_7segment t_bcd_7segment 
// bcd to 7segment ���ڴ� ��ü���� �� �̸��� ���� ��Ʈ ����
(
	.bcd(t_bcd),
	.segment(t_segment)
);

initial
begin
	#0  t_bcd = 4'h0; // bcd��ȣ 0�Է�
	#10 t_bcd = 4'h1;	// bcd��ȣ 1�Է�
	#10 t_bcd = 4'h2;	// bcd��ȣ 2�Է�
	#10 t_bcd = 4'h3;	// bcd��ȣ 3�Է�
	#10 t_bcd = 4'h4;	// bcd��ȣ 4�Է�
	#10 t_bcd = 4'h5;	// bcd��ȣ 5�Է�
	#10 t_bcd = 4'h6;	// bcd��ȣ 6�Է�
	#10 t_bcd = 4'h7;	// bcd��ȣ 7�Է�
	#10 t_bcd = 4'h8;	// bcd��ȣ 8�Է�
	#10 t_bcd = 4'h9;	// bcd��ȣ 9�Է�
	#10 t_bcd = 4'ha;	// bcd��ȣ 10�Է�
	#10 t_bcd = 4'hb;	// bcd��ȣ 11�Է�
	#10 t_bcd = 4'hc;	// bcd��ȣ 12�Է�
	#10 t_bcd = 4'hd;	// bcd��ȣ 13�Է�
	#10 t_bcd = 4'he;	// bcd��ȣ 14�Է�
	#10 t_bcd = 4'hf;	// bcd��ȣ 15�Է�
end

endmodule // bcd to 7segment ���ڴ� �׽�Ʈ ��ġ ��� ��� �Ϸ�