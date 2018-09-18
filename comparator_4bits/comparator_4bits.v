module comparator_4bits(a, b, equal, a_greater, b_greater);
// 비교할 2개의 4bits 입력 신호 포트와 3가지 결과 출력 포트를 가진 비교기 모듈

// 4bits 크기의 비교할 a, b 두 입력 신호 설정 
input [3:0] a;	
input [3:0] b;

// a와 b 신호를 비교한 논리 결과에 따른 3가지 출력 신호 설정
output equal;		// a = b인 경우
output a_greater;	// a > b인 경우
output b_greater;	// a < b인 경우


// 아래 각각 3가지가 비교연산자의 결과를 각 출력 신호에 할당
// 연속 수행 명령어로 연산이 동시에 수행된다.
assign equal = (a==b) ? 1:0;	// a=b 일경우 high 아니면 low
assign a_greater = (a>b) ? 1:0; // a>b 일경우 high 아니면 low
assign b_greater = (a<b) ? 1:0; // a<b 일경우 high 아니면 low

endmodule //4bits 비교기 모듈 기술 완료