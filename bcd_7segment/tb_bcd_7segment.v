module tb_bcd_7segment;
//bcd to 7segment 디코더 시뮬레이션을 위한 테스트 벤치 모듈 구현

reg [3:0] t_bcd;	// ABCD의 4비트 bcd신호가 전송될 포트
// 입력신호를 변화시키기 위해 reg형 설정
wire [6:0] t_segment; // 7segment 출력 신호가 나타날 포트

bcd_7segment t_bcd_7segment 
// bcd to 7segment 디코더 객체선언 및 이름을 통한 포트 매핑
(
	.bcd(t_bcd),
	.segment(t_segment)
);

initial
begin
	#0  t_bcd = 4'h0; // bcd신호 0입력
	#10 t_bcd = 4'h1;	// bcd신호 1입력
	#10 t_bcd = 4'h2;	// bcd신호 2입력
	#10 t_bcd = 4'h3;	// bcd신호 3입력
	#10 t_bcd = 4'h4;	// bcd신호 4입력
	#10 t_bcd = 4'h5;	// bcd신호 5입력
	#10 t_bcd = 4'h6;	// bcd신호 6입력
	#10 t_bcd = 4'h7;	// bcd신호 7입력
	#10 t_bcd = 4'h8;	// bcd신호 8입력
	#10 t_bcd = 4'h9;	// bcd신호 9입력
	#10 t_bcd = 4'ha;	// bcd신호 10입력
	#10 t_bcd = 4'hb;	// bcd신호 11입력
	#10 t_bcd = 4'hc;	// bcd신호 12입력
	#10 t_bcd = 4'hd;	// bcd신호 13입력
	#10 t_bcd = 4'he;	// bcd신호 14입력
	#10 t_bcd = 4'hf;	// bcd신호 15입력
end

endmodule // bcd to 7segment 디코더 테스트 벤치 모듈 기술 완료