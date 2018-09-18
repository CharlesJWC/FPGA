module gated_D_latch
(
	input D,
	input G,
	output Qbar,
	//output reg Q
	output Q
);

//선언과 동시에 모듈의 입출력 포트 설정
// Q는 입력에 따라 값이 변화하며 
//이전상태를 기억하고 있어야 하므로 reg형 설정
/*
assign Qbar = ~Q;


always @(D or G)
begin 
	if(G) Q <= D;
	else Q <= Q; // 이전상태유지
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