module tb_comparator_4bits; 
//4bits 비교기 시뮬레이션을 위한 테스트벤지 모듈 구현 

reg [3:0] t_a;  // 4bit 크기의 reg형 포트 설정
reg [3:0] t_b;  // 4bit 크기의 reg형 포트 설정
// 비교할 두 값은 변화할 수 시간에 따라 변화시키기 위해 reg 형으로 선언

wire t_equal;		// a=b 출력 결과
wire t_a_greater;   // a>b 출력 결과
wire t_b_greater;   // a<b 출력 결과
// 모듈의 출력결과를 나타내는 포트로 wire형 선언


comparator_4bits t_comparator_4bits 
// 4its 비교기 모듈 객체 선언 및 이름을 통한 포트 매핑
(
	.a(t_a),
	.b(t_b),
	.equal(t_equal),
	.a_greater(t_a_greater),
	.b_greater(t_b_greater)
);

initial
// t=0 일때 a=0, b=15로 신호 값 초기화
begin
	t_a = 4'd0;
	t_b = 4'd15;
end

initial
// t=0일때 부터 순차적으로 아래 행동을 한번만 수행
begin 
	#10 t_a = 4'd5; t_b = 4'd5;	 //a=5 b=5
	#10 t_a = 4'd5; t_b = 4'd7;  //a=5 b=7
	#10 t_a = 4'd13; t_b = 4'd13;//a=13 b=13
	#10 t_a = 4'd13; t_b = 4'd3; //a=13 b=3
	#10 t_a = 4'd0; t_b = 4'd0;  //a=0 b=0
	// 빠른 변화에도 모듈이 충분히 대처할 수 있는지 테스트
	#1  t_a = 4'd1; t_b = 4'd0;  //a=1 b=0
	#1  t_a = 4'd1; t_b = 4'd1;  //a=1 b=1
	#1  t_a = 4'd0; t_b = 4'd1;  //a=0 b=1
	#1  t_a = 4'd0; t_b = 4'd0;  //a=0 b=0
end

endmodule  // 4bits 비교기 테스트 벤치 모듈 기술 완료