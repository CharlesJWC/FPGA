`define MPNum 16	// 승수 비트수
`define MPCNum 16	// 피승수 비트수
`define ACCNum 32	// 누산기 비트수 : `MPNum+`MCNum

`define ACC_H RegACC[`ACCNum-1:`ACCNum-`MPCNum]	// 누산기의 상위 부분
`define ACC_M RegACC[`MPNum-1:0]				// 누산기의 초기 승수 위치부분
`define M RegACC[0]								// 덧셈 판별비트
`define CMC RegMtc[`MPCNum-1]					// 보수화 여부 판별 비트 신호

module Signed_Multiplier_NbyM	// 제어신호가 없는 부호 있는 곱셈기 모듈 
(
	input clk,	// 클럭 신호
	input St,	// 시작 신호
	input [`MPNum-1:0] Mtp,		// 승수 입력신호
	input [`MPCNum-1:0] Mtc,	// 피승수 입력신호
	output Done,					// 출력완료 신호
	output [`ACCNum-1:0] Product	// 출력결과
);

parameter [1:0] S0 = 2'd0,	// 인코딩된 할당을 위한 상태상수 지정
				S1 = 2'd1,
				S2 = 2'd2,
				S3 = 2'd3;

reg [1:0] state;			// 현재 상태 레지스터
reg [`ACCNum-1:0] RegACC;	// 누산기 레지스터
reg [`MPCNum-1:0] RegMtc;	// 피승수 레지스터
reg CNT;					// 카운터 제어신호

wire CM;					// 승수 보수화 신호
wire Pneg;					// 곱셈결과 보수화 신호
wire K;						// 카운트 완료 신호
wire [`MPCNum-1:0] Addin;	// 2의 보수기 
wire [`MPCNum:0] Addout;	// 가산기 출력


upcounter_4bits counter	// 카운터 모듈 객체 선언 및 이름을 통한 매핑
(
	.clk(clk),	// 클럭 신호 매핑
	.CNT(CNT),	// 동작 신호 매핑
	.K(K)		// 결과 신호 매핑
);

initial		// 모듈 초기화
begin
	state = 2'd0; 
	RegACC = 0; 
	RegMtc = 0;
end


assign CM = Mtp[`MPCNum-1];					// 부호비트 전달
assign Product = RegACC[`ACCNum-1:0];		// 곱셈결과 전달
assign Addin = (`CMC)? (~RegMtc) + 1'b1 : RegMtc;	// 보수기 동작
assign Addout = {1'b0, `ACC_H} + {1'b0, Addin};		// 가산기 동작
assign Pneg = CM ^ `CMC;							// 결과 보수화 판별 신호
assign Done = (state == S3)? 1'd1 : 1'd0;			// 상태 도달시 완료 출력


always @(posedge clk)	// 클럭의 상승엣지에 동작
begin

	CNT = 1'b0;	// 카운터 동작신호 초기화
	
	case(state)
	
	S0 : 
	begin 
		if(St) //시작 신호 발생시
		begin	// 누산기, 피승수 레지스터에 입력 값을 로드하는데 이 과정에서 보수신호가 발생하면 승수를 2의 보수화 시킨다.
			RegACC <= 0;
			if(CM) `ACC_M <= (~Mtp) + 1'b1;
			else `ACC_M <= Mtp;
			RegMtc <= Mtc;
			state <= S1;	// 상태를 S1로 변경
		end
		else state <= S0;  // 시작안하면 유지
	end
	
	S1:
	begin 
		if(K)	// 카운터 완료시
		begin
			if(`M)	// 덧셈 필요한경우
			begin	// 가산기 결과를 누산기에 업데이트
				`ACC_H <= Addout[`MPCNum:1];
				`ACC_M <= {Addout[0], RegACC[`MPNum-1:1]};
			end
			else 
			begin	// 가산기 자리 이동
				`ACC_H <= {1'b0, RegACC[`ACCNum-1:`ACCNum-`MPCNum+1]};
				`ACC_M <= RegACC[`MPNum:1];
			end
			state <= S2;	// 상태를 S2로 변경
		end
		else
		begin	// 카운터 미완료시
			if(`M) // 위 과정과 동일하게 `M신호에 따른 덧셈과 자리이동연산 수행
			begin
				`ACC_H <= Addout[`MPCNum:1];
				`ACC_M <= {Addout[0], RegACC[`MPNum-1:1]};
			end
			else
			begin
				`ACC_H <= {1'b0, RegACC[`ACCNum-1:`ACCNum-`MPCNum+1]};
				`ACC_M <= RegACC[`MPNum:1];
			end
			CNT = 1'b1;	// 카운트 신호 발생
			state <= S1;	// 상태를 S1로 유지
		end
	end

	S2:
	begin 
		if(Pneg)  RegACC <= (~RegACC) + 1'b1;	// 부호신호 활성화시 결과를 2의 보수화 수행
		state <= S3;							// 상태를 S3로 변경
	end
	
	S3:
	begin 
		state <= S0;	// 상태를 S0로 변경
	end
	
	default :
	begin
	end
	
	endcase
end

endmodule	// 제어신호가 없는 부호 있는 곱셈기 모듈 기술 완료
