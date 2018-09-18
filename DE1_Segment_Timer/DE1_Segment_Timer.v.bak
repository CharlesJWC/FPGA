module DE1_Segment_Timer	// 내부클럭을 이용한 7Segment 타이머 모듈 입출력 포트 설정 
(
	input clk_50M,	// 내부 클럭(50MHz) 입력 신호
	input rst,		// 타이머 초기화 신호
	
	output[6:0] segment_1000,	// 천의 자리 숫자출력
	output[6:0] segment_100,	// 백의 자리 숫자출력
	output[6:0] segment_10,		// 십의 자리 숫자출력
	output[6:0] segment_1		// 일의 자리 숫자출력
);

wire clk_10M;	// PLL회로로부터 10MHz 클럭신호 입력
reg clk_100K;	// 카운터를 활용한 100KHz 클럭신호
reg clk_1K;		// 카운터를 활용한 1KHz 클럭신호
reg clk_10;		// 카운터를 활용한 10Hz 클럭신호
reg clk_1;		// 카운터를 활용한 1Hz 클럭신호

reg[5:0] cnt_10M;	// 10MHz 클럭신호 카운트 
reg[5:0] cnt_100K;	// 100KHz 클럭신호 카운트 
reg[5:0] cnt_1K;	// 1KHz 클럭신호 카운트 
reg[2:0] cnt_10;	// 10Hz 클럭신호 카운트 
reg[5:0] cnt;		// 1Hz 클럭신호 카운트 
reg[5:0] m_cnt;

wire[3:0] digit_1000;	// 천의 자리 십진수 숫자
wire[3:0] digit_100;	// 백의 자리 십진수 숫자
wire[3:0] digit_10;		// 십의 자리 십진수 숫자
wire[3:0] digit_1;		// 일의 자리 십진수 숫자

wire[9:0] mod_1000;		// 천의 자리수 추출후 나머지
wire[6:0] mod_100;		// 백의 자리수 추출후 나머지
wire[3:0] mod_10;		// 십의 자리수 추출후 나머지

wire rst_bar; //-------------

// ---------------
//assign digit_1000 = cnt/10'd1000;					// 1000의 자리수 추출
//assign mod_1000 = cnt - (digit_1000*10'd1000); 	// 1000의 자리수 추출 후 나머지
//assign digit_100 = mod_1000/7'd100;				// 100의 자리수 추출
//assign mod_100 = mod_1000 - (digit_100*7'd100);	// 100의 자리수 추출 후 나머지
//assign digit_10 = mod_100/4'd10;					// 10의 자리수 추출

// ---------------
assign digit_1000 = m_cnt/4'd10;					// 1000의 자리수 추출
assign mod_1000 = m_cnt - (digit_1000*4'd10); 	// 1000의 자리수 추출 후 나머지
assign digit_100 = mod_1000;

assign digit_10 = cnt/4'd10;
assign mod_10 = cnt - (digit_10*4'd10);		// 10의 자리수 추출 후 나머지
assign digit_1 = mod_10;						// 1의 자리수 설정 

assign rst_bar = ~rst;

my_clock_gen clock_gen	// 클럭 신호 모듈 입출력 신호 이름을 통한 매핑
(
	.areset(rst_bar),			// reset 신호 매핑
	.inclk0(clk_50M),		// 50MHz 입력 클럭신호 매핑
	.c0(clk_10M),			// 10MHz 출력 클럭신호 매핑
	.locked()				// 위상 고정 사용하지 않음
);

always@(posedge clk_10M or posedge rst_bar)	// 10MHz 클럭신호 혹은 Reset신호 상승엣지 시
begin
   if(rst_bar)	// Reset신호 발생시
   begin   
      cnt_10M <= 6'd0;	// 10MHz 클럭 카운트 초기화
      clk_100K <= 1'b0;	// 100KHz 클럭 신호 초기화
   end
   
   else 
   begin
      if(cnt_10M == 6'd49)			// 10MHz 클럭 50번 카운트 한 경우
      begin
         cnt_10M <= 6'd0;			// 10MHz 클럭 카운트 초기화 
         clk_100K <= ~clk_100K;		// 클럭신호 Toggle // 총 100번 카운트 시 한주기 클럭 발생 (100KHz 클럭)
      end
      
      else cnt_10M <= cnt_10M + 1'd1;	// 50번 미만의 경우에는 단순히 카운트
   end
end

always@(posedge clk_100K or posedge rst_bar) // 100KHz 클럭신호 혹은 Reset신호 상승엣지 시
begin 
   if(rst_bar)	// Reset신호 발생시
   begin   
      cnt_100K <= 6'd0;	// 100KHz 클럭 카운트 초기화
      clk_1K <= 1'b0;	// 1KHz 클럭 신호 초기화
   end
   else
   begin
      if(cnt_100K == 6'd49)		// 100KHz 클럭 50번 카운트 한 경우
      begin   
         cnt_100K <= 6'd0;		// 100KHz 클럭 카운트 초기화 
         clk_1K <= ~clk_1K;		// 클럭신호 Toggle // 총 100번 카운트 시 한주기 클럭 발생 (1KHz 클럭)
      end
      else
      cnt_100K <= cnt_100K + 1'd1;	// 50번 미만의 경우에는 단순히 카운트
   end
end

always@(posedge clk_1K or posedge rst_bar)	// 1KHz 클럭신호 혹은 Reset신호 상승엣지 시
begin
   if(rst_bar)	// Reset신호 발생시
   begin
      cnt_1K <= 6'd0;	// 1KHz 클럭 카운트 초기화
      clk_10 <= 1'b0;	// 10Hz 클럭 신호 초기화
   end

   else 
   begin
      if(cnt_1K == 6'd49)	// 1KHz 클럭 50번 카운트 한 경우
      begin 
         cnt_1K <= 6'd0;	// 1KHz 클럭 카운트 초기화 
         clk_10 <= ~clk_10;	// 클럭신호 Toggle // 총 100번 카운트 시 한주기 클럭 발생 (10Hz 클럭)
      end
      else cnt_1K <= cnt_1K +1'd1;	// 50번 미만의 경우에는 단순히 카운트
   end
end

always@(posedge clk_10 or posedge rst_bar) // 10Hz 클럭신호 혹은 Reset신호 상승엣지 시
begin
   if(rst_bar)	// Reset신호 발생시
   begin
      cnt_10 <= 3'd0;	// 10Hz 클럭 카운트 초기화
      clk_1 <= 1'b0;	// 1Hz 클럭 신호 초기화
   end
   else
   begin
      if(cnt_10 == 3'd4)	// 10Hz 클럭 5번 카운트 한 경우 
      begin
         cnt_10 <= 3'd0;	// 10Hz 클럭 카운트 초기화 
         clk_1 <= ~clk_1;	// 클럭신호 Toggle // 총 10번 카운트 시 한주기 클럭 발생 (1Hz 클럭)
      end
      
      else cnt_10 <= cnt_10 + 1'd1;	// 5번 미만의 경우에는 단순히 카운트
   end
end

always@(posedge clk_1 or posedge rst_bar) // 1Hz 클럭신호 혹은 Reset신호 상승엣지 시
begin
   if(rst_bar) // Reset신호 발생시
   begin
		cnt<= 6'd0;	// 1Hz 클럭 카운트 초기화  --
		m_cnt<= 6'd0; // ----------------
   end

   else 
   begin 
      if(cnt == 6'd59) 
      begin
		   cnt <= 6'd0;	// 60번 카운트 시 1Hz 클럭 초기화 (60초 = 1분)
		   if(m_cnt == 6'd59) m_cnt <= 6'd0;
		   else m_cnt <= m_cnt + 1'd1;
	  end
      else cnt <= cnt + 1'd1;		// 60번 미만의 경우 카운트
   end
end

// 4개의 Segment 모듈 개체 선언 및 각 순서에 따른 입출력 신호 매핑
bcd_7segment bcd_7segment_1000(digit_1000, segment_1000);	// 천의 자리 숫자 입력 및 7-Segment 출력
bcd_7segment bcd_7segment_100(digit_100, segment_100);		// 백의 자리 숫자 입력 및 7-Segment 출력
bcd_7segment bcd_7segment_10(digit_10, segment_10);			// 십의 자리 숫자 입력 및 7-Segment 출력
bcd_7segment bcd_7segment_1(digit_1, segment_1);			// 일의 자리 숫자 입력 및 7-Segment 출력

endmodule 	// 내부클럭을 이용한 7Segment 타이머 모듈 기술 완료
