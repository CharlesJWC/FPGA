module decoder_2x4(in, enable, out);
// 입력, 출력, EN신호의 3가지 포트를 가지는 2x4 디코더 모듈 선언
// 2bits 입력을 통한 4가지 경우의 수를 가진 4bits 출력 디코더

input [1:0] in; // 2bits 신호의 입력 설정
input enable;	// EN 신호 입력 설정
output reg [3:0] out; // 4bits 신호의 출력 설정
// 출력의 변화를 위해 값을 저장하여 변경할 수 있는 reg로 설정 

always @(in, enable)
// t = 0 부터 in과 enable의 입력이 변화할 때마다 아래 동작 수행 
begin
	case(enable) // 만약 enable 값이 high인 경우 
	1'b1 :
		/*if(in == 1'b00)
			out = 4'b1110;  // 00
		else if (in == 1'b01)
			out = 4'b1101;  // 01
		else if (in == 1'b10)
			out = 4'b1011;  // 10
		else
			out = 4'b0111; // 11*/
		case(in) // in의 신호에 따른 출력 신호 설정
			2'b00 : out = 4'b1110;  // 00
			2'b01 : out = 4'b1101;  // 01
			2'b10 : out = 4'b1011;  // 10
			default out = 4'b0111; // 11 	
			// 이외의 경우 (in = 2'd3인 경우) 
		endcase
	
	1'b0 : // 그 외의 경우 (enable 값이 low인 경우) 
	
		out = 4'b1111;	// in과 관계없이 모든 비트 high 출력
		// enable 값이 high인 경우와 비교하기 위해 위와 다른 값 설정
	endcase
end

endmodule // 2x4 디코더 모듈 기술 완료