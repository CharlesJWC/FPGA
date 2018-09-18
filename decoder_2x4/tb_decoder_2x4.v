module tb_deconder_2x4;
// 2x4 디코더 모듈 시뮬레이션을 위한 테스트벤치 모듈 선언

reg [1:0] t_in; // 2bits 입력 신호 포트 설정
reg t_enable; // EN 신호 입력 포트 설정
// 두 입력 신호를 변화시킬 수 있도록 reg형으로 설정 
wire [3:0] t_out; // 4bits 출력 포트 설정
// 디코더 모듈의 출력 값을 받아 출력만 하면 되므로 wire형으로 설정

decoder_2x4 t_decoder_2x4 // 2x4 디코더 모듈 객체 선언
(
	// 모듈의 각 입출력 포트에 시물레이션 포트를 이름을 통한 매핑
	.in(t_in),
	.enable(t_enable),
	.out(t_out)
);

initial // t = 0일 때 모듈 입력값 초기화
begin
	t_in = 2'd0;		//00
	t_enable = 1'b0;	//1(high)
end

always	// t = 0 일 때부터 40ns마다 EN신호 변화(Toggle)
begin
	#40 t_enable = ~t_enable;
end

always // t = 0 일 때부터 10ns마다 입력 신호 변화
begin 
#0	t_in = 2'd0; #10;	//00 -- EN신호 High일 때
// 입력 신호 초기화가 확실하게 완료된 이후 입력 신호를 주기 위하여 #0 추가
	t_in = 2'd1; #10;	//01
	t_in = 2'd2; #10;	//10
	t_in = 2'd3; #10;	//11
	t_in = 2'd0; #10;	//00 -- EN신호 Low일 때
	t_in = 2'd1; #10;	//01
	t_in = 2'd2; #10;	//10
	t_in = 2'd3; #10;	//11
end

endmodule // 2x4 디코더 테스트벤치 모듈 기술 완료