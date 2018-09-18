/*    bcd_7segment.v 소스 코드    */

// bcd 입력신호를 통한 7segment 출력신호를 가진 디코더 모듈
module bcd_7segment(bcd,segment);
// bcd와 segment 입출력 포트를 가지는 디코터 모듈 선언

input [3:0] bcd; // 4비트 크기의 입력 포트 설정 (A, B, C, D)
output reg [6:0] segment; // 7비트 크기의 출력 포트 설정
// 값의 변화를 주기위하여 reg형 설정 (a, b, c, d, e, f, g)

always @(bcd)
// t=0부터 bcd 값이 변화할 때 마다 아래 행동 수행
begin 
	case(bcd) // bcd값에 따른 segment 출력값 설정
		4'd0 : segment = 7'b111_111_0; // 0 표기
		4'd1 : segment = 7'b011_000_0; // 1 표기
		4'd2 : segment = 7'b110_110_1; // 2 표기
		4'd3 : segment = 7'b111_100_1; // 3 표기
		4'd4 : segment = 7'b011_001_1; // 4 표기
		4'd5 : segment = 7'b101_101_1; // 5 표기
		4'd6 : segment = 7'b101_111_1; // 6 표기
		4'd7 : segment = 7'b111_000_0; // 7 표기
		4'd8 : segment = 7'b111_111_1; // 8 표기
		4'd9 : segment = 7'b111_101_1; // 9 표기
		default : segment = 7'b000_000_1; // 이외에 경우에는 -를 표기
		// 전원문제 인지 논리 문제인지 확인을 위함
	endcase 
end

endmodule //bcd to 7segment 디코더 모듈 기술 완료