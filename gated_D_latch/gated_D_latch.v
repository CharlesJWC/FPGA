module gated_D_latch
(
	input D,
	input G,
	output Qbar,
	//output reg Q
	output Q
);

//����� ���ÿ� ����� ����� ��Ʈ ����
// Q�� �Է¿� ���� ���� ��ȭ�ϸ� 
//�������¸� ����ϰ� �־�� �ϹǷ� reg�� ����
/*
assign Qbar = ~Q;


always @(D or G)
begin 
	if(G) Q <= D;
	else Q <= Q; // ������������
end
*/

wire s1, s2, s3;
nand #1 NA1(s1, G, D);
nand #1 NA2(s2, D, D); 
nand #1 NA3(s3, s2, G);
nand #1 NA4(Q, s1, Qbar);
nand #1 NA5(Qbar, Q, s3);

//assign Q = (D&G)|(~G&Q);
//assign Q = (D&G)|(~G&Q)|(D&Q);

endmodule